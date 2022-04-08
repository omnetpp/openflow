
#include "openflow/controllerApps/LLDPForwarding.h"
#include <algorithm>
#include <string>
#include <queue>
#include "inet/linklayer/ethernet/common/Ethernet.h"
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"

using namespace std;

struct comp {
    bool operator() (const pair<string,int> &a, const pair<string,int> &b) {
        return a.second > b.second;
    }
};

Define_Module(LLDPForwarding);


LLDPForwarding::LLDPForwarding(){

}

LLDPForwarding::~LLDPForwarding(){

}

void LLDPForwarding::initialize(int stage){
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
        hardTimeout= par("flowModHardTimeOut");
    }
}



void LLDPForwarding::handlePacketIn(Packet *pktInt){
    //get some details
    CommonHeaderFields headerFields = extractCommonHeaderFields(pktInt);

    auto packet_in_msg = pktInt->peekAtFront<OFP_Packet_In>();
    //ignore lldp packets
    if(headerFields.eth_type == 0x88CC){
        return;
    }

    //ignore arp requests
    if(ignoreArpRequests && headerFields.eth_type == ETHERTYPE_ARP && packet_in_msg->getMatch().OFB_ARP_OP == ARP_REQUEST){
        return;
    }


    //compute path for non arps
    std::list<LLDPPathSegment> route;
    computePath(headerFields.swInfo->getMacAddress(),headerFields.dst_mac.str(),route);

    //if route empty flood
    if(route.empty()){
        if(dropIfNoRouteFound && headerFields.eth_type != ETHERTYPE_ARP){
            dropPacket(pktInt);
        } else {
            floodPacket(pktInt);
        }
    }else {
        std::string computedRoute = "";
        //send packet to next hop
        LLDPPathSegment seg = route.front();
        route.pop_front();
        sendPacket(pktInt, seg.outport);

        //set flow mods for all switches under my controller's command
        oxm_basic_match match = oxm_basic_match();
        match.OFB_ETH_DST = headerFields.dst_mac;

        match.wildcards= 0;
        match.wildcards |= OFPFW_IN_PORT;
        match.wildcards |=  OFPFW_DL_SRC;
        match.wildcards |= OFPFW_DL_TYPE;

        auto socket = controller->findSocketFor(pktInt);
        sendFlowModMessage(OFPFC_ADD, match, seg.outport, socket,idleTimeout,hardTimeout);

        //concatenate route
       computedRoute += seg.chassisId + " -> ";

        //iterate the rest of the route and set flow mods for switches under my control
        while(!route.empty()){
            seg = route.front();
            route.pop_front();
            oxm_basic_match match = oxm_basic_match();
            match.OFB_ETH_DST = headerFields.dst_mac;

            match.wildcards= 0;
            match.wildcards |= OFPFW_IN_PORT;
            match.wildcards |=  OFPFW_DL_SRC;
            match.wildcards |= OFPFW_DL_TYPE;

            computedRoute += seg.chassisId + " -> ";

            auto socket = controller->findSocketForChassisId(seg.chassisId);
            //is switch under our control
            if(socket != NULL){
                sendFlowModMessage(OFPFC_ADD, match, seg.outport, socket,idleTimeout,hardTimeout);
            }
        }

        //clean up route
        computedRoute.erase(computedRoute.length()-4);
        EV << "Route:" << computedRoute << '\n';
    }

}




void LLDPForwarding::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    AbstractControllerApp::receiveSignal(src,id,obj,details);

    //set lldp link
    Enter_Method("LLDPForwarding::receiveSignal %s", cComponent::getSignalName(id));
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
        EV << "LLDPForwarding::PacketIn" << '\n';
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




void LLDPForwarding::computePath(std::string srcId, std::string dstId,std::list<LLDPPathSegment> &list){
    LLDPMibGraph *mibGraph = lldpAgent->getMibGraph();
    mibGraph->removeExpiredEntries();
    std::map<std::string, std::vector<LLDPMib> > verticies = mibGraph->getVerticies();

    EV << "Finding Route in " << mibGraph->getNumOfVerticies() << " Verticies and " << mibGraph->getNumOfEdges() << " Edges" << '\n';
    if(printMibGraph){
        EV << mibGraph->getStringGraph() << '\n';
    }

    EV << "Version Hit: " << versionHit << " Version Miss: " << versionMiss << " Cache Hit: " << cacheHit << " Cache Miss: " << cacheMiss << '\n';

    //check for route in cache
    if(lldpAgent->getMibGraph()->getVersion() == version){
        versionHit++;
        if(routeCache.count(std::pair<std::string,std::string>(srcId,dstId))>0){
            cacheHit++;
            std::list<LLDPPathSegment> tmp = routeCache[std::pair<std::string,std::string>(srcId,dstId)];
            std::copy(tmp.begin(),tmp.end(), std::back_inserter(list));
            return;
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
        return;
    }

    //dijkstra
    std::map<std::string,int> dist =  std::map<std::string,int>();
    std::map<std::string,LLDPPathSegment> prev = std::map<std::string,LLDPPathSegment >();
    std::map<std::string,bool> visited = std::map<std::string,bool>();

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

        if(visited.count(u)>0){
            continue;
        }

        int alt;
        /*std::vector<LLDPMib>::iterator iterList;
        for(iterList = verticies[u].begin();iterList!=verticies[u].end();iterList++){
            if(visited.count(iterList->getDstId())<=0){
                alt = dist[u]+1;
                if(alt < dist[iterList->getDstId()]){
                    dist[iterList->getDstId()] = alt;
                    seg = LLDPPathSegment();
                    seg.chassisId = u;
                    seg.outport= (iterList)->getSrcPort();
                    prev[(iterList)->getDstId()]=seg;
                    q.push(pair<string,int>(iterList->getDstId(),alt));
                }
            }
        }*/

        for(const auto &elem : verticies[u]) {
            if(visited.count(elem.getDstId())<=0) {
                alt = dist[u]+1;
                if(alt < dist[elem.getDstId()]) {
                    dist[elem.getDstId()] = alt;
                    seg = LLDPPathSegment();
                    seg.chassisId = u;
                    seg.outport= elem.getSrcPort();
                    prev[elem.getDstId()]=seg;
                    q.push(pair<string,int>(elem.getDstId(),alt));
                }
            }
        }
        //add u to visited
        visited[u] = true;
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
    std::copy(result.begin(),result.end(), std::back_inserter(list));
    return;
}
