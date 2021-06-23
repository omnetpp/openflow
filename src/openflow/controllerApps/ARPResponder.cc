#include "openflow/controllerApps/ARPResponder.h"
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"
#include "inet/linklayer/ethernet/common/Ethernet.h"
#include <algorithm>
#include "inet/linklayer/common/FcsMode_m.h"
#include "inet/common/ProtocolTag_m.h"

#define MSGKIND_ARPRESPONDERBOOTED 801

Define_Module(ARPResponder);

ARPResponder::ARPResponder(){

}

ARPResponder::~ARPResponder(){

}

void ARPResponder::initialize(int stage){
    AbstractControllerApp::initialize(stage);
    //stats
    if (stage == INITSTAGE_LOCAL) {
        floodedArp = 0l;
        answeredArp = 0l;
    }
}


void ARPResponder::handleMessageWhenUp(cMessage *msg){
    delete msg;
}


bool ARPResponder::addEntry(std::string srcIp, MacAddress srcMac){
    if(macToIp.count(srcMac) <= 0){
        //add him to our table
        macToIp[srcMac] = srcIp;
        ipToMac[srcIp] = srcMac;
        return true;
    }
    return false;
}


//void ARPResponder::handlePacketIn(OFP_Packet_In * packet_in_msg){
void ARPResponder::handlePacketIn(Packet *pktIn){



    CommonHeaderFields headerFields = extractCommonHeaderFields(pktIn);

    //auto packet_in_msg = pktIn->removeAtFront<OFP_Packet_In>();

    //check if it is an arp packet
    if(headerFields.eth_type == ETHERTYPE_ARP){

            //add entry if not existent
            addEntry(headerFields.arp_src_adr.str(),headerFields.src_mac);

            //check arp type
            if(headerFields.arp_op == ARP_REQUEST){

                //can we give the reply directly
                if(ipToMac.count(headerFields.arp_dst_adr.str()) >0){

                    //drop the orginal packet
                    dropPacket(pktIn);

                    //encap the arp reply
                    auto packetOut = makeShared<OFP_Packet_Out>();
                    auto pktOut = createArpReply(headerFields.arp_dst_adr,headerFields.arp_src_adr,ipToMac[headerFields.arp_dst_adr.str()],headerFields.src_mac);

                    //OFP_Packet_Out *packetOut = new OFP_Packet_Out("packetOut");
                    packetOut->getHeaderForUpdate().version = OFP_VERSION;
                    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
                    packetOut->setBuffer_id(OFP_NO_BUFFER);
                    packetOut->setChunkLength(B(24));
                    //packetOut->encapsulate(createArpReply(headerFields.arp_dst_adr,headerFields.arp_src_adr,ipToMac[headerFields.arp_dst_adr.str()],headerFields.src_mac));
                    packetOut->setIn_port(-1);
                    ofp_action_output *action_output = new ofp_action_output();
                    action_output->creationModule = dynamic_cast<cModule *>(this)->getClassAndFullName();
                    action_output->port = headerFields.inport;
                    packetOut->setActionsArraySize(1);
                    packetOut->setActions(0, *action_output);

                    //send the packet
                    answeredArp++;
                    pktOut->insertAtFront(packetOut);
                    controller->sendPacketOut(pktOut,headerFields.swInfo->getSocket());
                } else {
                    //we need to flood the packet
                    floodedArp++;
                    floodPacket(pktIn);
                }
            }

    }

}

void ARPResponder::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    AbstractControllerApp::receiveSignal(src,id,obj,details);
    Enter_Method("ARPResponder::receiveSignal %s", cComponent::getSignalName(id));
    if(id == PacketInSignalId){
        EV << "ARPResponder::PacketIn" << '\n';
        auto pkt = dynamic_cast<Packet *>(obj);
        if (pkt != nullptr) {
            auto chunk = pkt->peekAtFront<Chunk>();
            auto packet_in_msg = dynamicPtrCast<const OFP_Packet_In>(chunk);
            if (packet_in_msg != nullptr)
                handlePacketIn(pkt);
        }
    }
}

Packet * ARPResponder::createArpReply(Ipv4Address srcIp, Ipv4Address dstIp, MacAddress srcMac, MacAddress dstMac){
    auto arpReply = makeShared<ArpPacket>();
    auto pktArp = new Packet("controllerArpReply");
    arpReply->setOpcode(ARP_REPLY);
    //arpReply->setName("arpReply");
    arpReply->setSrcIpAddress(srcIp);
    arpReply->setSrcMacAddress(srcMac);
    arpReply->setDestIpAddress(dstIp);
    arpReply->setDestMacAddress(dstMac);
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

    return pktArp;
}


void ARPResponder::finish(){
    AbstractControllerApp::finish();
    // record statistics
    recordScalar("arpFlooded", floodedArp);
    recordScalar("arpAnswered", answeredArp);
}


