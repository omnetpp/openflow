#include "openflow/hyperflow/HF_ARPResponder.h"
#include <algorithm>
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"
#include "inet/linklayer/ethernet/common/Ethernet.h"
#include "inet/common/Protocol.h"
#include "inet/common/ProtocolTag_m.h"

#define MSGKIND_ARPRESPONDERBOOTED 801

simsignal_t HF_ARPResponder::HyperFlowReFireSignalId = registerSignal("HyperFlowReFire");

Define_Module(HF_ARPResponder);

HF_ARPResponder::HF_ARPResponder(){

}

HF_ARPResponder::~HF_ARPResponder(){

}

void HF_ARPResponder::initialize(int stage){

    ARPResponder::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        //register signals
        getParentModule()->subscribe("HyperFlowReFire",this);
    }
}



void HF_ARPResponder::handlePacketIn(Packet * pkt){

    CommonHeaderFields headerFields = extractCommonHeaderFields(pkt);

    if (controller == nullptr)
        throw cRuntimeError("Controller module is not initialized");

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

                if (hfAgent == nullptr)
                    throw cRuntimeError("HyperFlowAgent not synchronized, check if the agent is present in the network");
                hfAgent->synchronizeDataChannelEntry(entry);
            }

            //check arp type
            if(headerFields.arp_op == ARP_REQUEST){

                //can we give the reply directly
                if(ipToMac.count(headerFields.arp_dst_adr.str()) >0){

                    //drop the orginal packet
                    dropPacket(pkt);

                    //create an arp reply
//                    ARPPacket *arpReply = new ARPPacket("controllerArpReply");
//                    arpReply->setOpcode(ARP_REPLY);
//                    arpReply->setName("arpReply");
//                    arpReply->setSrcIPAddress(headerFields.arp_dst_adr);
//                    arpReply->setSrcMACAddress(ipToMac[headerFields.arp_dst_adr.str()]);
//                    arpReply->setDestIPAddress(headerFields.arp_src_adr);
//                    arpReply->setDestMACAddress(headerFields.src_mac);
//                    arpReply->setByteLength(28);
//                    delete arpReply->removeControlInfo();
//
//
//
//                    EtherFrame *frame = NULL;
//                    EthernetIIFrame *eth2Frame = new EthernetIIFrame(arpReply->getName());
//                    eth2Frame->setSrc(arpReply->getSrcMACAddress());  // if blank, will be filled in by MAC
//                    eth2Frame->setDest(arpReply->getDestMACAddress());
//                    eth2Frame->setEtherType(ETHERTYPE_ARP);
//                    eth2Frame->setByteLength(ETHER_MAC_FRAME_BYTES);
//
//                    frame = eth2Frame;
//                    frame->encapsulate(arpReply);
//                    if (frame->getByteLength() < MIN_ETHERNET_FRAME_BYTES)
//                        frame->setByteLength(MIN_ETHERNET_FRAME_BYTES);  // "padding"
//                    frame->addByteLength(PREAMBLE_BYTES+SFD_BYTES);



                    auto arpReply = makeShared<ArpPacket>();
                    auto pktArp = new Packet("controllerArpReply");
                    arpReply->setOpcode(ARP_REPLY);
                    arpReply->setSrcIpAddress(headerFields.arp_dst_adr);
                    arpReply->setSrcMacAddress(ipToMac[headerFields.arp_dst_adr.str()]);
                    arpReply->setDestIpAddress(headerFields.arp_src_adr);
                    arpReply->setDestMacAddress(headerFields.src_mac);

                    arpReply->setChunkLength(B(28));
                    pktArp->insertAtFront(arpReply);

                    auto eth2Frame = makeShared<EthernetMacHeader>();
                    // EthernetIIFrame *eth2Frame = new EthernetIIFrame(arpReply->getName());
                    eth2Frame->setSrc(arpReply->getSrcMacAddress());  // if blank, will be filled in by MAC
                    eth2Frame->setDest(arpReply->getDestMacAddress());
                    eth2Frame->setTypeOrLength(ETHERTYPE_ARP);
                    pktArp->insertAtFront(eth2Frame);
                    const auto& ethernetFcs = makeShared<EthernetFcs>();
                    pktArp->addTagIfAbsent<PacketProtocolTag>()->setProtocol(&Protocol::ethernetMac);
                    //frame = eth2Frame;
                    //frame->encapsulate(arpReply);
                    ethernetFcs->setFcsMode(FCS_DECLARED_CORRECT);
                    ethernetFcs->setFcs(0xC00DC00DL);
                    B paddingLength = MIN_ETHERNET_FRAME_BYTES - ETHER_FCS_BYTES - B(pktArp->getByteLength());
                    if (paddingLength > B(0)) {
                        const auto& ethPadding = makeShared<EthernetPadding>();
                        ethPadding->setChunkLength(paddingLength);
                        pktArp->insertAtBack(ethPadding);
                    }
                    pktArp->insertAtBack(ethernetFcs);

                    //encap the arp reply
                    auto packetOut = makeShared<OFP_Packet_Out>();
                    packetOut->getHeaderForUpdate().version = OFP_VERSION;
                    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
                    packetOut->setBuffer_id(OFP_NO_BUFFER);
                    packetOut->setChunkLength(B(24));

                    packetOut->setIn_port(-1);
                    ofp_action_output *action_output = new ofp_action_output();
                    action_output->creationModule = dynamic_cast<cModule *>(this)->getClassAndFullName();
                    action_output->port = headerFields.inport;
                    packetOut->setActionsArraySize(1);
                    packetOut->setActions(0, *action_output);
                    pktArp->insertAtFront(packetOut);

                    //send the packet
                    answeredArp++;
                    controller->sendPacketOut(pktArp,headerFields.swInfo->getSocket());
                } else {
                    //we need to flood the packet
                    floodedArp++;
                    floodPacket(pkt);
                }
            }
    }
}

bool HF_ARPResponder::searchHyperFlowAggent()
{
    if (hfAgent)
        return true;
    if(hfAgent == nullptr && controller != nullptr){
        auto appList = controller->getAppList();
        for(auto iterApp=appList->begin();iterApp!=appList->end();++iterApp){
            if(dynamic_cast<HyperFlowAgent *>(*iterApp) != NULL) {
                HyperFlowAgent *hf = (HyperFlowAgent *) *iterApp;
                hfAgent = hf;
                return true;
                break;
            }
        }
    }
    return false;
}


void HF_ARPResponder::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    //set hfagent link
    ARPResponder::receiveSignal(src,id,obj,details);
    Enter_Method("HF_ARPResponder::receiveSignal %s", cComponent::getSignalName(id));
    searchHyperFlowAggent();

    //check for hf messages to refire
    if(id == HyperFlowReFireSignalId){
        if(dynamic_cast<HF_ReFire_Wrapper *>(obj) != NULL) {
            HF_ReFire_Wrapper *hfRefire = (HF_ReFire_Wrapper *) obj;
            if(strcmp(hfRefire->getDataChannelEntry().trgSwitch.c_str(),"") == 0){
                if (dynamic_cast<ARP_Wrapper *>(hfRefire->getDataChannelEntry().payload) != NULL) {
                    ARP_Wrapper *wrapper = (ARP_Wrapper *) hfRefire->getDataChannelEntry().payload;
                    addEntry(wrapper->getSrcIp().c_str(),MacAddress(wrapper->getSrcMacAddress().str().c_str()));
                }
            }
        }
    }

}


