#include "openflow/kandoo/KN_LLDPBalancedMinHop.h"
#include <algorithm>
#include <string>
#include "inet/linklayer/ethernet/common/Ethernet.h"
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"

Define_Module(KN_LLDPBalancedMinHop);


KN_LLDPBalancedMinHop::KN_LLDPBalancedMinHop(){

}

KN_LLDPBalancedMinHop::~KN_LLDPBalancedMinHop(){

}

void KN_LLDPBalancedMinHop::initialize(int stage){
    LLDPBalancedMinHop::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        knAgent = NULL;
        appName="KN_LLDPBalancedMinHop";
        //register signals
        kandooEventSignalId =registerSignal("KandooEvent");
        getParentModule()->subscribe("KandooEvent",this);
    }
}



void KN_LLDPBalancedMinHop::handlePacketIn(Packet * pktIn){
    //get some details
    CommonHeaderFields headerFields = extractCommonHeaderFields(pktIn);


    //ignore lldp packets
    if(headerFields.eth_type == 0x88CC){
        return;
    }

    auto packet_in_msg = pktIn->peekAtFront<OFP_Packet_In>();

    //ignore arp requests
    if(ignoreArpRequests && headerFields.eth_type == ETHERTYPE_ARP && packet_in_msg->getMatch().OFB_ARP_OP == ARP_REQUEST){
        return;
    }


    //compute path for non arps
    std::list<LLDPPathSegment> route = computeBalancedMinHopPath(headerFields.swInfo->getMacAddress(),headerFields.dst_mac.str());

    //if route empty flood
    if(route.empty()){
        if(!knAgent->getIsRootController()){
            //ask our root controller for instructions
            KandooEntry entry = KandooEntry();
            entry.trgApp = "KN_LLDPBalancedMinHop";
            entry.srcApp = "KN_LLDPBalancedMinHop";
            entry.trgController = "RootController";
            entry.trgSwitch = "";
            entry.srcSwitch = headerFields.swInfo->getMacAddress();
            entry.type=1;
            entry.srcController = controller->getFullPath();
            entry.payload = pktIn->dup();

            knAgent->sendRequest(entry);

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
        match.OFB_ETH_SRC = headerFields.src_mac;

        match.wildcards= 0;
        match.wildcards |= OFPFW_IN_PORT;
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
            match.OFB_ETH_SRC = headerFields.src_mac;

            match.wildcards= 0;
            match.wildcards |= OFPFW_IN_PORT;
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




void KN_LLDPBalancedMinHop::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    LLDPBalancedMinHop::receiveSignal(src,id,obj,details);
    Enter_Method("KN_LLDPBalancedMinHop::receiveSignal %s", cComponent::getSignalName(id));
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
    if(id == kandooEventSignalId){
        auto pkt = check_and_cast<Packet *>(obj);
        auto chunk = pkt->peekAtFront<Chunk>();

        if(dynamicPtrCast<const KN_Packet>(chunk) != nullptr) {
            auto knpck = pkt->peekAtFront<KN_Packet>();
            if(strcmp(knpck->getKnEntry().trgApp.c_str(),appName.c_str())==0){
                //this is a received inform
                if(knpck->getKnEntry().type == 0){
                    //not used by this app
                } else if(knpck->getKnEntry().type == 1) {
                    //ths is a received request
                    Packet *pktIn = nullptr;
                    bool check = false;
                    if (knpck->getKnEntry().payload) {
                        pktIn = check_and_cast<Packet *>(knpck->getKnEntry().payload);
                        auto chunk = pktIn->peekAtFront<Chunk>();
                        if (dynamicPtrCast<const OFP_Packet_In>(chunk) != nullptr)
                            check = true;
                    }

                    if (check) {
                        CommonHeaderFields headerFields = extractCommonHeaderFields(pktIn);

                        auto pckin = dynamicPtrCast<const OFP_Packet_In>(chunk);
                        //check if we can find a route

                        //ignore lldp packets
                        if(headerFields.eth_type == 0x88CC){
                            return;
                        }

                        //ignore arp requests
                        if(ignoreArpRequests && headerFields.eth_type == ETHERTYPE_ARP && pckin->getMatch().OFB_ARP_OP == ARP_REQUEST){
                            return;
                        }


                        //compute path for non arps
                        std::list<LLDPPathSegment> route = computeBalancedMinHopPath(knpck->getKnEntry().srcSwitch,headerFields.dst_mac.str());

                        //if route empty flood
                        if(route.empty()){
                            if(dropIfNoRouteFound && headerFields.eth_type != ETHERTYPE_ARP){
                                //respond with a drop packet
                                KandooEntry entry2 = KandooEntry();
                                entry2.trgApp = "KN_LLDPBalancedMinHop";
                                entry2.srcApp = "KN_LLDPBalancedMinHop";
                                entry2.trgController = knpck->getKnEntry().srcController;
                                entry2.trgSwitch = knpck->getKnEntry().srcSwitch;
                                entry2.srcSwitch = "";
                                entry2.type=2;
                                entry2.srcController = knpck->getKnEntry().trgController;
                                entry2.payload = createDropPacketFromPacketIn(pktIn);

                                knAgent->sendReply(pkt,entry2);
                            } else {
                                //respond with flood packet
                                KandooEntry entry = KandooEntry();
                                entry.trgApp = "KN_LLDPBalancedMinHop";
                                entry.srcApp = "KN_LLDPBalancedMinHop";
                                entry.trgController = knpck->getKnEntry().srcController;
                                entry.trgSwitch = knpck->getKnEntry().srcSwitch;
                                entry.srcSwitch = "";
                                entry.type=2;
                                entry.srcController = knpck->getKnEntry().trgController;
                                entry.payload = createFloodPacketFromPacketIn(pktIn);

                                knAgent->sendReply(pkt,entry);
                            }
                        } else {
                            //send packet to next hop
                            LLDPPathSegment seg = route.front();
                            route.pop_front();
                            std::string computedRoute = "";

                            //packet out
                            KandooEntry entry = KandooEntry();
                            entry.trgApp = "KN_LLDPBalancedMinHop";
                            entry.srcApp = "KN_LLDPBalancedMinHop";
                            entry.trgController = knpck->getKnEntry().srcController;
                            entry.trgSwitch = knpck->getKnEntry().srcSwitch;
                            entry.srcSwitch = "";
                            entry.type=2;
                            entry.srcController = knpck->getKnEntry().trgController;
                            entry.payload = createPacketOutFromPacketIn(pktIn,seg.outport);

                            knAgent->sendReply(pkt,entry);

                            //set flow mods for all switches under my controller's command
                            oxm_basic_match match = oxm_basic_match();
                            match.OFB_ETH_DST = headerFields.dst_mac;
                            match.OFB_ETH_SRC = headerFields.src_mac;

                            match.wildcards= 0;
                            match.wildcards |= OFPFW_IN_PORT;
                            match.wildcards |= OFPFW_DL_TYPE;


                            entry = KandooEntry();
                            entry.trgApp = "KN_LLDPBalancedMinHop";
                            entry.srcApp = "KN_LLDPBalancedMinHop";
                            entry.trgController = knpck->getKnEntry().srcController;
                            entry.trgSwitch = knpck->getKnEntry().srcSwitch;
                            entry.srcSwitch = "";
                            entry.type=2;
                            entry.srcController = knpck->getKnEntry().trgController;
                            entry.payload = createFlowMod(OFPFC_ADD, match, seg.outport,idleTimeout,hardTimeout);

                            knAgent->sendReply(pkt, entry);
                            computedRoute += seg.chassisId + ":" + std::to_string(seg.outport) + " -> ";

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

                                computedRoute += seg.chassisId + ":" + std::to_string(seg.outport) + " -> ";

                                entry = KandooEntry();
                                entry.trgApp = "KN_LLDPBalancedMinHop";
                                entry.srcApp = "KN_LLDPBalancedMinHop";
                                entry.trgController = knpck->getKnEntry().srcController;
                                entry.trgSwitch = seg.chassisId;
                                entry.srcSwitch = "";
                                entry.type=2;
                                entry.srcController = knpck->getKnEntry().trgController;
                                entry.payload = createFlowMod(OFPFC_ADD, match, seg.outport,idleTimeout,hardTimeout);

                                knAgent->sendReplyToSwitchAuthoritive(seg.chassisId,entry);
                            }

                            //clean up route
                            computedRoute.erase(computedRoute.length()-4);
                            EV << "Route:" << computedRoute << endl;
                        }

                    }

                } else if(knpck->getKnEntry().type == 2) {
                    //this is a received reply
                    Packet *pktOut = nullptr;
                    bool checkOut = false;
                    bool checkFlow = false;
                    if (knpck->getKnEntry().payload) {
                        pktOut = check_and_cast<Packet *>(knpck->getKnEntry().payload);
                        auto chunk = pktOut->peekAtFront<Chunk>();
                        if (dynamicPtrCast<const OFP_Packet_Out>(chunk) != nullptr)
                            checkOut = true;
                        if (dynamicPtrCast<const OFP_Flow_Mod>(chunk) != nullptr)
                            checkFlow = true;
                    }
                    if(checkOut){
                        controller->sendPacketOut(pktOut->dup(),controller->findSocketForChassisId(knpck->getKnEntry().trgSwitch));
                    } else if (checkFlow){
                        controller->sendPacketOut(pktOut->dup(),controller->findSocketForChassisId(knpck->getKnEntry().trgSwitch));
                    }
                }
            }
        }
    }
}





