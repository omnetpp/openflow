#include "openflow/controllerApps/Hub.h"

Define_Module(Hub);

Hub::Hub(){

}

Hub::~Hub(){

}

void Hub::initialize(int stage){
    AbstractControllerApp::initialize(stage);
}

void Hub::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    AbstractControllerApp::receiveSignal(src,id,obj,details);
    Enter_Method("Hub::receiveSignal %s", cComponent::getSignalName(id));
    if(id == PacketInSignalId){
        EV << "Hub::PacketIn" << '\n';
        auto pkt = dynamic_cast<Packet *>(obj);
        if (pkt != nullptr) {
            auto chunk = pkt->peekAtFront<Chunk>();
            auto packet_in_msg = dynamicPtrCast<const OFP_Packet_In>(chunk);
            if (packet_in_msg != nullptr)
                floodPacket(pkt);
        }
    }
//
//    if(id == PacketInSignalId){
//        EV << "Hub::PacketIn" << '\n';
//        if (dynamic_cast<OFP_Packet_In *>(obj) != NULL) {
//            OFP_Packet_In *packet_in = (OFP_Packet_In *) obj;
//            floodPacket(packet_in);
//        }
//    }
}

