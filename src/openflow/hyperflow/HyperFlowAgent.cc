#include "openflow/hyperflow/HyperFlowAgent.h"
#include "inet/networklayer/common/L3AddressResolver.h"
#include "openflow/openflow/controller/Switch_Info.h"
#include "algorithm"
#include "string"

#define MSGKIND_REPORTINEVERY 701
#define MSGKIND_SYNCEVERY 702
#define MSGKIND_CHECKALIVEEVERY 703
#define MSGKIND_HFCONNECT 704

Define_Module(HyperFlowAgent);

HyperFlowAgent::HyperFlowAgent(){

}

HyperFlowAgent::~HyperFlowAgent(){

}

void HyperFlowAgent::initialize(int stage){
    AbstractTCPControllerApp::initialize(stage);

    //init counters
    if (stage == INITSTAGE_LOCAL) {
        waitingForSyncResponse = false;
        lastSyncCounter =0;

        checkSyncEvery = par("checkSyncEvery");
        checkAliveEvery = par("checkAliveEvery");
        checkReportInEvery = par("reportInEvery");
        //init socket to synchronizer
        const char *localAddress = par("localAddress");
        int localPort = par("localPort");
        socket.bind(localAddress[0] ? L3Address(localAddress) : L3Address(), localPort);
        socket.setOutputGate(gate("socketOut"));
        //socket.setDataTransferMode(TCP_TRANSFER_OBJECT);
        //schedule connection setup

        //register signals
        HyperFlowReFireSignalId =registerSignal("HyperFlowReFire");
    }
}

void HyperFlowAgent::handleStartOperation(LifecycleOperation *operation)
{
    simtime_t connectAt = par("connectAt");
    simtime_t start = std::max(simTime(), connectAt);
    cMessage *initiateConnection = new cMessage("initiateConnection");
    initiateConnection->setKind(MSGKIND_HFCONNECT);
    scheduleAt(start, initiateConnection);
}

void HyperFlowAgent::handleMessageWhenUp(cMessage *msg){
    AbstractTCPControllerApp::handleMessage(msg);

    if (msg->isSelfMessage()){
        if (msg->getKind()==MSGKIND_REPORTINEVERY){
            cMessage *reportIn = new cMessage("reportIn");
            reportIn->setKind(MSGKIND_REPORTINEVERY);
            scheduleAt(simTime()+checkReportInEvery, reportIn);
            sendReportIn();
            delete msg;
        } else if (msg->getKind()== MSGKIND_SYNCEVERY){
            cMessage *sync = new cMessage("sync");
            sync->setKind(MSGKIND_SYNCEVERY);
            scheduleAt(simTime()+checkSyncEvery, sync);
            sendSyncRequest();
            delete msg;
        } else if (msg->getKind()== MSGKIND_CHECKALIVEEVERY){
            //start checking alive
            cMessage *checkAlive = new cMessage("checkAlive");
            checkAlive->setKind(MSGKIND_CHECKALIVEEVERY);
            scheduleAt(simTime()+checkAliveEvery, checkAlive);
            handleCheckAlive();
            delete msg;
        } else if (msg->getKind()== MSGKIND_HFCONNECT){
            //init socket to synchronizer
            const char *connectAddressHyperFlowSynchronizer = par("connectAddressHyperFlowSynchronizer");
            int connectPort = par("connectPortHyperFlowSynchronizer");
            socket.connect(L3AddressResolver().resolve(connectAddressHyperFlowSynchronizer), connectPort);
        }
    }


}


void HyperFlowAgent::processQueuedMsg(Packet *msg){
    //check if message was received via our socket
    if(socket.belongsToSocket(msg)){
        if(msg->getKind() == TCP_I_ESTABLISHED){
            socket.processMessage(msg);

            //start sending ReportIn Messages
            cMessage *reportInEvery = new cMessage("reportIn");
            reportInEvery->setKind(MSGKIND_REPORTINEVERY);
            scheduleAt(simTime()+par("reportInEvery"), reportInEvery);

            //start sending sync requests
            cMessage *sync = new cMessage("sync");
            sync->setKind(MSGKIND_SYNCEVERY);
            scheduleAt(simTime()+par("checkSyncEvery"), sync);

            //start checking alive
            cMessage *checkAlive = new cMessage("checkAlive");
            checkAlive->setKind(MSGKIND_CHECKALIVEEVERY);
            scheduleAt(simTime()+par("checkAliveEvery"), checkAlive);
        } else {
            if (dynamic_cast<HF_SyncReply *>(msg) != NULL) {
                HF_SyncReply *castMsg = (HF_SyncReply *)msg;
                handleSyncReply(castMsg);
            }
            delete msg;
        }
    } else {
        delete msg;
    }

}


void HyperFlowAgent::sendReportIn(){

    //HF_ReportIn * reportIn = new HF_ReportIn("ReportIn");
    auto reportIn = makeShared<HF_ReportIn>();

    reportIn->setControllerId(controller->getFullPath().c_str());

    //copy switches list
    auto tempList = controller->getSwitchesList();
    for(auto iterSw=tempList->begin();iterSw!=tempList->end();++iterSw){
        reportIn->getSwitchInfoListForUpdate().push_front(&(*iterSw));
    }

    reportIn->setChunkLength(B(1+sizeof(reportIn->getSwitchInfoList())));
    auto pktReport = new Packet("ReportIn");
    pktReport->setKind(TCP_C_SEND);
    pktReport->insertAtFront(reportIn);

    socket.send(pktReport);
}


void HyperFlowAgent::sendSyncRequest(){
    if(!waitingForSyncResponse){
        waitingForSyncResponse = true;
        //HF_SyncRequest * syncRequest = new HF_SyncRequest("SyncRequest");
        auto syncRequest = makeShared<HF_SyncRequest>();
        syncRequest->setChunkLength(B(1));
        auto pktSyncReq = new Packet("SyncRequest");
        pktSyncReq->setKind(TCP_C_SEND);
        syncRequest->setLastSyncCounter(lastSyncCounter);
        pktSyncReq->insertAtFront(syncRequest);
        socket.send(pktSyncReq);
    }
}

void HyperFlowAgent::handleSyncReply(HF_SyncReply * msg){
    waitingForSyncResponse = false;

    //update control channel
    controlChannel=std::list<ControlChannelEntry>(msg->getControlChannel());

    //update known hosts
    std::list<ControlChannelEntry>::iterator iterControl;
    std::list<std::string>::iterator iterTemp;
    for(iterControl=controlChannel.begin();iterControl!=controlChannel.end();iterControl++){
        iterTemp = std::find(knownControllers.begin(), knownControllers.end(), (*iterControl).controllerId);
        if(iterTemp == knownControllers.end()){
            knownControllers.push_front((*iterControl).controllerId);
        }

        //check if a failed controller has become alive
        iterTemp = std::find(failedControllers.begin(), failedControllers.end(), (*iterControl).controllerId);
        if(iterTemp != failedControllers.end()){
            handleRecover((*iterControl).controllerId);
        }
    }

    //update data channel
    std::list<DataChannelEntry>::reverse_iterator iterData;

    std::list<DataChannelEntry> tempList = msg->getDataChannel();

    for(iterData=tempList.rbegin();iterData!=tempList.rend();++iterData){
        dataChannel.push_front((*iterData));
        lastSyncCounter++;
        //check if we have to refire
        if(strcmp((*iterData).srcController.c_str(),controller->getFullPath().c_str())!=0){
            HF_ReFire_Wrapper * rfWrapper = new HF_ReFire_Wrapper();
            rfWrapper->setDataChannelEntry(*iterData);
            emit(HyperFlowReFireSignalId,rfWrapper);
            delete rfWrapper;
        }
    }

}


void HyperFlowAgent::handleCheckAlive(){
    //check if all known controllers have reported in
    std::list<std::string>::iterator iterKnownControllers;
    std::list<ControlChannelEntry>::iterator iterControl;
    bool found = false;
    for(iterKnownControllers=knownControllers.begin();iterKnownControllers!=knownControllers.end();iterKnownControllers++){
        found = false;
        for(iterControl=controlChannel.begin();iterControl!=controlChannel.end();iterControl++){
            if(strcmp(iterKnownControllers->c_str(),(*iterControl).controllerId.c_str()) == 0){
                found=true;
                break;
            }
        }
        if(!found){
            handleFailure(*iterKnownControllers);
        }
    }
}

void HyperFlowAgent::synchronizeDataChannelEntry(DataChannelEntry entry){
    EV << "HyperFlowAgent::Sent Change" << endl;
    Enter_Method_Silent();

    auto change = makeShared<HF_ChangeNotification>();
    change->setChunkLength(B(sizeof(entry)));
    change->setEntry(entry);

    auto pktChange = new Packet("HF_Change");
    pktChange->setKind(TCP_C_SEND);
    pktChange->insertAtFront(change);
    socket.send(pktChange);
}

void HyperFlowAgent::handleRecover(std::string controllerId){
    //TODO
}

void HyperFlowAgent::handleFailure(std::string controllerId){
    //TODO
}

