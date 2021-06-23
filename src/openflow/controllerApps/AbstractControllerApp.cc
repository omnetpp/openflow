#include "openflow/controllerApps/AbstractControllerApp.h"

Define_Module(AbstractControllerApp);

AbstractControllerApp::AbstractControllerApp()
{

}

AbstractControllerApp::~AbstractControllerApp()
{

}


void AbstractControllerApp::initialize(){
    //register signals
    PacketInSignalId =registerSignal("PacketIn");
    PacketOutSignalId =registerSignal("PacketOut");
    PacketFeatureRequestSignalId = registerSignal("PacketFeatureRequest");
    PacketFeatureReplySignalId = registerSignal("PacketFeatureReply");
    BootedSignalId= registerSignal("Booted");

    getParentModule()->subscribe("PacketIn",this);
    getParentModule()->subscribe("PacketOut",this);
    getParentModule()->subscribe("PacketFeatureRequest",this);
    getParentModule()->subscribe("PacketFeatureReply",this);
    getParentModule()->subscribe("Booted",this);

    packetsFlooded=0;
    packetsDropped=0;
    numPacketOut=0;
    numFlowMod=0;

    controller= NULL;
}


void AbstractControllerApp::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {

    //register at controller
    if(id == BootedSignalId){
        EV << "ARPResponder::Booted" << '\n';
        if (dynamic_cast<OF_Controller *>(obj) != NULL) {
            OF_Controller *cntrl = (OF_Controller *) obj;
            this->controller = cntrl;
            controller->registerApp(this);
        }

    }
}

void AbstractControllerApp::floodPacket(OFP_Packet_In *packet_in_msg){
    EV << "floodPacket" << '\n';
    packetsFlooded++;

    TCPSocket *socket = controller->findSocketFor(packet_in_msg);
    controller->sendPacketOut(createFloodPacketFromPacketIn(packet_in_msg), socket);
}

void AbstractControllerApp::dropPacket(OFP_Packet_In *packet_in_msg){
    EV << "dropPacket" << '\n';
    packetsDropped++;

    TCPSocket *socket = controller->findSocketFor(packet_in_msg);
    controller->sendPacketOut(createDropPacketFromPacketIn(packet_in_msg), socket);
}


void AbstractControllerApp::sendPacket(OFP_Packet_In *packet_in_msg, uint32_t outport){
    EV << "sendPacket" << '\n';
    numPacketOut++;

    TCPSocket *socket = controller->findSocketFor(packet_in_msg);
    socket->send(createPacketOutFromPacketIn(packet_in_msg,outport));
}

void AbstractControllerApp::sendFlowModMessage(ofp_flow_mod_command mod_com, const oxm_basic_match &match, uint32_t outport, TCPSocket * socket, int idleTimeOut =1 , int hardTimeOut=0){
    EV << "sendFlowModMessage" << '\n';
    numFlowMod++;

    socket->send(createFlowMod(mod_com,match,outport,idleTimeOut,hardTimeOut));
}

void AbstractControllerApp::finish(){
    // record statistics
    recordScalar("numPacketOut", numPacketOut);
    recordScalar("numFlowMod", numFlowMod);
    recordScalar("packetsDropped", packetsDropped);
    recordScalar("packetsFlooded", packetsFlooded);

}


OFP_Flow_Mod * AbstractControllerApp::createFlowMod(ofp_flow_mod_command mod_com,const oxm_basic_match  &match, uint32_t outport, int idleTimeOut =1 , int hardTimeOut=0){
    OFP_Flow_Mod *flow_mod_msg = new OFP_Flow_Mod("flow_mod");
    flow_mod_msg->getHeaderForUpdate().version = OFP_VERSION;
    flow_mod_msg->getHeaderForUpdate().type = OFPT_FLOW_MOD;
    flow_mod_msg->setCommand(mod_com);
    flow_mod_msg->setMatch(match);
    flow_mod_msg->setByteLength(56);
    flow_mod_msg->setHard_timeout(hardTimeOut);
    flow_mod_msg->setIdle_timeout(idleTimeOut);
    ofp_action_output *action_output = new ofp_action_output();
    action_output->port = outport;
    flow_mod_msg->setActionsArraySize(1);
    flow_mod_msg->setActions(0, *action_output);

    flow_mod_msg->setKind(TCP_C_SEND);

    return flow_mod_msg;
}


OFP_Packet_Out * AbstractControllerApp::createPacketOutFromPacketIn(OFP_Packet_In *packet_in_msg, uint32_t outport){
    OFP_Packet_Out *packetOut = new OFP_Packet_Out("packetOut");
    packetOut->getHeaderForUpdate().version = OFP_VERSION;
    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
    packetOut->setBuffer_id(packet_in_msg->getBuffer_id());
    packetOut->setByteLength(24);

    if (packet_in_msg->getBuffer_id() == OFP_NO_BUFFER){
        EthernetIIFrame *frame =  dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket());
        packetOut->encapsulate(frame->dup());
        packetOut->setIn_port(frame->getArrivalGate()->getIndex());
    } else {
        packetOut->setIn_port(packet_in_msg->getMatch().OFB_IN_PORT);
    }

    ofp_action_output *action_output = new ofp_action_output();
    action_output->port = outport;
    packetOut->setActionsArraySize(1);
    packetOut->setActions(0, *action_output);

    packetOut->setKind(TCP_C_SEND);

    return packetOut;
}



OFP_Packet_Out * AbstractControllerApp::createFloodPacketFromPacketIn(OFP_Packet_In *packet_in_msg){
    OFP_Packet_Out *packetOut = new OFP_Packet_Out("packetOut");
    packetOut->getHeaderForUpdate().version = OFP_VERSION;
    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
    packetOut->setBuffer_id(packet_in_msg->getBuffer_id());
    packetOut->setByteLength(24);

    if (packet_in_msg->getBuffer_id() == OFP_NO_BUFFER){
        EthernetIIFrame *frame =  dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket());
        packetOut->encapsulate(frame->dup());
        packetOut->setIn_port(frame->getArrivalGate()->getIndex());
    }else{
        packetOut->setIn_port(packet_in_msg->getMatch().OFB_IN_PORT);
    }

    ofp_action_output *action_output = new ofp_action_output();
    action_output->port = OFPP_FLOOD;
    packetOut->setActionsArraySize(1);
    packetOut->setActions(0, *action_output);

    packetOut->setKind(TCP_C_SEND);

    return packetOut;
}

OFP_Packet_Out * AbstractControllerApp::createDropPacketFromPacketIn(OFP_Packet_In *packet_in_msg){
    OFP_Packet_Out *packetOut = new OFP_Packet_Out("packetOut");
    packetOut->getHeaderForUpdate().version = OFP_VERSION;
    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
    packetOut->setBuffer_id(packet_in_msg->getBuffer_id());
    packetOut->setByteLength(24);

    if (packet_in_msg->getBuffer_id() == OFP_NO_BUFFER){
        EthernetIIFrame *frame =  dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket());
        packetOut->encapsulate(frame->dup());
        packetOut->setIn_port(frame->getArrivalGate()->getIndex());
    }else{
        packetOut->setIn_port(packet_in_msg->getMatch().OFB_IN_PORT);
    }

    ofp_action_output *action_output = new ofp_action_output();
    action_output->port = OFPP_ANY;
    packetOut->setActionsArraySize(1);
    packetOut->setActions(0, *action_output);

    packetOut->setKind(TCP_C_SEND);

    return packetOut;
}

CommonHeaderFields AbstractControllerApp::extractCommonHeaderFields(OFP_Packet_In *packet_in_msg){
    CommonHeaderFields headerFields = CommonHeaderFields();

    headerFields.buffer_id = packet_in_msg->getBuffer_id();
    headerFields.swInfo = controller->findSwitchInfoFor(packet_in_msg);


    // packet is encapsulated in packet-in message
    if (headerFields.buffer_id == OFP_NO_BUFFER){
        headerFields.inport = packet_in_msg->getEncapsulatedPacket()->getArrivalGate()->getIndex();
        headerFields.src_mac = dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket())->getSrc();
        headerFields.dst_mac = dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket())->getDest();
        headerFields.eth_type = dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket())->getEtherType();

        if(headerFields.eth_type ==ETHERTYPE_ARP){
            ARPPacket *arpPacket = check_and_cast<ARPPacket *>((dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket()))->getEncapsulatedPacket());
            headerFields.arp_src_adr = arpPacket->getSrcIPAddress();
            headerFields.arp_dst_adr = arpPacket->getDestIPAddress();
            headerFields.arp_op = arpPacket->getOpcode();
        }
    }else{
        headerFields.inport = packet_in_msg->getMatch().OFB_IN_PORT;
        headerFields.src_mac = packet_in_msg->getMatch().OFB_ETH_SRC;
        headerFields.dst_mac = packet_in_msg->getMatch().OFB_ETH_DST;
        headerFields.eth_type = packet_in_msg->getMatch().OFB_ETH_TYPE;
        headerFields.arp_src_adr = packet_in_msg->getMatch().OFB_ARP_SPA;
        headerFields.arp_dst_adr = packet_in_msg->getMatch().OFB_ARP_TPA;
        headerFields.arp_op = packet_in_msg->getMatch().OFB_ARP_OP;
    }

    return headerFields;

}

