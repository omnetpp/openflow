#include "openflow/controllerApps/LLDPAgent.h"
#include <algorithm>


#define MSGKIND_TRIGGERLLDP 101
#define MSGKIND_LLDPAGENTBOOTED 201

Define_Module(LLDPAgent);

LLDPAgent::LLDPAgent(){

}

LLDPAgent::~LLDPAgent(){

}

void LLDPAgent::initialize(){
    AbstractControllerApp::initialize();
    pollInterval = par("pollInterval");
    timeOut = par("timeOut");
    printMibGraph = par("printMibGraph");

    idleTimeout = par("flowModIdleTimeOut");
    hardTimeout = par("flowModHardTimeOut");

}


void LLDPAgent::handleMessage(cMessage *msg){
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

        TCPSocket *socket = (*i).getSocket();
        //iterate over all ports
        for(j=0;j<(*i).getNumOfPorts();++j){
            LLDP *lldpPacket = new LLDP("LLDP");
            lldpPacket->setPortID(j);
            lldpPacket->setChassisID((*i).getMacAddress().c_str());

            EtherFrame *frame = NULL;
            EthernetIIFrame *eth2Frame = new EthernetIIFrame(lldpPacket->getName());
            eth2Frame->setSrc(MACAddress((*i).getMacAddress().c_str()));  // if blank, will be filled in by MAC
            //eth2Frame->setDest(MACAddress("01:80:c2:00:00:0e"));
            //make up an address as inet will accept multicast frames and does not know what to do with a lldp frame and thus fails
            eth2Frame->setDest(MACAddress("AA:80:c2:00:00:0e"));
            eth2Frame->setEtherType(0x88CC);
            eth2Frame->setByteLength(ETHER_MAC_FRAME_BYTES);

            frame = eth2Frame;
            frame->encapsulate(lldpPacket);
            if (frame->getByteLength() < MIN_ETHERNET_FRAME_BYTES)
                frame->setByteLength(MIN_ETHERNET_FRAME_BYTES);  // "padding"
            frame->addByteLength(PREAMBLE_BYTES+SFD_BYTES);


            //create packet out*/
            OFP_Packet_Out *packetOut = new OFP_Packet_Out("packetOut");
            packetOut->getHeaderForUpdate().version = OFP_VERSION;
            packetOut->getHeaderForUpdate().type = OFPT_PACKET_OUT;
            packetOut->setBuffer_id(OFP_NO_BUFFER);
            packetOut->setByteLength(24);
            packetOut->encapsulate(frame);
            packetOut->setIn_port(-1);
            ofp_action_output *action_output = new ofp_action_output();
            action_output->port = j;
            packetOut->setActionsArraySize(1);
            packetOut->setActions(0, *action_output);

            //send the packet
            controller->sendPacketOut(packetOut,socket);
        }
    }
}

void LLDPAgent::handlePacketIn(OFP_Packet_In * packet_in_msg){
    //check if it is a received lldp
    CommonHeaderFields headerFields = extractCommonHeaderFields(packet_in_msg);

    //check if it is an lldp packet
    if(headerFields.eth_type == 0x88CC){
        EthernetIIFrame *frame =  dynamic_cast<EthernetIIFrame *>(packet_in_msg->getEncapsulatedPacket());
        //check if we have received the entire frame, if not the flow mods have not been sent yet
        if(frame != NULL){
            LLDP *lldp = (LLDP *) frame->getEncapsulatedPacket();
            mibGraph.addEntry(lldp->getChassisID(),lldp->getPortID(),headerFields.swInfo->getMacAddress(),headerFields.inport,timeOut);
            if(printMibGraph){
                EV << mibGraph.getStringGraph() << '\n';
            }

        } else {
            //resend flow mod
            triggerFlowMod(headerFields.swInfo);
        }

     } else {
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

    if(id == PacketInSignalId){
        EV << "LLDPAgent::PacketIn" << endl;
        if (dynamic_cast<OFP_Packet_In *>(obj) != NULL) {
            OFP_Packet_In *packet_in_msg = (OFP_Packet_In *) obj;
            handlePacketIn(packet_in_msg);
        }
    } else if(id == BootedSignalId){
        //schedule first lldp messages to be sent
        Enter_Method_Silent();
        cMessage *triggerLLDP = new cMessage("triggerLLDP");
        triggerLLDP->setKind(MSGKIND_TRIGGERLLDP);
        scheduleAt(simTime()+pollInterval, triggerLLDP);
    }else if(id == PacketFeatureReplySignalId){
        //a new switch is available schedule flow mod and trigger lldp creation
        if(dynamic_cast<OFP_Features_Reply *>(obj) != NULL){
            OFP_Features_Reply * castMsg = (OFP_Features_Reply *)obj;
            Switch_Info * swInfo = controller->findSwitchInfoFor(castMsg);
            triggerFlowMod(swInfo);
        }
    }
}

LLDPMibGraph * LLDPAgent::getMibGraph(){
    return &mibGraph;
}

