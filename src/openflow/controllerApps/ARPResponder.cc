#include "openflow/controllerApps/ARPResponder.h"
#include <algorithm>


#define MSGKIND_ARPRESPONDERBOOTED 801

Define_Module(ARPResponder);

ARPResponder::ARPResponder(){

}

ARPResponder::~ARPResponder(){

}

void ARPResponder::initialize(){
    AbstractControllerApp::initialize();
    //stats
    floodedArp = 0l;
    answeredArp = 0l;
}


void ARPResponder::handleMessage(cMessage *msg){
    delete msg;
}


bool ARPResponder::addEntry(std::string srcIp, MACAddress srcMac){
    if(macToIp.count(srcMac) <= 0){
        //add him to our table
        macToIp[srcMac] = srcIp;
        ipToMac[srcIp] = srcMac;
        return true;
    }
    return false;
}


void ARPResponder::handlePacketIn(OFP_Packet_In * packet_in_msg){

    CommonHeaderFields headerFields = extractCommonHeaderFields(packet_in_msg);

    //check if it is an arp packet
    if(headerFields.eth_type == ETHERTYPE_ARP){

            //add entry if not existent
            addEntry(headerFields.arp_src_adr.str(),headerFields.src_mac);

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
                    //we need to flood the packet
                    floodedArp++;
                    floodPacket(packet_in_msg);
                }
            }

    }

}


void ARPResponder::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    AbstractControllerApp::receiveSignal(src,id,obj,details);

    if(id == PacketInSignalId){
        EV << "ARPResponder::PacketIn" << '\n';
        if (dynamic_cast<OFP_Packet_In *>(obj) != NULL) {
            OFP_Packet_In *packet_in_msg = (OFP_Packet_In *) obj;
            handlePacketIn(packet_in_msg);
        }
    }
}

EtherFrame * ARPResponder::createArpReply(IPv4Address srcIp, IPv4Address dstIp, MACAddress srcMac,MACAddress dstMac){
    ARPPacket *arpReply = new ARPPacket("controllerArpReply");
    arpReply->setOpcode(ARP_REPLY);
    arpReply->setName("arpReply");
    arpReply->setSrcIPAddress(srcIp);
    arpReply->setSrcMACAddress(srcMac);
    arpReply->setDestIPAddress(dstIp);
    arpReply->setDestMACAddress(dstMac);
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

    return frame;
}


void ARPResponder::finish(){
    AbstractControllerApp::finish();
    // record statistics
    recordScalar("arpFlooded", floodedArp);
    recordScalar("arpAnswered", answeredArp);
}


