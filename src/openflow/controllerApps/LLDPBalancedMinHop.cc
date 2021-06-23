#include "openflow/controllerApps/LLDPBalancedMinHop.h"
#include <algorithm>
#include <string>
#include <queue>
#include "inet/linklayer/ethernet/common/Ethernet.h"
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"

using namespace std;

Define_Module(LLDPBalancedMinHop);

struct comp {
    bool operator() (const pair<string,int> &a, const pair<string,int> &b) {
        return a.second > b.second;
    }
};


LLDPBalancedMinHop::LLDPBalancedMinHop(){

}

LLDPBalancedMinHop::~LLDPBalancedMinHop(){

}

void LLDPBalancedMinHop::initialize(int stage){
    AbstractControllerApp::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        dropIfNoRouteFound = par("dropIfNoRouteFound");
        ignoreArpRequests = par("ignoreArpRequests");
        printMibGraph = par("printMibGraph");
        lldpAgent = NULL;
        version = -1;
        versionHit = 0;
        versionMiss = 0;
        cacheHit = 0;
        cacheMiss = 0;
        idleTimeout = par("flowModIdleTimeOut");
        hardTimeout = par("flowModHardTimeOut");
    }
}



//void LLDPBalancedMinHop::handlePacketIn(OFP_Packet_In * packet_in_msg){
void LLDPBalancedMinHop::handlePacketIn(Packet *pkt){


    CommonHeaderFields headerFields = extractCommonHeaderFields(pkt);

    //ignore lldp packets
    if(headerFields.eth_type == 0x88CC){
        return;
    }
    auto packet_in_msg = pkt->peekAtFront<OFP_Packet_In>();


    //ignore arp requests
    if(ignoreArpRequests && headerFields.eth_type == ETHERTYPE_ARP && packet_in_msg->getMatch().OFB_ARP_OP == ARP_REQUEST){
        return;
    }


    //compute path for non arps
    auto route = computeBalancedMinHopPath(headerFields.swInfo->getMacAddress(),headerFields.dst_mac.str());

    //if route empty flood
    if(route.empty()){
        if(dropIfNoRouteFound && headerFields.eth_type != ETHERTYPE_ARP){
            dropPacket(pkt);
        } else {
            floodPacket(pkt);
        }
    }else {
        //send packet to next hop
        LLDPPathSegment seg = route.front();
        route.pop_front();
        sendPacket(pkt, seg.outport);

        //set flow mods for all switches under my controller's command
        oxm_basic_match match = oxm_basic_match();
        match.OFB_ETH_DST = headerFields.dst_mac;
        match.OFB_ETH_SRC = headerFields.src_mac;

        match.wildcards= 0;
        match.wildcards |= OFPFW_IN_PORT;
        match.wildcards |= OFPFW_DL_TYPE;


        sendFlowModMessage(OFPFC_ADD, match, seg.outport, controller->findSocketFor(pkt),idleTimeout,hardTimeout);

        //iterate the rest of the route and set flow mods for switches under my control
        while(!route.empty()){
            seg = route.front();
            route.pop_front();
            oxm_basic_match match = oxm_basic_match();
            match.OFB_ETH_DST = headerFields.dst_mac;
            match.OFB_ETH_SRC = headerFields.src_mac;

            match.wildcards= 0;
            match.wildcards |= OFPFW_IN_PORT;
            match.wildcards |= OFPFW_DL_TYPE;


            auto socket = controller->findSocketForChassisId(seg.chassisId);
            //is switch under our control
            if(socket != NULL){
                sendFlowModMessage(OFPFC_ADD, match, seg.outport, socket,idleTimeout,hardTimeout);
            }
        }
    }
}




void LLDPBalancedMinHop::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    AbstractControllerApp::receiveSignal(src,id,obj,details);

    //set lldp link
    Enter_Method("LLDPBalancedMinHop::receiveSignal %s", cComponent::getSignalName(id));
    if(lldpAgent == NULL && controller != NULL){
        auto appList = controller->getAppList();

        for(auto iterApp=appList->begin();iterApp!=appList->end();++iterApp){
            if(dynamic_cast<LLDPAgent *>(*iterApp) != NULL) {
                LLDPAgent *lldp = (LLDPAgent *) *iterApp;
                lldpAgent = lldp;
                break;
            }
        }
    }

    if(id == PacketInSignalId){
        EV << "LLDPBalancedMinHop::PacketIn" << endl;
        auto pkt = dynamic_cast<Packet *>(obj);
        if (pkt == nullptr)
            return;
        auto chunk = pkt->peekAtFront<Chunk>();
        auto packet_in_msg = dynamicPtrCast<const OFP_Packet_In>(chunk);
        if (packet_in_msg != nullptr) {
            handlePacketIn(pkt);
        }
    }
}



std::list<LLDPPathSegment> LLDPBalancedMinHop::computeBalancedMinHopPath(std::string srcId, std::string dstId){
    LLDPMibGraph *mibGraph = lldpAgent->getMibGraph();
    mibGraph->removeExpiredEntries();
    std::map<std::string, std::vector<LLDPMib> > verticies = mibGraph->getVerticies();

    EV << "Finding Route in " << mibGraph->getNumOfVerticies() << " Verticies and " << mibGraph->getNumOfEdges() << " Edges" << endl;
    if(printMibGraph){
        EV << mibGraph->getStringGraph() << endl;
    }

    EV << "Version Hit: " << versionHit << " Version Miss: " << versionMiss << " Cache Hit: " << cacheHit << " Cache Miss: " << cacheMiss << endl;

    //check for route in cache
    if(lldpAgent->getMibGraph()->getVersion() == version){
        versionHit++;
        if(routeCache.count(std::pair<std::string,std::string>(srcId,dstId))>0){
            cacheHit++;
            std::list<LLDPPathSegment> tmp = routeCache[std::pair<std::string,std::string>(srcId,dstId)];
            std::list<LLDPPathSegment> res = std::list<LLDPPathSegment>();
            std::copy(tmp.begin(),tmp.end(), std::back_inserter(res));
            return res;
        }else {
            cacheMiss++;
        }
    } else {
        //update version miss and clear local cache
        versionMiss++;
        routeCache.clear();
        version = mibGraph->getVersion();
    }

    std::list<LLDPPathSegment> result = std::list<LLDPPathSegment>();

    //quick check if we have src and target in our graph
    if(verticies.count(srcId)<=0 || verticies.count(dstId)<=0){
        return result;
    }

    //dijkstra
    std::map<std::string,int> dist =  std::map<std::string,int>();
    std::map<std::string,LLDPPathSegment> prev = std::map<std::string,LLDPPathSegment >();
    std::vector<std::pair<std::string,LLDPPathSegment> > tempPath = std::vector<pair<std::string,LLDPPathSegment> >();

    //extract all vertexes
    priority_queue< pair<string,int>, vector< pair<string,int> >, comp > q;

    LLDPPathSegment seg;
    std::map<std::string,std::vector<LLDPMib> >::iterator iterKey = verticies.begin();
    while (iterKey != verticies.end()) {
        if(strcmp(iterKey->first.c_str(),srcId.c_str())!=0){
            q.push(pair<string,int>(iterKey->first,std::numeric_limits<int>::max()));

            dist[iterKey->first] = std::numeric_limits<int>::max();

            seg = LLDPPathSegment();
            seg.chassisId ="";
            seg.outport=-1;
            prev[iterKey->first]=seg;
        }
        iterKey++;
    }

    //set start vertex
    q.push(pair<string,int>(srcId,0));
    seg = LLDPPathSegment();
    seg.chassisId ="";
    seg.outport=-1;
    prev[srcId]=seg;

    std::string u;
    while(!q.empty()){

        u = q.top().first;
        q.pop();

        tempPath.clear();
        int alt;
        std::vector<LLDPMib>::iterator iterList;
        for(iterList = verticies[u].begin();iterList!=verticies[u].end();iterList++){
                alt = dist[u]+1;
                if(alt < dist[iterList->getDstId()]){
                    tempPath.clear();
                    dist[iterList->getDstId()] = alt;
                    seg = LLDPPathSegment();
                    seg.chassisId = u;
                    seg.outport= (iterList)->getSrcPort();
                    prev[(iterList)->getDstId()]=seg;
                    q.push(pair<string,int>(iterList->getDstId(),alt));
                } else if (alt == dist[iterList->getDstId()]){
                    seg = LLDPPathSegment();
                    seg.chassisId = u;
                    seg.outport= (iterList)->getSrcPort();
                    tempPath.push_back(pair<std::string,LLDPPathSegment>(iterList->getDstId(),seg));
                }
        }

        if (!tempPath.empty()){
            //random list entry or do nothing
            int size = tempPath.size();
            int rand = floor(uniform(0,size+1));

            if(rand < size){
                dist[tempPath[rand].first] = alt;
                prev[tempPath[rand].first]= tempPath[rand].second;
                q.push(pair<string,int>(tempPath[rand].first,alt));
            }

        }


    }

    //back track and insert into list
    std::string trg = dstId;
    LLDPPathSegment segP;
    while(strcmp(prev[trg].chassisId.c_str(),"") != 0){
        segP = LLDPPathSegment();
        segP.chassisId = prev[trg].chassisId;
        segP.outport = prev[trg].outport;
        result.push_front(segP);
        trg = prev[trg].chassisId;
    }

    //check if there was route from src to dst
    if(strcmp(srcId.c_str(),trg.c_str()) != 0){
        result.clear();
    }else{
        //add to cache
        routeCache[std::pair<std::string,std::string>(srcId,dstId)]=result;
    }
    std::list<LLDPPathSegment> res2 = std::list<LLDPPathSegment>();
    std::copy(result.begin(),result.end(), std::back_inserter(res2));
    return res2;
}



