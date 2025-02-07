#include "openflow/controllerApps/AbstractControllerApp.h"
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"
#include "inet/linklayer/common/InterfaceTag_m.h"
#include "inet/common/packet/dissector/PacketDissector.h"
#include "inet/networklayer/ipv4/IcmpHeader.h"
#include "inet/common/Protocol.h"
#include "inet/common/ProtocolTag_m.h"
#include "inet/networklayer/common/L3AddressResolver.h"
#include "inet/common/ModuleAccess.h"


simsignal_t AbstractControllerApp::PacketInSignalId = registerSignal("PacketIn");
simsignal_t AbstractControllerApp::PacketOutSignalId = registerSignal("PacketOut");
simsignal_t AbstractControllerApp::PacketFeatureRequestSignalId = registerSignal("PacketFeatureRequest");
simsignal_t AbstractControllerApp::PacketFeatureReplySignalId = registerSignal("PacketFeatureReply");
simsignal_t AbstractControllerApp::BootedSignalId = registerSignal("Booted");

Define_Module(AbstractControllerApp);

AbstractControllerApp::AbstractControllerApp()
{

}

AbstractControllerApp::~AbstractControllerApp()
{

}

void AbstractControllerApp::handleStartOperation(LifecycleOperation *operation)
{
}

void AbstractControllerApp::handleStopOperation(LifecycleOperation *operation)
{

}

void AbstractControllerApp::handleCrashOperation(LifecycleOperation *operation)
{

}

int AbstractControllerApp::getIndexFromId(int id) {
    auto it = ifaceIndex.find(id);
    if (it == ifaceIndex.end()) {
        return -1;
    }
    return it->second;
}

void AbstractControllerApp::initialize(int stage){
    //register signals
    OperationalBase::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        getParentModule()->subscribe("PacketIn",this);
        getParentModule()->subscribe("PacketOut",this);
        getParentModule()->subscribe("PacketFeatureRequest",this);
        getParentModule()->subscribe("PacketFeatureReply",this);
        getParentModule()->subscribe("Booted",this);
    }
    else if (stage == INITSTAGE_APPLICATION_LAYER) {
        auto myNode = getContainingNode(this);
        auto ifTable = L3AddressResolver().findInterfaceTableOf(myNode);
        int index = 0;
        for (int i = 0 ; i < ifTable->getNumInterfaces(); i ++) {
            auto e = ifTable->getInterface(i);
            if (strstr(e->getInterfaceName(),"eth") != nullptr){
                ifaceIndex[e->getId()] = index;
                index++;
            }
        }
    }
}


void AbstractControllerApp::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    Enter_Method_Silent();
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

void AbstractControllerApp::floodPacket(Packet *packet_in_msg){

    if (controller == nullptr)
        throw cRuntimeError("Controller module is not initialized");
    auto header_in = packet_in_msg->peekAtFront<OFP_Packet_In>();
    EV << "floodPacket" << '\n';
    packetsFlooded++;

    TcpSocket *socket = controller->findSocketFor(packet_in_msg);
    controller->sendPacketOut(createFloodPacketFromPacketIn(packet_in_msg), socket);
}

void AbstractControllerApp::dropPacket(Packet *packet_in_msg){

    if (controller == nullptr)
        throw cRuntimeError("Controller module is not initialized");

    auto header_in = packet_in_msg->peekAtFront<OFP_Packet_In>();
    EV << "dropPacket" << '\n';
    packetsDropped++;

    auto socket = controller->findSocketFor(packet_in_msg);
    auto msgAux = createDropPacketFromPacketIn(packet_in_msg);
    controller->sendPacket(socket, msgAux);
}


void AbstractControllerApp::sendPacket(Packet *packet_in_msg, uint32_t outport){

    if (controller == nullptr)
        throw cRuntimeError("Controller module is not initialized");

    auto header_in = packet_in_msg->peekAtFront<OFP_Packet_In>();

    EV << "sendPacket" << '\n';
    numPacketOut++;

    TcpSocket *socket = controller->findSocketFor(packet_in_msg);
    auto msgAux = createPacketOutFromPacketIn(packet_in_msg,outport);
    controller->sendPacket(socket, msgAux);
}

void AbstractControllerApp::sendFlowModMessage(ofp_flow_mod_command mod_com, const oxm_basic_match &match, uint32_t outport, TcpSocket * socket, int idleTimeOut =1 , int hardTimeOut=0){
    if (controller == nullptr)
        throw cRuntimeError("Controller module is not initialized");

    EV << "sendFlowModMessage" << '\n';
    numFlowMod++;
    auto msgAux = createFlowMod(mod_com,match,outport,idleTimeOut,hardTimeOut);
    controller->sendPacket(socket, msgAux);
}

void AbstractControllerApp::finish(){
    // record statistics
    recordScalar("numPacketOut", numPacketOut);
    recordScalar("numFlowMod", numFlowMod);
    recordScalar("packetsDropped", packetsDropped);
    recordScalar("packetsFlooded", packetsFlooded);

}


//OFP_Flow_Mod * AbstractControllerApp::createFlowMod(ofp_flow_mod_command mod_com,const oxm_basic_match  &match, uint32_t outport, int idleTimeOut =1 , int hardTimeOut=0){
Packet * AbstractControllerApp::createFlowMod(ofp_flow_mod_command mod_com,const oxm_basic_match  &match, uint32_t outport, int idleTimeOut =1 , int hardTimeOut=0){
    //OFP_Flow_Mod *flow_mod_msg = new OFP_Flow_Mod("flow_mod");
    auto flow_mod_msg = makeShared<OFP_Flow_Mod>();
    auto pkt = new Packet("flow_mod");

    flow_mod_msg->getHeaderForUpdate().version = OFP_VERSION;
    flow_mod_msg->getHeaderForUpdate().type = OFPT_FLOW_MOD;
    flow_mod_msg->setCommand(mod_com);
    flow_mod_msg->setMatch(match);
    flow_mod_msg->setChunkLength(B(56));
    flow_mod_msg->setHard_timeout(hardTimeOut);
    flow_mod_msg->setIdle_timeout(idleTimeOut);
    ofp_action_output *action_output = new ofp_action_output();
    action_output->port = outport;
    flow_mod_msg->setActionsArraySize(1);
    flow_mod_msg->setActions(0, *action_output);
    pkt->insertAtFront(flow_mod_msg);

    pkt->setKind(TCP_C_SEND);

    return pkt;
}


//OFP_Packet_Out * AbstractControllerApp::createPacketOutFromPacketIn(OFP_Packet_In *packet_in_msg, uint32_t outport){
Packet * AbstractControllerApp::createPacketOutFromPacketIn(Packet *pktIn, uint32_t outport){
    auto packetOut = makeShared<OFP_Packet_Out>();
    Packet *pktOut = nullptr;
    auto packet_in_msg = pktIn->removeAtFront<OFP_Packet_In>();

    packetOut->getHeaderForUpdate().version = OFP_VERSION;
    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
    packetOut->setBuffer_id(packet_in_msg->getBuffer_id());
    packetOut->setChunkLength(B(24));

    if (packet_in_msg->getBuffer_id() == OFP_NO_BUFFER){
        auto frame = pktIn->peekAtFront<EthernetMacHeader>();
        //EthernetIIFrame *frame =  dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket());
        pktOut = pktIn->dup();
        //packetOut->encapsulate(frame->dup());
        auto ifaceId = pktIn->getTag<InterfaceInd>()->getInterfaceId();
        packetOut->setIn_port(ifaceId);
    } else {
        packetOut->setIn_port(packet_in_msg->getMatch().OFB_IN_PORT);
        pktOut = new Packet("packetOut");
    }
    pktIn->insertAtFront(packet_in_msg);

    ofp_action_output *action_output = new ofp_action_output();
    action_output->creationModule = dynamic_cast<cModule *>(this)->getClassAndFullName();
    action_output->port = outport;
    packetOut->setActionsArraySize(1);
    packetOut->setActions(0, *action_output);
    pktOut->insertAtFront(packetOut);

    pktOut->setKind(TCP_C_SEND);

    return pktOut;
}

//OFP_Packet_Out * AbstractControllerApp::createFloodPacketFromPacketIn(OFP_Packet_In *packet_in_msg){
Packet * AbstractControllerApp::createFloodPacketFromPacketIn(Packet *pktIn){

    auto packet_in_msg = pktIn->removeAtFront<OFP_Packet_In>();

    auto packetOut = makeShared<OFP_Packet_Out>();
    Packet *pktOut = nullptr;
    packetOut->getHeaderForUpdate().version = OFP_VERSION;
    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
    packetOut->setBuffer_id(packet_in_msg->getBuffer_id());
    packetOut->setChunkLength(B(24));

    if (packet_in_msg->getBuffer_id() == OFP_NO_BUFFER){
        auto frame = pktIn->peekAtFront<EthernetMacHeader>();
        pktOut = pktIn->dup();
        auto ifaceId = pktIn->getTag<InterfaceInd>()->getInterfaceId();
        packetOut->setIn_port(ifaceId);
        //EthernetIIFrame *frame =  dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket());
        // packetOut->encapsulate(frame->dup());
        // packetOut->setIn_port(frame->getArrivalGate()->getIndex());
    }else{
        packetOut->setIn_port(packet_in_msg->getMatch().OFB_IN_PORT);
        pktOut = new Packet("packetOut");
    }

    pktIn->insertAtFront(packet_in_msg);

    ofp_action_output *action_output = new ofp_action_output();
    action_output->creationModule = dynamic_cast<cModule *>(this)->getClassAndFullName();
    action_output->port = OFPP_FLOOD;
    packetOut->setActionsArraySize(1);
    packetOut->setActions(0, *action_output);

    pktOut->insertAtFront(packetOut);
    pktOut->setKind(TCP_C_SEND);

    return pktOut;
}

//OFP_Packet_Out * AbstractControllerApp::createDropPacketFromPacketIn(OFP_Packet_In *packet_in_msg){
Packet * AbstractControllerApp::createDropPacketFromPacketIn(Packet *pktIn){

    auto packet_in_msg = pktIn->removeAtFront<OFP_Packet_In>();
    auto packetOut = makeShared<OFP_Packet_Out>();
    Packet *pktOut = nullptr;
    //OFP_Packet_Out *packetOut = new OFP_Packet_Out("packetOut");
    packetOut->getHeaderForUpdate().version = OFP_VERSION;
    packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
    packetOut->setBuffer_id(packet_in_msg->getBuffer_id());
    packetOut->setChunkLength(B(24));

    if (packet_in_msg->getBuffer_id() == OFP_NO_BUFFER){
        auto frame = pktIn->peekAtFront<EthernetMacHeader>();
        pktOut = pktIn->dup();
        auto ifaceId = pktIn->getTag<InterfaceInd>()->getInterfaceId();
        packetOut->setIn_port(ifaceId);
        //EthernetIIFrame *frame =  dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket());
        //packetOut->encapsulate(frame->dup());
        //packetOut->setIn_port(frame->getArrivalGate()->getIndex());
    }else{
        packetOut->setIn_port(packet_in_msg->getMatch().OFB_IN_PORT);
        pktOut = new Packet("packetOut");
    }
    pktIn->insertAtFront(packet_in_msg);

    ofp_action_output *action_output = new ofp_action_output();
    action_output->creationModule = dynamic_cast<cModule *>(this)->getClassAndFullName();
    action_output->port = OFPP_ANY;
    packetOut->setActionsArraySize(1);
    packetOut->setActions(0, *action_output);

    pktOut->insertAtFront(packetOut);
    pktOut->setKind(TCP_C_SEND);

    return pktOut;
}

bool AbstractControllerApp::chekIcmpEchoRequest(Packet *pkt, int &seqNumber, int &identifier) {
    PacketDissector::PduTreeBuilder pduTreeBuilder;
    auto packetProtocolTag = pkt->findTag<PacketProtocolTag>();
    auto protocol = packetProtocolTag != nullptr ? packetProtocolTag->getProtocol() : nullptr;
#if INET_VERSION >= 0x0405
    PacketDissector packetDissector(ProtocolDissectorRegistry::getInstance(), pduTreeBuilder);
#else
    PacketDissector packetDissector(ProtocolDissectorRegistry::globalRegistry, pduTreeBuilder);
#endif
    packetDissector.dissectPacket(pkt, protocol);

    auto& protocolDataUnit = pduTreeBuilder.getTopLevelPdu();

    for (const auto& chunk : protocolDataUnit->getChunks()) {
        if (auto childLevel = dynamicPtrCast<const PacketDissector::ProtocolDataUnit>(chunk)) {
            for (const auto& chunkAux : childLevel->getChunks()) {
                if (chunkAux->getChunkType() == Chunk::CT_SEQUENCE) {
                    for (const auto& elementChunk : staticPtrCast<const SequenceChunk>(chunkAux)->getChunks()) {
                        if (dynamic_cast<const IcmpEchoRequest *>(elementChunk.get())) {
                            seqNumber = dynamic_cast<const IcmpEchoRequest *>(elementChunk.get())->getSeqNumber();
                            identifier = dynamic_cast<const IcmpEchoRequest *>(elementChunk.get())->getIdentifier();
                            return true;
                        }
                    }
                }
            }
        }
        else if (chunk->getChunkType() == Chunk::CT_SEQUENCE) {
            for (const auto& elementChunk : staticPtrCast<const SequenceChunk>(chunk)->getChunks()) {
                if (dynamic_cast<const IcmpEchoRequest *>(elementChunk.get())) {
                    seqNumber = dynamic_cast<const IcmpEchoRequest *>(elementChunk.get())->getSeqNumber();
                    identifier = dynamic_cast<const IcmpEchoRequest *>(elementChunk.get())->getIdentifier();
                    return true;
                }
            }
        }
    }
    return false;
}


CommonHeaderFields AbstractControllerApp::extractCommonHeaderFields(Packet *pktIn){
    CommonHeaderFields headerFields = CommonHeaderFields();

    headerFields.swInfo = controller->findSwitchInfoFor(pktIn);
    auto packet_in_msg = pktIn->removeAtFront<OFP_Packet_In>();

    headerFields.buffer_id = packet_in_msg->getBuffer_id();


    // packet is encapsulated in packet-in message
    if (headerFields.buffer_id == OFP_NO_BUFFER){
        auto ifaceId = pktIn->getTag<InterfaceInd>()->getInterfaceId();
        auto frame = pktIn->peekAtFront<EthernetMacHeader>();
        headerFields.inport = ifaceId;
        headerFields.src_mac = frame->getSrc();
        headerFields.dst_mac = frame->getDest();
        headerFields.eth_type = frame->getTypeOrLength();

        //headerFields.inport = packet_in_msg->getEncapsulatedPacket()->getArrivalGate()->getIndex();
        //headerFields.src_mac = dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket())->getSrc();
        //headerFields.dst_mac = dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket())->getDest();
        //headerFields.eth_type = dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket())->getEtherType();

        if(headerFields.eth_type ==ETHERTYPE_ARP){
            auto frameAux = pktIn->removeAtFront<EthernetMacHeader>();
            auto arpPacket = pktIn->peekAtFront<ArpPacket>();
            headerFields.arp_src_adr = arpPacket->getSrcIpAddress();
            headerFields.arp_dst_adr = arpPacket->getDestIpAddress();
            headerFields.arp_op = arpPacket->getOpcode();
            pktIn->insertAtFront(frameAux);
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

    pktIn->insertAtFront(packet_in_msg);

    return headerFields;
}

