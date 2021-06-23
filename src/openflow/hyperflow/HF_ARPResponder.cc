#include "openflow/hyperflow/HF_ARPResponder.h"
#include <algorithm>


#define MSGKIND_ARPRESPONDERBOOTED 801

Define_Module(HF_ARPResponder);

HF_ARPResponder::HF_ARPResponder(){

}

HF_ARPResponder::~HF_ARPResponder(){

}

void HF_ARPResponder::initialize(){
    ARPResponder::initialize();
    hfAgent = NULL;

    //register signals
    HyperFlowReFireSignalId =registerSignal("HyperFlowReFire");
    getParentModule()->subscribe("HyperFlowReFire",this);
}



void HF_ARPResponder::handlePacketIn(OFP_Packet_In * packet_in_msg){

    CommonHeaderFields headerFields = extractCommonHeaderFields(packet_in_msg);

    //check if it is an arp packet
    if(headerFields.eth_type == ETHERTYPE_ARP){

            //add entry if not existent
            if(addEntry(headerFields.arp_src_adr.str(),headerFields.src_mac)){
                //inform hf
                ARP_Wrapper *wrapperArp = new ARP_Wrapper();
                wrapperArp->setSrcIp(headerFields.arp_src_adr.str());
                wrapperArp->setSrcMacAddress(headerFields.src_mac);

                DataChannelEntry entry = DataChannelEntry();
                entry.eventId = 0;
                entry.trgSwitch = "";
                entry.srcController = controller->getFullPath();
                entry.payload = wrapperArp;

                hfAgent->synchronizeDataChannelEntry(entry);
            }


            //check arp type
            if(headerFields.arp_op == ARP_REQUEST){

                //can we give the reply directly
                if(ipToMac.count(headerFields.arp_dst_adr.str()) >0){

                    //drop the orginal packet
                    dropPacket(packet_in_msg);

                    //create an arp reply
                    ARPPacket *arpReply = new ARPPacket("controllerArpReply");
                    arpReply->setOpcode(ARP_REPLY);
                    arpReply->setName("arpReply");
                    arpReply->setSrcIPAddress(headerFields.arp_dst_adr);
                    arpReply->setSrcMACAddress(ipToMac[headerFields.arp_dst_adr.str()]);
                    arpReply->setDestIPAddress(headerFields.arp_src_adr);
                    arpReply->setDestMACAddress(headerFields.src_mac);
                    arpReply->setByteLength(28);
                    delete arpReply->removeControlInfo();



                    EtherFrame *frame = NULL;
                    EthernetIIFrame *eth2Frame = new EthernetIIFrame(arpReply->getName());
                    eth2Frame->setSrc(arpReply->getSrcMACAddress());  // if blank, will be filled in by MAC
                    eth2Frame->setDest(arpReply->getDestMACAddress());
                    eth2Frame->setEtherType(ETHERTYPE_ARP);
                    eth2Frame->setByteLength(ETHER_MAC_FRAME_BYTES);

                    frame = eth2Frame;
                    frame->encapsulate(arpReply);
                    if (frame->getByteLength() < MIN_ETHERNET_FRAME_BYTES)
                        frame->setByteLength(MIN_ETHERNET_FRAME_BYTES);  // "padding"
                    frame->addByteLength(PREAMBLE_BYTES+SFD_BYTES);


                    //encap the arp reply
                    OFP_Packet_Out *packetOut = new OFP_Packet_Out("packetOut");
                    packetOut->getHeaderForUpdate().version = OFP_VERSION;
                    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
                    packetOut->setBuffer_id(OFP_NO_BUFFER);
                    packetOut->setByteLength(24);
                    packetOut->encapsulate(frame);
                    packetOut->setIn_port(-1);
                    ofp_action_output *action_output = new ofp_action_output();
                    action_output->port = headerFields.inport;
                    packetOut->setActionsArraySize(1);
                    packetOut->setActions(0, *action_output);

                    //send the packet
                    answeredArp++;
                    controller->sendPacketOut(packetOut,headerFields.swInfo->getSocket());
                } else {
                    //we need to flood the packet
                    floodedArp++;
                    floodPacket(packet_in_msg);
                }
            }


    }

}


void HF_ARPResponder::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    //set hfagent link
    if(hfAgent == NULL && controller != NULL){
        auto appList = controller->getAppList();

        for(auto iterApp=appList->begin();iterApp!=appList->end();++iterApp){
            if(dynamic_cast<HyperFlowAgent *>(*iterApp) != NULL) {
                HyperFlowAgent *hf = (HyperFlowAgent *) *iterApp;
                hfAgent = hf;
                break;
            }
        }
    }

    ARPResponder::receiveSignal(src,id,obj,details);

    //check for hf messages to refire
    if(id == HyperFlowReFireSignalId){
        if(dynamic_cast<HF_ReFire_Wrapper *>(obj) != NULL) {
            HF_ReFire_Wrapper *hfRefire = (HF_ReFire_Wrapper *) obj;
            if(strcmp(hfRefire->getDataChannelEntry().trgSwitch.c_str(),"") == 0){
                if (dynamic_cast<ARP_Wrapper *>(hfRefire->getDataChannelEntry().payload) != NULL) {
                    ARP_Wrapper *wrapper = (ARP_Wrapper *) hfRefire->getDataChannelEntry().payload;
                    addEntry(wrapper->getSrcIp().c_str(),MACAddress(wrapper->getSrcMacAddress().str().c_str()));
                }
            }
        }
    }

}


