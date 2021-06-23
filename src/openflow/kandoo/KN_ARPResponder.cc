#include "openflow/kandoo/KN_ARPResponder.h"
#include <algorithm>
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"

#define MSGKIND_ARPRESPONDERBOOTED 801

Define_Module(KN_ARPResponder);

KN_ARPResponder::KN_ARPResponder(){

}

KN_ARPResponder::~KN_ARPResponder(){

}

void KN_ARPResponder::initialize(int stage){
    ARPResponder::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        knAgent = NULL;
        appName="KN_ARPResponder";
        //register signals
        kandooEventSignalId =registerSignal("KandooEvent");
        getParentModule()->subscribe("KandooEvent",this);
    }
}



//void KN_ARPResponder::handlePacketIn(OFP_Packet_In * packet_in_msg){
void KN_ARPResponder::handlePacketIn(Packet *pktIn){

    CommonHeaderFields headerFields = extractCommonHeaderFields(pktIn);

    //check if it is an arp packet
    if(headerFields.eth_type == ETHERTYPE_ARP){

            //add entry if not existent
            if(addEntry(headerFields.arp_src_adr.str(),headerFields.src_mac)){
                if(!knAgent->getIsRootController()){
                    //inform hf
                    ARP_Wrapper *wrapperArp = new ARP_Wrapper();
                    wrapperArp->setSrcIp(headerFields.arp_src_adr.str());
                    wrapperArp->setSrcMacAddress(headerFields.src_mac);

                    KandooEntry entry = KandooEntry();
                    entry.trgApp = "KN_ARPResponder";
                    entry.srcApp = "KN_ARPResponder";
                    entry.trgController = "RootController";
                    entry.trgSwitch = "";
                    entry.srcSwitch = headerFields.swInfo->getMacAddress();
                    entry.type=0;
                    entry.srcController = controller->getFullPath();
                    entry.payload = wrapperArp;

                    knAgent->sendRequest(entry);
                }
            }


            //check arp type
            if(headerFields.arp_op == ARP_REQUEST){

                //can we give the reply directly
                if(ipToMac.count(headerFields.arp_dst_adr.str()) >0){

                    //drop the orginal packet
                    dropPacket(pktIn);

                    //encap the arp reply
                    //
                    auto packetOut = makeShared<OFP_Packet_Out>();
                    packetOut->getHeaderForUpdate().version = OFP_VERSION;
                    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
                    packetOut->setBuffer_id(OFP_NO_BUFFER);
                    packetOut->setChunkLength(B(24));

                    auto pktOut = createArpReply(headerFields.arp_dst_adr,headerFields.arp_src_adr,ipToMac[headerFields.arp_dst_adr.str()],headerFields.src_mac);
                    packetOut->setIn_port(-1);
                    ofp_action_output *action_output = new ofp_action_output();
                    action_output->creationModule = dynamic_cast<cModule *>(this)->getClassAndFullName();
                    action_output->port = headerFields.inport;
                    packetOut->setActionsArraySize(1);
                    packetOut->setActions(0, *action_output);
                    pktOut->insertAtFront(packetOut);

                    //send the packet
                    answeredArp++;
                    controller->sendPacketOut(pktOut,headerFields.swInfo->getSocket());
                } else {
                    if(!knAgent->getIsRootController()){
                        //we need to ask the root controller
                        KandooEntry entry = KandooEntry();
                        entry.trgApp = "KN_ARPResponder";
                        entry.srcApp = "KN_ARPResponder";
                        entry.trgController = "RootController";
                        entry.trgSwitch = "";
                        entry.srcSwitch = headerFields.swInfo->getMacAddress();
                        entry.type=1;
                        entry.srcController = controller->getFullPath();
                        entry.payload = pktIn->dup();

                        knAgent->sendRequest(entry);

                    } else {
                        //we need to flood the packet
                        floodedArp++;
                        floodPacket(pktIn);
                    }
                }
            }
    }

}


void KN_ARPResponder::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    //set knagent link
    ARPResponder::receiveSignal(src,id,obj,details);
    Enter_Method("KN_ARPResponder::receiveSignal %s", cComponent::getSignalName(id));
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

        if(dynamicPtrCast<const KN_Packet> (chunk) != nullptr) {
            auto knpck = dynamicPtrCast<const KN_Packet>(chunk);
            Packet *pktknpck = pkt;
            if(strcmp(knpck->getKnEntry().trgApp.c_str(),appName.c_str())==0){
                //this is a received inform
                if(knpck->getKnEntry().type == 0){
                    if (dynamic_cast<ARP_Wrapper *>(knpck->getKnEntry().payload) != nullptr) {
                        ARP_Wrapper *wrapper = (ARP_Wrapper *) knpck->getKnEntry().payload;
                        addEntry(wrapper->getSrcIp().c_str(),MacAddress(wrapper->getSrcMacAddress().str().c_str()));
                    }
                } else if(knpck->getKnEntry().type == 1) {
                    //this is a received request
                    if (dynamic_cast<Packet *>(knpck->getKnEntry().payload) != nullptr) {
                        auto pktIn = dynamic_cast<Packet *>(knpck->getKnEntry().payload);
                        auto pckin = pktIn->peekAtFront<OFP_Packet_In>();

                        CommonHeaderFields headerFields = extractCommonHeaderFields(pktIn);

                        //check if it is an arp packet
                        if(headerFields.eth_type == ETHERTYPE_ARP){
                            //check arp type
                            if(headerFields.arp_op == ARP_REQUEST){
                                //can we give the reply directly
                                if(ipToMac.count(headerFields.arp_dst_adr.str()) >0){

                                    //drop the orginal packet
                                    KandooEntry entry2 = KandooEntry();
                                    entry2.trgApp = "KN_ARPResponder";
                                    entry2.srcApp = "KN_ARPResponder";
                                    entry2.trgController = knpck->getKnEntry().srcController;
                                    entry2.trgSwitch = knpck->getKnEntry().srcSwitch;
                                    entry2.srcSwitch = "";
                                    entry2.type=2;
                                    entry2.srcController = knpck->getKnEntry().trgController;
                                    entry2.payload = createDropPacketFromPacketIn(pktIn);

                                    knAgent->sendReply(pktknpck, entry2);

                                    //encap the arp reply
                                    auto packetOut = makeShared<OFP_Packet_Out>();
                                    packetOut->getHeaderForUpdate().version = OFP_VERSION;
                                    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
                                    packetOut->setBuffer_id(OFP_NO_BUFFER);
                                    packetOut->setChunkLength(B(24));
                                    auto pktOut = createArpReply(headerFields.arp_dst_adr,headerFields.arp_src_adr,ipToMac[headerFields.arp_dst_adr.str()],headerFields.src_mac);
                                    //packetOut->encapsulate(createArpReply(headerFields.arp_dst_adr,headerFields.arp_src_adr,ipToMac[headerFields.arp_dst_adr.str()],headerFields.src_mac));
                                    packetOut->setIn_port(-1);
                                    ofp_action_output *action_output = new ofp_action_output();
                                    action_output->creationModule = dynamic_cast<cModule *>(this)->getClassAndFullName();
                                    action_output->port = headerFields.inport;
                                    packetOut->setActionsArraySize(1);
                                    packetOut->setActions(0, *action_output);
                                    pktOut->insertAtFront(packetOut);

                                    //send the packet
                                    answeredArp++;

                                    KandooEntry entry = KandooEntry();
                                    entry.trgApp = "KN_ARPResponder";
                                    entry.srcApp = "KN_ARPResponder";
                                    entry.trgController = knpck->getKnEntry().srcController;
                                    entry.trgSwitch = knpck->getKnEntry().srcSwitch;
                                    entry.srcSwitch = "";
                                    entry.type=2;
                                    entry.srcController = knpck->getKnEntry().trgController;
                                    entry.payload = pktOut;


                                    knAgent->sendReply(pktknpck, entry);


                               } else {
                                   //give flood reply
                                   floodedArp++;

                                   KandooEntry entry = KandooEntry();
                                   entry.trgApp = "KN_ARPResponder";
                                   entry.srcApp = "KN_ARPResponder";
                                   entry.trgController = knpck->getKnEntry().srcController;
                                   entry.trgSwitch = knpck->getKnEntry().srcSwitch;
                                   entry.srcSwitch = "";
                                   entry.type=2;
                                   entry.srcController = knpck->getKnEntry().trgController;
                                   entry.payload = createFloodPacketFromPacketIn(pktIn);

                                   knAgent->sendReply(pktknpck, entry);
                               }
                            }
                        }

                    }
                } else if(knpck->getKnEntry().type == 2){
                    //this is a received reply
                    auto pktOut = dynamic_cast<Packet *>(knpck->getKnEntry().payload);
                    auto chunk = pktOut->peekAtFront<Chunk>();

                    if(dynamicPtrCast<const OFP_Packet_Out>(chunk) != nullptr){
                        controller->sendPacketOut(pktOut->dup(),controller->findSocketForChassisId(knpck->getKnEntry().trgSwitch));
                    }
                }
            }

        }
    }
}


