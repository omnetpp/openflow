#include "openflow/kandoo/KN_LLDPForwarding.h"
#include <algorithm>
#include <string>
#include "inet/linklayer/ethernet/common/Ethernet.h"
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"
//#include "inet/networklayer/ipv4/ICMPMessage.h"
//#include "inet/applications/pingapp/PingPayload_m.h"


Define_Module(KN_LLDPForwarding);


KN_LLDPForwarding::KN_LLDPForwarding(){

}

KN_LLDPForwarding::~KN_LLDPForwarding(){

}

void KN_LLDPForwarding::initialize(int stage){
    LLDPForwarding::initialize(stage);


    if (stage == INITSTAGE_LOCAL) {
        knAgent = NULL;
        appName="KN_LLDPForwarding";
        //register signals
        kandooEventSignalId =registerSignal("KandooEvent");
        getParentModule()->subscribe("KandooEvent",this);
        cpPingPacketHash = registerSignal("cpPingPacketHash");
    }
}



void KN_LLDPForwarding::handlePacketIn(Packet * pktIn){
    //get some details

    auto packet_in_msg = pktIn->peekAtFront<OFP_Packet_In>();
    CommonHeaderFields headerFields = extractCommonHeaderFields(pktIn);

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

    unsigned long hash =0;
    int indetifier = 0;
    int seqNum = 0;


    //emit id of ping packet to indicate where it was processed
    // check ICMP

    if(chekIcmpEchoRequest(pktIn,seqNum, indetifier)) {
        //generate and emit hash
        std::stringstream hashString;
        hashString << "SeqNo-" << seqNum << "-Pid-" << indetifier;
        hash = std::hash<std::string>()(hashString.str().c_str());
    }

    //if route empty flood
    if(route.empty()){
        if(!knAgent->getIsRootController()){
            //ask our root controller for instructions
            KandooEntry entry = KandooEntry();
            entry.trgApp = "KN_LLDPForwarding";
            entry.srcApp = "KN_LLDPForwarding";
            entry.trgController = "RootController";
            entry.trgSwitch = "";
            entry.srcSwitch = headerFields.swInfo->getMacAddress();
            entry.type=1;
            entry.srcController = controller->getFullPath();
            entry.payload = packet_in_msg->dup();

            knAgent->sendRequest(entry);
            if(hash !=0){
                emit(cpPingPacketHash,hash);
            }

        } else {
            if(dropIfNoRouteFound && headerFields.eth_type != ETHERTYPE_ARP){
                dropPacket(pktIn);
            } else {
                floodPacket(pktIn);
            }
        }

    }else {
        std::string computedRoute = "";
        //send packet to next hop
        LLDPPathSegment seg = route.front();
        route.pop_front();
        sendPacket(pktIn, seg.outport);

        //set flow mods for all switches under my controller's command
        oxm_basic_match match = oxm_basic_match();
        match.OFB_ETH_DST = headerFields.dst_mac;

        match.wildcards= 0;
        match.wildcards |= OFPFW_IN_PORT;
        match.wildcards |=  OFPFW_DL_SRC;
        match.wildcards |= OFPFW_DL_TYPE;

        TcpSocket * socket = controller->findSocketFor(pktIn);
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

            TcpSocket * socket = controller->findSocketForChassisId(seg.chassisId);
            //is switch under our control
            if(socket != NULL){
                sendFlowModMessage(OFPFC_ADD, match, seg.outport, socket,idleTimeout,hardTimeout);
            }
        }

        //clean up route
        computedRoute.erase(computedRoute.length()-4);
        EV << "Route:" << computedRoute << endl;
    }

}




void KN_LLDPForwarding::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    LLDPForwarding::receiveSignal(src,id,obj,details);
    Enter_Method("KN_LLDPForwarding::receiveSignal %s", cComponent::getSignalName(id));
    //set knagent link
    if(knAgent == NULL && controller != NULL){
        auto appList = controller->getAppList();

        for(auto iterApp=appList->begin();iterApp!=appList->end();++iterApp){
            if(dynamic_cast<KandooAgent *>(*iterApp) != NULL) {
                KandooAgent *kn = (KandooAgent *) *iterApp;
                knAgent = kn;
                break;
            }
        }
    }

    //check kandoo events
    if (id == kandooEventSignalId) {
        auto pkt = check_and_cast<Packet*>(obj);
        auto chunk = pkt->peekAtFront<Chunk>();
        if (dynamicPtrCast<const KN_Packet>(chunk) != nullptr) {
            auto pktKnpck = pkt;
            auto knpck = pkt->removeAtFront<KN_Packet>();
            if (strcmp(knpck->getKnEntry().trgApp.c_str(), appName.c_str())
                    == 0) {
                //this is a received inform
                if (knpck->getKnEntry().type == 0) {
                    //not used by this app
                } else if (knpck->getKnEntry().type == 1) {
                    //this is a received request

                    auto pktIn = dynamic_cast<Packet*>(knpck->getKnEntryForUpdate().payload);
                    if (pktIn != nullptr) {
                        auto chunk = pktIn->peekAtFront<Chunk>();
                        if (dynamicPtrCast<const OFP_Packet_In>(chunk) != nullptr) {
                            auto pckin = dynamicPtrCast<const OFP_Packet_In>(chunk);
                            CommonHeaderFields headerFields = extractCommonHeaderFields(pktIn);
                            //check if we can find a route
                            //ignore lldp packets
                            if (headerFields.eth_type == 0x88CC) {
                                return;
                            }
                            //ignore arp requests
                            if (ignoreArpRequests  && headerFields.eth_type == ETHERTYPE_ARP && pckin->getMatch().OFB_ARP_OP == ARP_REQUEST) {
                                return;
                            }

                            //compute path for non arps
                            std::list<LLDPPathSegment> route;
                            computePath(knpck->getKnEntry().srcSwitch, headerFields.dst_mac.str(), route);

                            //if route empty flood
                            if (route.empty()) {
                                if (dropIfNoRouteFound && headerFields.eth_type != ETHERTYPE_ARP) {
                                    //respond with a drop packet
                                    KandooEntry entry2 = KandooEntry();
                                    entry2.trgApp = "KN_LLDPForwarding";
                                    entry2.srcApp = "KN_LLDPForwarding";
                                    entry2.trgController = knpck->getKnEntry().srcController;
                                    entry2.trgSwitch = knpck->getKnEntry().srcSwitch;
                                    entry2.srcSwitch = "";
                                    entry2.type = 2;
                                    entry2.srcController = knpck->getKnEntry().trgController;
                                    entry2.payload = createDropPacketFromPacketIn(pktIn);

                                    knAgent->sendReply(pktKnpck, entry2);
                                } else {
                                    //respond with flood packet
                                    KandooEntry entry = KandooEntry();
                                    entry.trgApp = "KN_LLDPForwarding";
                                    entry.srcApp = "KN_LLDPForwarding";
                                    entry.trgController = knpck->getKnEntry().srcController;
                                    entry.trgSwitch = knpck->getKnEntry().srcSwitch;
                                    entry.srcSwitch = "";
                                    entry.type = 2;
                                    entry.srcController = knpck->getKnEntry().trgController;
                                    entry.payload = createFloodPacketFromPacketIn(pktIn);

                                    knAgent->sendReply(pktKnpck, entry);
                                }
                            } else {
                                //send packet to next hop
                                LLDPPathSegment seg = route.front();
                                route.pop_front();

                                //packet out
                                KandooEntry entry = KandooEntry();
                                entry.trgApp = "KN_LLDPForwarding";
                                entry.srcApp = "KN_LLDPForwarding";
                                entry.trgController = knpck->getKnEntry().srcController;
                                entry.trgSwitch = knpck->getKnEntry().srcSwitch;
                                entry.srcSwitch = "";
                                entry.type = 2;
                                entry.srcController = knpck->getKnEntry().trgController;
                                entry.payload = createPacketOutFromPacketIn(pktIn, seg.outport);

                                knAgent->sendReply(pktKnpck, entry);

                                //set flow mods for all switches under my controller's command
                                oxm_basic_match match = oxm_basic_match();
                                match.OFB_ETH_DST = headerFields.dst_mac;

                                match.wildcards = 0;
                                match.wildcards |= OFPFW_IN_PORT;
                                match.wildcards |= OFPFW_DL_SRC;
                                match.wildcards |= OFPFW_DL_TYPE;

                                entry = KandooEntry();
                                entry.trgApp = "KN_LLDPForwarding";
                                entry.srcApp = "KN_LLDPForwarding";
                                entry.trgController = knpck->getKnEntry().srcController;
                                entry.trgSwitch = knpck->getKnEntry().srcSwitch;
                                entry.srcSwitch = "";
                                entry.type = 2;
                                entry.srcController = knpck->getKnEntry().trgController;
                                entry.payload = createFlowMod(OFPFC_ADD, match, seg.outport, idleTimeout, hardTimeout);

                                knAgent->sendReply(pktKnpck, entry);

                                //iterate the rest of the route and set flow mods for switches under my control
                                while (!route.empty()) {
                                    seg = route.front();
                                    route.pop_front();
                                    oxm_basic_match match = oxm_basic_match();
                                    match.OFB_ETH_DST = headerFields.dst_mac;

                                    match.wildcards = 0;
                                    match.wildcards |= OFPFW_IN_PORT;
                                    match.wildcards |= OFPFW_DL_SRC;
                                    match.wildcards |= OFPFW_DL_TYPE;

                                    entry = KandooEntry();
                                    entry.trgApp = "KN_LLDPForwarding";
                                    entry.srcApp = "KN_LLDPForwarding";
                                    entry.trgController = knpck->getKnEntry().srcController;
                                    entry.trgSwitch = seg.chassisId;
                                    entry.srcSwitch = "";
                                    entry.type = 2;
                                    entry.srcController = knpck->getKnEntry().trgController;
                                    entry.payload = createFlowMod(OFPFC_ADD, match, seg.outport, idleTimeout, hardTimeout);

                                    knAgent->sendReplyToSwitchAuthoritive(seg.chassisId, entry);
                                }
                            }
                        }
                    }

                } else if (knpck->getKnEntry().type == 2) {
                    //this is a received reply
                    auto pktOut = dynamic_cast<Packet*>(knpck->getKnEntryForUpdate().payload);
                    if (pktOut != nullptr) {
                        auto chunk = pktOut->peekAtFront<Chunk>();
                        if (dynamicPtrCast<const OFP_Packet_Out>(chunk) != nullptr) {
                            controller->sendPacketOut(pktOut->dup(), controller->findSocketForChassisId(knpck->getKnEntry().trgSwitch));
                        }
                        else if (dynamicPtrCast<const OFP_Flow_Mod>(chunk) != nullptr) {
                            controller->sendPacketOut(pktOut->dup(), controller->findSocketForChassisId(knpck->getKnEntry().trgSwitch));
                        }
                    }
                }
            }
            pkt->insertAtFront(knpck);
        }
    }
}





