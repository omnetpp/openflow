#include "openflow/controllerApps/LLDPAgent.h"
#include <algorithm>
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"
#include "inet/linklayer/common/FcsMode_m.h"
#include "inet/common/ProtocolTag_m.h"
#include "inet/linklayer/ethernet/common/Ethernet.h"
#include "inet/protocolelement/fragmentation/tag/FragmentTag_m.h"

#define MSGKIND_TRIGGERLLDP 101
#define MSGKIND_LLDPAGENTBOOTED 201

Define_Module(LLDPAgent);

LLDPAgent::LLDPAgent(){

}

LLDPAgent::~LLDPAgent(){

}

void LLDPAgent::initialize(int stage){
    AbstractControllerApp::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        pollInterval = par("pollInterval");
        timeOut = par("timeOut");
        printMibGraph = par("printMibGraph");
        idleTimeout = par("flowModIdleTimeOut");
        hardTimeout = par("flowModHardTimeOut");
    }
}


void LLDPAgent::handleMessageWhenUp(cMessage *msg){
    if (msg->isSelfMessage()){
        if (msg->getKind()==MSGKIND_TRIGGERLLDP){
            sendLLDP();
            cMessage *triggerLLDP = new cMessage("triggerLLDP");
            triggerLLDP->setKind(MSGKIND_TRIGGERLLDP);
            scheduleAt(simTime()+pollInterval, triggerLLDP);
        }
    }
    delete msg;
}



void LLDPAgent::sendLLDP(){

    int j=0;
    //iterate over all switches controlled by the controller
    auto list = controller->getSwitchesList();
    for(auto i=list->begin(); i != list->end(); ++i) {
        if(strcmp((*i).getMacAddress().c_str(),"")==0){
            //only use full connections
            continue;
        }

        TcpSocket *socket = (*i).getSocket();
        //iterate over all ports
        for(j=0;j<(*i).getNumOfPorts();++j){

            auto lldpPacket = makeShared<LLDP>();

            lldpPacket->setPortID(j);
            lldpPacket->setChassisID((*i).getMacAddress().c_str());

            auto frame = new Packet("LLDP");
            frame->insertAtFront(lldpPacket);

            auto ethHeader = makeShared<EthernetMacHeader>();
            ethHeader->setSrc(MacAddress((*i).getMacAddress().c_str()));
            ethHeader->setDest(MacAddress("AA:80:c2:00:00:0e"));
            ethHeader->setTypeOrLength(0x88CC);

            frame->insertAtFront(ethHeader);
            const auto& ethernetFcs = makeShared<EthernetFcs>();
            frame->addTagIfAbsent<PacketProtocolTag>()->setProtocol(&Protocol::ethernetMac);

            //frame = eth2Frame;
            //frame->encapsulate(arpReply);
            ethernetFcs->setFcsMode(FCS_DECLARED_CORRECT);
            ethernetFcs->setFcs(0xC00DC00DL);

            B paddingLength = MIN_ETHERNET_FRAME_BYTES - ETHER_FCS_BYTES - B(frame->getByteLength());
            if (paddingLength > B(0)) {
                const auto& ethPadding = makeShared<EthernetPadding>();
                ethPadding->setChunkLength(paddingLength);
                frame->insertAtBack(ethPadding);
            }

            frame->insertAtBack(ethernetFcs);

//            EtherFrame *frame = NULL;
//            EthernetIIFrame *eth2Frame = new EthernetIIFrame(lldpPacket->getName());
//            eth2Frame->setSrc(MACAddress((*i).getMacAddress().c_str()));  // if blank, will be filled in by MAC
//            //eth2Frame->setDest(MACAddress("01:80:c2:00:00:0e"));
//            //make up an address as inet will accept multicast frames and does not know what to do with a lldp frame and thus fails
//            eth2Frame->setDest(MACAddress("AA:80:c2:00:00:0e"));
//            eth2Frame->setEtherType(0x88CC);
//            eth2Frame->setByteLength(ETHER_MAC_FRAME_BYTES);
//
//            frame = eth2Frame;
//            frame->encapsulate(lldpPacket);
//            if (frame->getByteLength() < MIN_ETHERNET_FRAME_BYTES)
//                frame->setByteLength(MIN_ETHERNET_FRAME_BYTES);  // "padding"
//            frame->addByteLength(PREAMBLE_BYTES+SFD_BYTES);


            //create packet out*/
            auto packetOut = makeShared<OFP_Packet_Out>();
            packetOut->getHeaderForUpdate().version = OFP_VERSION;
            packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
            packetOut->setBuffer_id(OFP_NO_BUFFER);
            packetOut->setChunkLength(B(24));

            packetOut->setIn_port(-1);
            ofp_action_output *action_output = new ofp_action_output();
            action_output->creationModule = dynamic_cast<cModule *>(this)->getClassAndFullName();
            action_output->port = (*i).getIdPort(j);
            packetOut->setActionsArraySize(1);
            packetOut->setActions(0, *action_output);
            frame->insertAtFront(packetOut);

            //send the packet
            controller->sendPacketOut(frame,socket);
        }
    }
}

//void LLDPAgent::handlePacketIn(OFP_Packet_In * packet_in_msg){
void LLDPAgent::handlePacketIn(Packet * packetIn){
    //check if it is a received lldp
    CommonHeaderFields headerFields = extractCommonHeaderFields(packetIn);


    //check if it is an lldp packet
    if(headerFields.eth_type == 0x88CC){
        auto& fragmentTag = packetIn->getTag<FragmentTag>();
        //EthernetIIFrame *frame =  dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket());
        //check if we have received the entire frame, if not the flow mods have not been sent yet
        if(fragmentTag->getLastFragment()){
            auto packet_in_msg = packetIn->removeAtFront<OFP_Packet_In>();
            auto header = packetIn->removeAtFront<EthernetMacHeader>();
            auto lldp = packetIn->peekAtFront<LLDP>();
            mibGraph.addEntry(lldp->getChassisID(),lldp->getPortID(),headerFields.swInfo->getMacAddress(),headerFields.inport,timeOut);
            if(printMibGraph){
                EV << mibGraph.getStringGraph() << '\n';
            }
            packetIn->insertAtFront(header);
            packetIn->insertAtFront(packet_in_msg);
        }
        else {
            //resend flow mod
            triggerFlowMod(headerFields.swInfo);
        }

    }
    else {
        //this could be a packet originating from an end device, check if the port is associated with an lldp entry
        mibGraph.addEntry(headerFields.src_mac.str(),-1,headerFields.swInfo->getMacAddress(),headerFields.inport,timeOut);
        if(printMibGraph){
            EV << mibGraph.getStringGraph() << '\n';
        }
    }

}

void LLDPAgent::triggerFlowMod(Switch_Info * swInfo) {
    uint32_t outport = OFPP_CONTROLLER;
    oxm_basic_match match = oxm_basic_match();
    match.OFB_ETH_TYPE = 0x88CC;
    match.wildcards= 0;
    match.wildcards |= OFPFW_IN_PORT;
    match.wildcards |=  OFPFW_DL_SRC;
    match.wildcards |=  OFPFW_DL_DST;

    sendFlowModMessage(OFPFC_ADD, match, outport, swInfo->getSocket(),idleTimeout,hardTimeout);
}

void LLDPAgent::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    AbstractControllerApp::receiveSignal(src,id,obj,details);

    Enter_Method("LLDPAgent::receiveSignal %s", cComponent::getSignalName(id));
    if(id == PacketInSignalId){
        auto pkt = dynamic_cast<Packet *>(obj);
        if (pkt == nullptr)
            return;

        EV << "LLDPAgent::PacketIn" << endl;
        auto chunk = pkt->peekAtFront<Chunk>();
        auto packet_in_msg = dynamicPtrCast<const OFP_Packet_In>(chunk);
        if (packet_in_msg != nullptr)
            handlePacketIn(pkt);
    } else if(id == BootedSignalId){
        //schedule first lldp messages to be sent
        cMessage *triggerLLDP = new cMessage("triggerLLDP");
        triggerLLDP->setKind(MSGKIND_TRIGGERLLDP);
        scheduleAt(simTime()+pollInterval, triggerLLDP);
    }else if(id == PacketFeatureReplySignalId){
        auto pkt = dynamic_cast<Packet *>(obj);
        if (pkt == nullptr)
            return;
        auto chunk = pkt->peekAtFront<Chunk>();
        auto castMsg = dynamicPtrCast<const OFP_Features_Reply>(chunk);
        //a new switch is available schedule flow mod and trigger lldp creation
        if(castMsg != nullptr){
            Switch_Info * swInfo = controller->findSwitchInfoFor(pkt);
            triggerFlowMod(swInfo);
        }
    }
}

LLDPMibGraph * LLDPAgent::getMibGraph(){
    return &mibGraph;
}

