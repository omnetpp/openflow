#include "openflow/openflow/switch/OF_Switch.h"
#include "openflow/openflow/protocol/openflow.h"

#include "openflow/messages/Open_Flow_Message_m.h"
#include "openflow/messages/OFP_Initialize_Handshake_m.h"
#include "openflow/messages/OFP_Features_Reply_m.h"
#include "openflow/messages/OFP_Hello_m.h"

#include "openflow/messages/OFP_Packet_In_m.h"
#include "openflow/messages/OFP_Packet_Out_m.h"
#include "openflow/messages/OFP_Flow_Mod_m.h"

#include "inet/linklayer/ethernet/common/Ethernet.h"
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"
#include "inet/linklayer/common/MacAddress.h"
#include "inet/networklayer/arp/ipv4/ArpPacket_m.h"

#include "inet/networklayer/common/L3AddressResolver.h"

#include "inet/common/ModuleAccess.h"
#include "inet/networklayer/common/InterfaceTable.h"
#include "inet/linklayer/ethernet/base/EthernetMacBase.h"
#include "inet/linklayer/common/InterfaceTag_m.h"
#include <vector>
#include "inet/common/packet/dissector/PacketDissector.h"
#include "inet/networklayer/ipv4/IcmpHeader.h"
#include "inet/common/Protocol.h"
#include "inet/common/ProtocolTag_m.h"

//#include "inet/applications/pingapp/PingPayload_m.h"
//#include "inet/networklayer/ipv4/ICMPMessage.h"


#define MSGKIND_CONNECT                     1
#define MSGKIND_SERVICETIME                 3


Define_Module(OF_Switch);

OF_Switch::OF_Switch(){

}

OF_Switch::~OF_Switch(){

}

int OF_Switch::getIndexFromId(int id) {
    auto it = ifaceIndex.find(id);
    if (it == ifaceIndex.end()) {
        return -1;
    }
    return it->second;
}


void OF_Switch::initialize(int stage){
    OperationalBase::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
    //read ned file parameters
        flowTimeoutPollInterval = par("flowTimeoutPollInterval");
        serviceTime = par("serviceTime");
        busy = false;
        sendCompletePacket = par("sendCompletePacket");
        //stats
        dpPingPacketHash = registerSignal("dpPingPacketHash");
        cpPingPacketHash = registerSignal("cpPingPacketHash");
        queueSize = registerSignal("queueSize");
        bufferSize = registerSignal("bufferSize");
        waitingTime = registerSignal("waitingTime");
        dataPlanePacket=0l;
        controlPlanePacket=0l;
        flowTableHit=0l;
        flowTableMiss=0l;
        // Init all ports

        //init helper classes
        buffer = Buffer((int)par("bufferCapacity"));

        //remove unused nics from ift
        //    for(int i=0; i< interfaceTable->getNumInterfaces() ;i++){
        //        if(interfaceTable->getInterface(i) != interfaceTable->getInterfaceByName("eth0")){
        //            interfaceTable->deleteInterface(interfaceTable->getInterface(i));
        //            i--;
        //        }
        //    }
    }

    else if (stage == INITSTAGE_NETWORK_CONFIGURATION) {
        portVector.resize(gateSize("dataPlaneIn"));
        for(unsigned int i=0;i<portVector.size();i++){
            portVector[i].port_no = i+1;
            cModule *ethernetModule = gate("dataPlaneOut",i)->getNextGate()->getOwnerModule()->getSubmodule("mac");
            if(dynamic_cast<EthernetMacBase *>(ethernetModule) != NULL) {
                auto nic = (EthernetMacBase*)ethernetModule;
                uint64_t tmpHw = nic->getMacAddress().getInt();
                memcpy(portVector[i].hw_addr,&tmpHw, sizeof tmpHw);
            }
            sprintf(portVector[i].name,"Port: %d",i);
            portVector[i].config = 0;
            portVector[i].state = 0;
            portVector[i].curr = 0;
            portVector[i].advertised = 0;
            portVector[i].supported = 0;
            portVector[i].peer = 0;
            portVector[i].curr_speed = 0;
            portVector[i].max_speed = 0;
        }


        IInterfaceTable* interfaceTable = getModuleFromPar<IInterfaceTable>(par("interfaceTableModule"), this);

        auto eth0Iface = interfaceTable->findInterfaceByName("eth0");
        if (eth0Iface == nullptr)
            throw cRuntimeError("OF_Switch::Interface eth0 doesn't exist");
        for(int i=0; i< interfaceTable->getNumInterfaces() ;i++){
            if (interfaceTable->getInterface(i) != eth0Iface) {
                interfaceTable->getInterface(i)->setState(NetworkInterface::State::DOWN);
                listInterfacesToDelete.push_back(interfaceTable->getInterface(i)); // The interfaces cannot be deleted in the initalization phase
            }
        }
    }
    else if (stage == INITSTAGE_APPLICATION_LAYER) {
        //init socket to controller
        const char *localAddress = par("localAddress");
        int localPort = par("localPort");
        socket.bind(*localAddress ? L3Address(localAddress) : L3Address(), localPort);
        socket.setOutputGate(gate("controlPlaneOut"));
        //socket.setDataTransferMode(TCP_TRANSFER_OBJECT);
        //schedule connection setup
        WATCH_MAP(ifaceIndex);
    }
}

void OF_Switch::handleStartOperation(LifecycleOperation *operation)
{
    IInterfaceTable* interfaceTable = getModuleFromPar<IInterfaceTable>(par("interfaceTableModule"), this);


    // search the interfaces in the data plane

    for (int i = 0; i < gateSize("dataPlaneOut");i++)
    {
        auto gateAux = gate("dataPlaneOut", i);
        auto mod = gateAux->getPathEndGate()->getOwnerModule();
        auto iface = getContainingNicModule(mod);
        if (iface == nullptr)
            throw cRuntimeError("Interface not found");
        ifaceIndex[iface->getInterfaceId()] = i;
        controlPlaneIndex[iface->getInterfaceId()] = i;
    }

    int index = 0;
    for (int i = 0 ; i < interfaceTable->getNumInterfaces(); i ++) {
        auto e = interfaceTable->getInterface(i);
        if (strstr(e->getInterfaceName(),"eth") != nullptr){
            ifaceIndex[e->getInterfaceId()] = index;
            index++;
        }
    }

//    while (!listInterfacesToDelete.empty()) {
//        interfaceTable->deleteInterface(listInterfacesToDelete.back());
//        listInterfacesToDelete.pop_back();
//    }

    cMessage *initiateConnection = new cMessage("initiateConnection");
    initiateConnection->setKind(MSGKIND_CONNECT);
    simtime_t start = par("connectAt");
    simtime_t starOperation = std::max(simTime(), start);
    scheduleAt(starOperation, initiateConnection);
}


void OF_Switch::handleMessageWhenUp(cMessage *msg){

    if (msg->isSelfMessage()){
        if (msg->getKind()==MSGKIND_CONNECT) {
            EV << "starting session" << '\n';
            connect(""); // active OPEN
        } else if(msg->getKind()==MSGKIND_SERVICETIME){
            //This is message which has been scheduled due to service time

            //Get the Original message
            auto data_msg = check_and_cast<Packet *>((cObject *)msg->getContextPointer());
            emit(waitingTime,(simTime() - data_msg->getArrivalTime() - serviceTime));
            processQueuedMsg(data_msg);

            //delete the processed msg
            delete data_msg;

            //Trigger next service time
            if (msgList.empty()){
                busy = false;
            } else {
                cMessage *msgFromList = msgList.front();
                msgList.pop_front();
                cMessage *event = new cMessage("event");
                event->setKind(MSGKIND_SERVICETIME);
                event->setContextPointer(msgFromList);
                scheduleAt(simTime()+serviceTime, event);
            }
        }
        //delete the msg for efficiency
        delete msg;
    } else {
        if(msg->getKind() == TCP_I_ESTABLISHED){
            socket.processMessage(msg);
        }else{
            //imlement service time
            if (busy) {
                msgList.push_back(msg);
            } else {
                busy = true;
                cMessage *event = new cMessage("event");
                event->setKind(MSGKIND_SERVICETIME);
                event->setContextPointer(msg);
                scheduleAt(simTime()+serviceTime, event);
            }
            emit(queueSize,msgList.size());
            emit(bufferSize,buffer.size());
        }
    }
}

void OF_Switch::connect(const char *addressToConnect){
    socket.renewSocket();
    const char *connectAddress;

    int connectPort = par("connectPort");

    if(strlen(addressToConnect) == 0){
        connectAddress = par("connectAddress");
    } else {
        connectAddress = addressToConnect;
    }


    EV << "Sending Hello to" << connectAddress <<" \n";

    socket.connect(L3AddressResolver().resolve(connectAddress), connectPort);
    auto hello = makeShared<OFP_Hello>();
    auto pktHello = new Packet("Hello");
    //OFP_Hello *msg = new OFP_Hello("Hello");
    hello->getHeaderForUpdate().version = OFP_VERSION;
    hello->getHeaderForUpdate().type = OFPT_HELLO;
    hello->setChunkLength(B(8));
    pktHello->setKind(TCP_C_SEND);
    pktHello->insertAtFront(hello);
    socket.send(pktHello);
}

void OF_Switch::processQueuedMsg(Packet *data_msg){

    if(data_msg->arrivedOn("dataPlaneIn")){
        dataPlanePacket++;
        if(socket.getState() != TcpSocket::CONNECTED){
            //no yet connected to controller
            //drop packet by returning
            return;
        }

        auto chunk = data_msg->peekAtFront<Chunk>();
        if (dynamicPtrCast<const EthernetMacHeader>(chunk) != nullptr){ //msg from dataplane
            //EthernetIIFrame *frame = (EthernetIIFrame *)data_msg;
            //copy the frame as the original will be deleted
            auto copy = data_msg->dup();
            processFrame(copy);
        }
    } else {
        controlPlanePacket++;
        auto chunk = data_msg->peekAtFront<Chunk>();
       if (dynamicPtrCast<const Open_Flow_Message>(chunk) != nullptr) { //msg from controller
            auto of_msg = dynamicPtrCast<const Open_Flow_Message>(chunk);
//            Open_Flow_Message *of_msg = (Open_Flow_Message *)data_msg;
            ofp_type type = (ofp_type)of_msg->getHeader().type;
            switch ((int)type){
                case OFPT_FEATURES_REQUEST:
                    handleFeaturesRequestMessage(data_msg);
                    break;
                case OFPT_FLOW_MOD:
                    handleFlowModMessage(data_msg);
                    break;
                case OFPT_PACKET_OUT:
                    handlePacketOutMessage(data_msg);
                    break;
                default:
                    // Should launch an exception?
                    break;
                }
        }

    }
}


static bool chekIcmpEchoRequest(Packet *pkt, int &seqNumber, int &identifier) {
    PacketDissector::PduTreeBuilder pduTreeBuilder;
    auto packetProtocolTag = pkt->findTag<PacketProtocolTag>();
    auto protocol = packetProtocolTag != nullptr ? packetProtocolTag->getProtocol() : nullptr;
    PacketDissector packetDissector(ProtocolDissectorRegistry::globalRegistry, pduTreeBuilder);
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

void OF_Switch::processFrame(Packet *pkt){
    oxm_basic_match match = oxm_basic_match();

    //EthernetIIFrame *frame
    //extract match fields
    auto ifaceId = pkt->getTag<InterfaceInd>()->getInterfaceId();
    auto frame = pkt->removeAtFront<EthernetMacHeader>();

    match.OFB_IN_PORT = ifaceId; //frame->getArrivalGate()->getIndex();
    match.OFB_ETH_SRC = frame->getSrc();
    match.OFB_ETH_DST = frame->getDest();
    match.OFB_ETH_TYPE = frame->getTypeOrLength();

    //extract ARP specific match fields if present
    if(frame->getTypeOrLength()==ETHERTYPE_ARP){
        auto arpPacket = pkt->peekAtFront<ArpPacket>();
//        ARPPacket *arpPacket = check_and_cast<ARPPacket *>(frame->getEncapsulatedPacket());
        match.OFB_ARP_OP = arpPacket->getOpcode();
        match.OFB_ARP_SHA = arpPacket->getSrcMacAddress();
        match.OFB_ARP_THA = arpPacket->getDestMacAddress();
        match.OFB_ARP_SPA = arpPacket->getSrcIpAddress();
        match.OFB_ARP_TPA = arpPacket->getDestIpAddress();
    }

    pkt->insertAtFront(frame);

    unsigned long hash =0;
    int seqNumber = 0;
    int identifier;

    //emit id of ping packet to indicate where it was processed

    if(chekIcmpEchoRequest(pkt, seqNumber, identifier)){
        //generate and emit hash
        std::stringstream hashString;
        hashString << "SeqNo-" << seqNumber << "-Pid-" << identifier;
        hash = std::hash<std::string>()(hashString.str().c_str());
    }

//    if(dynamic_cast<ICMPMessage *>(frame->getEncapsulatedPacket()->getEncapsulatedPacket()) != NULL){
//        ICMPMessage *icmpMessage = (ICMPMessage *)frame->getEncapsulatedPacket()->getEncapsulatedPacket();
//
//        PingPayload * pingMsg =  (PingPayload * )icmpMessage->getEncapsulatedPacket();
//        //generate and emit hash
//        std::stringstream hashString;
//        hashString << "SeqNo-" << pingMsg->getSeqNo() << "-Pid-" << pingMsg->getOriginatorId();
//        hash = std::hash<std::string>()(hashString.str().c_str());
//    }


   Flow_Table_Entry *lookup = flowTable.lookup(match);
   if (lookup != NULL){
       //lookup successful
       flowTableHit++;
       EV << "Found entry in flow table." << '\n';
       ofp_action_output action_output = lookup->getInstructions();
       uint32_t outport = action_output.port;
       if(outport == OFPP_CONTROLLER){
           //send it to the controller
//           OFP_Packet_In *packetIn = new OFP_Packet_In("packetIn");
//           packetIn->getHeader().version = OFP_VERSION;
//           packetIn->getHeader().type = OFPT_PACKET_IN;
//           packetIn->setReason(OFPR_ACTION);
//           packetIn->setByteLength(32);
//           packetIn->encapsulate(frame);
//           packetIn->setBuffer_id(OFP_NO_BUFFER);
//           socket.send(packetIn);
           auto packetIn = makeShared<OFP_Packet_In>();
           packetIn->getHeaderForUpdate().version = OFP_VERSION;
           packetIn->getHeaderForUpdate().type = OFPT_PACKET_IN;
           packetIn->setReason(OFPR_ACTION);
           packetIn->setChunkLength(B(32));
           packetIn->setBuffer_id(OFP_NO_BUFFER);
           pkt->insertAtFront(packetIn);
           socket.send(pkt);
           if(hash !=0){
               emit(cpPingPacketHash,hash);
           }
       } else {
           if(hash !=0){
               emit(dpPingPacketHash,hash);
           }
           //send it out the dataplane on the specific port
           auto indexPort = getIndexFromId(outport);
           if (indexPort == -1)
               throw cRuntimeError("Unknown dataPlaneOut sending port/gate");
           send(pkt, "dataPlaneOut", indexPort);
       }
   } else {
       if(hash !=0){
           emit(cpPingPacketHash,hash);
       }
       // lookup failed
       flowTableMiss++;
       EV << "No Entry Found contacting controller" << '\n';
       handleMissMatchedPacket(pkt);
   }
}

//void OF_Switch::handleFeaturesRequestMessage(Open_Flow_Message *of_msg){
void OF_Switch::handleFeaturesRequestMessage(Packet *pktOf){
    auto of_msg = pktOf->peekAtFront<Open_Flow_Message>();

    auto featuresReply = makeShared<OFP_Features_Reply>();// new OFP_Features_Reply("FeaturesReply");
    featuresReply->getHeaderForUpdate().version = OFP_VERSION;
    featuresReply->getHeaderForUpdate().type = OFPT_FEATURES_REPLY;

    IInterfaceTable *inet_ift = getModuleFromPar<IInterfaceTable>(par("interfaceTableModule"), this);

    MacAddress mac = inet_ift->getInterface(0)->getMacAddress();


    //output address
    EV <<"SwitchID:" << mac.str().c_str() << " SwitchPath:" << this->getFullPath() << '\n';


    featuresReply->setDatapath_id(mac.str().c_str());
    featuresReply->setN_buffers(buffer.getCapacity());
    featuresReply->setN_tables(1);
    featuresReply->setPortsArraySize(gateSize("dataPlaneOut"));
    for (auto elem : controlPlaneIndex) {
        if (elem.second < 0 || elem.second >=  featuresReply->getPortsArraySize())
            throw cRuntimeError("Index is incorrect");
        featuresReply->setPorts(elem.second, elem.first);
    }
    featuresReply->setChunkLength(B(32));
    auto pktReply = new Packet("FeaturesReply");
    pktReply->insertAtFront(featuresReply);
    //featuresReply->setByteLength(32);
    //featuresReply->setKind(TCP_C_SEND);
    pktReply->setKind(TCP_C_SEND);
    socket.send(pktReply);
}

//void OF_Switch::handleFlowModMessage(Open_Flow_Message *of_msg){
void OF_Switch::handleFlowModMessage(Packet *pktOf){
    auto of_msg = pktOf->peekAtFront<Open_Flow_Message>();
    EV << "OFA_switch::handleFlowModMessage" << '\n';
    auto flowModMsg = staticPtrCast<const OFP_Flow_Mod>(of_msg);//(OFP_Flow_Mod *) of_msg;

    flowTable.addEntry(Flow_Table_Entry(flowModMsg.get()));
}




//void OF_Switch::handleMissMatchedPacket(EthernetIIFrame *frame){
void OF_Switch::handleMissMatchedPacket(Packet *pktFrame){
    //OFP_Packet_In *packetIn = new OFP_Packet_In("packetIn");
    auto packetIn = makeShared<OFP_Packet_In>();//("packetIn");
    packetIn->getHeaderForUpdate().version = OFP_VERSION;
    packetIn->getHeaderForUpdate().type = OFPT_PACKET_IN;
    packetIn->setReason(OFPR_NO_MATCH);
    packetIn->setChunkLength(B(32));
    Packet *pktIn = nullptr;

    if (sendCompletePacket || buffer.isfull()){
        // send full packet with packet-in message
//        packetIn->encapsulate(frame);
        packetIn->setBuffer_id(OFP_NO_BUFFER);
        pktFrame->insertAtFront(packetIn);
        pktIn = pktFrame;
    } else{
        // store packet in buffer and only send header fields
        auto etherHeader =  pktFrame->removeAtFront<EthernetMacHeader>();

        oxm_basic_match match = oxm_basic_match();
        //match.OFB_IN_PORT = frame->getArrivalGate()->getIndex();
        match.OFB_IN_PORT = pktFrame->getTag<InterfaceInd>()->getInterfaceId();

        match.OFB_ETH_SRC = etherHeader->getSrc();
        match.OFB_ETH_DST = etherHeader->getDest();
        match.OFB_ETH_TYPE = etherHeader->getTypeOrLength();
        //extract ARP specific match fields if present
        if(etherHeader->getTypeOrLength() == ETHERTYPE_ARP){
            //ARPPacket *arpPacket = check_and_cast<ARPPacket *>(frame->getEncapsulatedPacket());
            auto arpPacket = pktFrame->peekAtFront<ArpPacket>();
            match.OFB_ARP_OP = arpPacket->getOpcode();
            match.OFB_ARP_SHA = arpPacket->getSrcMacAddress();
            match.OFB_ARP_THA = arpPacket->getDestMacAddress();
            match.OFB_ARP_SPA = arpPacket->getSrcIpAddress();
            match.OFB_ARP_TPA = arpPacket->getDestIpAddress();
        }
        pktFrame->insertAtFront(etherHeader);
        packetIn->setMatch(match);
        packetIn->setBuffer_id(buffer.storeMessage(pktFrame));
        pktIn = new Packet("packetIn");
        pktIn->insertAtFront(packetIn);
    }
    socket.send(pktIn);
}


//void OF_Switch::handlePacketOutMessage(Open_Flow_Message *of_msg){
void OF_Switch::handlePacketOutMessage(Packet *pkt){
    //cast message
    //OFP_Packet_Out *packet_out_msg = (OFP_Packet_Out *) of_msg;
    auto packet_out_msg = pkt->removeAtFront<OFP_Packet_Out>();

    //return variables
    uint32_t bufferId = packet_out_msg->getBuffer_id();
    uint32_t inPort = packet_out_msg->getIn_port();
    unsigned int actions_size = packet_out_msg->getActionsArraySize();

    //get the frame
    //EthernetIIFrame *frame;
    Packet *frame = nullptr;
    if(bufferId != OFP_NO_BUFFER){
        frame = buffer.returnMessage(bufferId);
    } else {
        auto etherHeader = pkt->peekAtFront<EthernetMacHeader>();
        //frame = dynamic_cast<EthernetIIFrame *>(packet_out_msg->getEncapsulatedPacket());
        frame = pkt->dup();
    }
    //execute
    for (unsigned int i = 0; i < actions_size; ++i){
        executePacketOutAction(&(packet_out_msg->getActions(i)), frame, inPort);
    }
    delete frame;
    pkt->insertAtFront(packet_out_msg);
}


// packet encapsulated and not stored in buffer
//void OF_Switch::executePacketOutAction(ofp_action_header *action, EthernetIIFrame *frame, uint32_t inport){
void OF_Switch::executePacketOutAction(const ofp_action_header *action, Packet *pktFrame, uint32_t inport){
    const ofp_action_output *action_output = (const ofp_action_output *) action;
    uint32_t outport = action_output->port;
    //take(pktFrame);

    auto header = pktFrame->peekAtFront<EthernetMacHeader>();
    if(outport == OFPP_ANY){
           EV << "Dropping packet" << '\n';
    } else if (outport == OFPP_FLOOD){
        EV << "Flood Packet\n" << '\n';
        unsigned int n = gateSize("dataPlaneOut");
        for (unsigned int i=0; i<n; ++i) {
            if(i != inport && !(portVector[i].state & OFPPS_BLOCKED)){
                send(pktFrame->dup(), "dataPlaneOut", i);
            }
        }
    }else {
        auto indexPort = getIndexFromId(outport);
        if (indexPort == -1)
            throw cRuntimeError("Unknown dataPlaneOut sending port/gate %s",action_output->creationModule.c_str());
        EV << "Send Packet\n" << '\n';
        send(pktFrame->dup(), "dataPlaneOut", indexPort);
    }
    //delete pktFrame;
}


// invoked by Spanning Tree module disable ports for broadcast packets
void OF_Switch::disablePorts(vector<int> ports) {
    EV << "disablePorts method at " << this->getParentModule()->getFullPath() << '\n';

    for (unsigned int i = 0; i<ports.size(); ++i){
        portVector[ports[i]].state |= OFPPS_BLOCKED;
    }

    for(unsigned int i=0;i<portVector.size();++i){
        EV << "Port: " << i << " Value: " << portVector[i].state << '\n';
    }

    if(par("highlightActivePorts")){
        // Highlight links that belong to spanning tree
        for (unsigned int i = 0; i < portVector.size(); ++i){
            if (!(portVector[i].state & OFPPS_BLOCKED)){
                cGate *gateOut = getParentModule()->gate("gateDataPlane$o", i);
                do {
                    cDisplayString& connDispStrOut = gateOut->getDisplayString();
                    connDispStrOut.parse("ls=green,3,dashed");
                    gateOut = gateOut->getNextGate();
                } while (gateOut != nullptr && !gateOut->getOwnerModule()->getModuleType()->isSimple());

                cGate *gateIn = getParentModule()->gate("gateDataPlane$i", i);
                do {
                    cDisplayString& connDispStrIn = gateIn->getDisplayString();
                    connDispStrIn.parse("ls=green,3,dashed");
                    gateIn = gateIn->getPreviousGate();
                } while (gateIn != nullptr && !gateIn->getOwnerModule()->getModuleType()->isSimple());
            }
        }
    }

}


void OF_Switch::finish(){
    // record statistics
    recordScalar("packetsDataPlane", dataPlanePacket);
    recordScalar("packetsControlPlane", controlPlanePacket);
    recordScalar("flowTableHit", flowTableHit);
    recordScalar("flowTableMiss", flowTableMiss);
}

