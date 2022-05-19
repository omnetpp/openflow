#include "openflow/hyperflow/HF_LLDPAgent.h"
#include <algorithm>
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"
#include "inet/protocolelement/fragmentation/tag/FragmentTag_m.h"

#define MSGKIND_TRIGGERLLDP 101
#define MSGKIND_LLDPAGENTBOOTED 201

simsignal_t HF_LLDPAgent::HyperFlowReFireSignalId = registerSignal("HyperFlowReFire");

Define_Module(HF_LLDPAgent);

HF_LLDPAgent::HF_LLDPAgent(){

}

HF_LLDPAgent::~HF_LLDPAgent(){

}

void HF_LLDPAgent::initialize(int stage){
    LLDPAgent::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
    //register signals
       getParentModule()->subscribe("HyperFlowReFire",this);
    }
}






//void HF_LLDPAgent::handlePacketIn(OFP_Packet_In * packet_in_msg){
void HF_LLDPAgent::handlePacketIn(Packet *pktIn){
    //OFP_Packet_In * packet_in_msg
    CommonHeaderFields headerFields = extractCommonHeaderFields(pktIn);

    //check if it is an lldp packet
    if(headerFields.eth_type == 0x88CC){

        auto& fragmentTag = pktIn->getTag<FragmentTag>();

        //check if we have received the entire frame, if not the flow mods have not been sent yet
        if(fragmentTag->getLastFragment()){
            auto packet_in_msg = pktIn->removeAtFront<OFP_Packet_In>();
            auto frame = pktIn->removeAtFront<EthernetMacHeader>();
            auto lldp = pktIn->peekAtFront<LLDP>();
            mibGraph.addEntry(lldp->getChassisID(),lldp->getPortID(),headerFields.swInfo->getMacAddress(),headerFields.inport,timeOut);
            if(printMibGraph){
                EV << mibGraph.getStringGraph() << endl;
            }

            //inform hyperflow
            LLDP_Wrapper *wrapper = new LLDP_Wrapper();
            wrapper->setDstId(headerFields.swInfo->getMacAddress());
            wrapper->setDstPort(headerFields.inport);
            wrapper->setSrcId(lldp->getChassisID());
            wrapper->setSrcPort(lldp->getPortID());

            DataChannelEntry entry = DataChannelEntry();
            entry.eventId = 0;
            entry.trgSwitch = "";
            entry.srcController = controller->getFullPath();
            entry.payload = wrapper;

            if (hfAgent == nullptr)
                throw cRuntimeError("HyperFlowAgent not synchronized");

            hfAgent->synchronizeDataChannelEntry(entry);
            pktIn->insertAtFront(frame);
            pktIn->insertAtFront(packet_in_msg);

        } else {
            //resend flow mod
            triggerFlowMod(headerFields.swInfo);
        }


     } else {
         //this could be a packet originating from an end device, check if the port is associated with an lldp entry
         if(mibGraph.addEntry(headerFields.src_mac.str(),-1,headerFields.swInfo->getMacAddress(),headerFields.inport,timeOut)){
             if(printMibGraph){
                 EV << mibGraph.getStringGraph() << endl;
             }

             //inform hyperflow
             LLDP_Wrapper *wrapper = new LLDP_Wrapper();
             wrapper->setDstId(headerFields.swInfo->getMacAddress());
             wrapper->setDstPort(headerFields.inport);
             wrapper->setSrcId(headerFields.src_mac.str());
             wrapper->setSrcPort(-1);

             DataChannelEntry entry = DataChannelEntry();
             entry.eventId = 0;
             entry.trgSwitch = "";
             entry.srcController = controller->getFullPath();
             entry.payload = wrapper;
             if (hfAgent == nullptr) {
                 throw cRuntimeError("HyperFlowAgent not synchronized, check if the agent is present in the network");
             }
             hfAgent->synchronizeDataChannelEntry(entry);
         }
     }




}

bool HF_LLDPAgent::searchHyperFlowAggent()
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


void HF_LLDPAgent::receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) {
    //set hfagent link
    LLDPAgent::receiveSignal(src,id,obj,details);
    Enter_Method("HF_LLDPAgent::receiveSignal %s", cComponent::getSignalName(id));

    if (!searchHyperFlowAggent())
        throw cRuntimeError("HyperFlowAgent not synchronized, check if the agent is present in the network");

    //check for hf messages to refire
    if(id == HyperFlowReFireSignalId){
        if(dynamic_cast<HF_ReFire_Wrapper *>(obj) != NULL) {
            HF_ReFire_Wrapper *hfRefire = (HF_ReFire_Wrapper *) obj;
            if(strcmp(hfRefire->getDataChannelEntry().trgSwitch.c_str(),"") == 0){
                if (dynamic_cast<LLDP_Wrapper *>(hfRefire->getDataChannelEntry().payload) != NULL) {
                    LLDP_Wrapper *wrapper = (LLDP_Wrapper *) hfRefire->getDataChannelEntry().payload;
                    mibGraph.addEntry(wrapper->getSrcId(),wrapper->getSrcPort(),wrapper->getDstId(),wrapper->getDstPort(),timeOut);
                    if(printMibGraph){
                        EV << mibGraph.getStringGraph() << endl;
                    }
                }
            }
        }
    }

}


