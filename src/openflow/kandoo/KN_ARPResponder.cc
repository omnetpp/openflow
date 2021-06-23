#include "openflow/kandoo/KN_ARPResponder.h"
#include <algorithm>


#define MSGKIND_ARPRESPONDERBOOTED 801

Define_Module(KN_ARPResponder);

KN_ARPResponder::KN_ARPResponder(){

}

KN_ARPResponder::~KN_ARPResponder(){

}

void KN_ARPResponder::initialize(){
    ARPResponder::initialize();
    knAgent = NULL;
    appName="KN_ARPResponder";

    //register signals
    kandooEventSignalId =registerSignal("KandooEvent");
    getParentModule()->subscribe("KandooEvent",this);
}



void KN_ARPResponder::handlePacketIn(OFP_Packet_In * packet_in_msg){

    CommonHeaderFields headerFields = extractCommonHeaderFields(packet_in_msg);

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
                    dropPacket(packet_in_msg);

                    //encap the arp reply
                    OFP_Packet_Out *packetOut = new OFP_Packet_Out("packetOut");
                    packetOut->getHeaderForUpdate().version = OFP_VERSION;
                    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
                    packetOut->setBuffer_id(OFP_NO_BUFFER);
                    packetOut->setByteLength(24);
                    packetOut->encapsulate(createArpReply(headerFields.arp_dst_adr,headerFields.arp_src_adr,ipToMac[headerFields.arp_dst_adr.str()],headerFields.src_mac));
                    packetOut->setIn_port(-1);
                    ofp_action_output *action_output = new ofp_action_output();
                    action_output->port = headerFields.inport;
                    packetOut->setActionsArraySize(1);
                    packetOut->setActions(0, *action_output);

                    //send the packet
                    answeredArp++;
                    controller->sendPacketOut(packetOut,headerFields.swInfo->getSocket());
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
                        entry.payload = packet_in_msg->dup();

                        knAgent->sendRequest(entry);

                    } else {
                        //we need to flood the packet
                        floodedArp++;
                        floodPacket(packet_in_msg);
                    }
                }
            }
    }

}


void KN_ARPResponder::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
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

    ARPResponder::receiveSignal(src,id,obj,details);

    //check kandoo events
    if(id == kandooEventSignalId){
        if(dynamic_cast<KN_Packet *>(obj) != NULL) {
            KN_Packet *knpck = (KN_Packet *) obj;
            if(strcmp(knpck->getKnEntry().trgApp.c_str(),appName.c_str())==0){
                //this is a received inform
                if(knpck->getKnEntry().type == 0){
                    if (dynamic_cast<ARP_Wrapper *>(knpck->getKnEntry().payload) != NULL) {
                        ARP_Wrapper *wrapper = (ARP_Wrapper *) knpck->getKnEntry().payload;
                        addEntry(wrapper->getSrcIp().c_str(),MACAddress(wrapper->getSrcMacAddress().str().c_str()));
                    }
                } else if(knpck->getKnEntry().type == 1) {
                    //this is a received request
                    if (dynamic_cast<OFP_Packet_In *>(knpck->getKnEntry().payload) != NULL) {
                        OFP_Packet_In *pckin = (OFP_Packet_In *) knpck->getKnEntry().payload;

                        CommonHeaderFields headerFields = extractCommonHeaderFields(pckin);

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
                                    entry2.payload = createDropPacketFromPacketIn(pckin);

                                    knAgent->sendReply(knpck,entry2);

                                    //encap the arp reply
                                    OFP_Packet_Out *packetOut = new OFP_Packet_Out("packetOut");
                                    packetOut->getHeaderForUpdate().version = OFP_VERSION;
                                    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
                                    packetOut->setBuffer_id(OFP_NO_BUFFER);
                                    packetOut->setByteLength(24);
                                    packetOut->encapsulate(createArpReply(headerFields.arp_dst_adr,headerFields.arp_src_adr,ipToMac[headerFields.arp_dst_adr.str()],headerFields.src_mac));
                                    packetOut->setIn_port(-1);
                                    ofp_action_output *action_output = new ofp_action_output();
                                    action_output->port = headerFields.inport;
                                    packetOut->setActionsArraySize(1);
                                    packetOut->setActions(0, *action_output);

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
                                    entry.payload = packetOut;


                                    knAgent->sendReply(knpck,entry);


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
                                   entry.payload = createFloodPacketFromPacketIn(pckin);

                                   knAgent->sendReply(knpck,entry);
                               }
                            }
                        }

                    }
                } else if(knpck->getKnEntry().type == 2){
                    //this is a received reply
                    if(dynamic_cast<OFP_Packet_Out *>(knpck->getKnEntry().payload) != NULL){
                        OFP_Packet_Out *pckout = (OFP_Packet_Out *) knpck->getKnEntry().payload;
                        controller->sendPacketOut(pckout->dup(),controller->findSocketForChassisId(knpck->getKnEntry().trgSwitch));
                    }

                }
            }

        }
    }
}


