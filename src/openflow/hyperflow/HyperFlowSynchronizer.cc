#include <omnetpp.h>
#include "openflow/hyperflow/HyperFlowSynchronizer.h"
#include "openflow/messages/HF_SyncRequest_m.h"
#include "openflow/messages/HF_ReportIn_m.h"
#include "openflow/messages/HF_SyncReply_m.h"

using namespace std;

Define_Module(HyperFlowSynchronizer);



HyperFlowSynchronizer::HyperFlowSynchronizer(){

}

HyperFlowSynchronizer::~HyperFlowSynchronizer(){

}

void HyperFlowSynchronizer::initialize(){

    //stats
    queueSize = registerSignal("queueSize");
    waitingTime = registerSignal("waitingTime");

    // TCP socket; listen on incoming connections
    const char *address = par("address");
    int port = par("port");
    socket.setOutputGate(gate("tcpOut"));
    socket.setDataTransferMode(TCP_TRANSFER_OBJECT);
    socket.bind(address[0] ? L3Address(address) : L3Address(), port);
    socket.listen();

    dataChannelSizeCache =0;

    serviceTime = par("serviceTime");
    busy=false;
}


void HyperFlowSynchronizer::handleMessage(cMessage *msg){
    if(msg->isSelfMessage()){
        //This is message which has been scheduled due to service time
        //Get the Original message
        cMessage *data_msg = (cMessage *) msg->getContextPointer();
        emit(waitingTime,(simTime()-data_msg->getArrivalTime()-serviceTime));
        processQueuedMsg(data_msg);

        //delete the processed msg
        delete data_msg;

        //Trigger next service time
        if (msgList.empty()){
            busy = false;
        } else {
            cMessage *msgfromlist = msgList.front();
            msgList.pop_front();
            cMessage *event = new cMessage("event");
            event->setContextPointer(msgfromlist);
            scheduleAt(simTime()+serviceTime, event);
        }

        //delete the msg for efficiency
        delete msg;
    } else {
        //imlement service time
        if (busy) {
            msgList.push_back(msg);
        }else{
            busy = true;
            cMessage *event = new cMessage("event");
            event->setContextPointer(msg);
            scheduleAt(simTime()+serviceTime, event);
        }
        emit(queueSize,msgList.size());
    }


}

void HyperFlowSynchronizer::handleChangeNotification(HF_ChangeNotification * msg){
    dataChannel.push_front(msg->getEntry());
    dataChannelSizeCache++;
}

void HyperFlowSynchronizer::handleSyncRequest(HF_SyncRequest * msg){
    //return syncreply
    TCPSocket *socket = findSocketFor(msg);

    HF_SyncReply * reply = new HF_SyncReply("SyncReply");

    //create control channel
    std::list<ControlChannelEntry> tempControlChannel = std::list<ControlChannelEntry>();
    std::list<ControlChannelEntry>::iterator iterControl;
    SimTime lastValidTime = simTime()-par("aliveInterval");
    for(iterControl=controlChannel.begin();iterControl!=controlChannel.end();iterControl++){
        if((*iterControl).time >= lastValidTime){
           tempControlChannel.push_back(*iterControl);
        } else {
            controlChannel.erase(iterControl);
            iterControl--;
        }
    }
    reply->getControlChannelForUpdate().insert(reply->getControlChannel().end(), tempControlChannel.begin(), tempControlChannel.end());

    //copy only the relevant parts of the datachannel
    std::list<DataChannelEntry> tempDataChannel = std::list<DataChannelEntry>();
    std::list<DataChannelEntry>::iterator iterData;
    int counter = dataChannelSizeCache - msg->getLastSyncCounter();
    for(iterData=dataChannel.begin();counter != 0 && iterData != dataChannel.end();iterData++){
        counter--;
        tempDataChannel.push_back(*iterData);
    }
    reply->setDataChannel(tempDataChannel);


    reply->setByteLength(sizeof(controlChannel)+sizeof(tempDataChannel));
    reply->setKind(TCP_C_SEND);
    socket->send(reply);
}


void HyperFlowSynchronizer::handleReportIn(HF_ReportIn * msg){
    //store to datachannel
    ControlChannelEntry entry = ControlChannelEntry();
    entry.switches= std::list<Switch_Info *>(msg->getSwitchInfoList());
    entry.controllerId = msg->getControllerId();
    entry.time = simTime();

    controlChannel.push_front(entry);
}


TCPSocket * HyperFlowSynchronizer::findSocketFor(cMessage *msg){
    TCPCommand *ind = dynamic_cast<TCPCommand *>(msg->getControlInfo());
    if (!ind)
        throw cRuntimeError("TCPSocketMap: findSocketFor(): no TCPCommand control info in message (not from TCP?)");
    int connId = ind->getConnId();
    std::map<int,TCPSocket*>::iterator i = socketMap.find(connId);
    ASSERT(i==socketMap.end() || i->first==i->second->getConnectionId());
    return (i==socketMap.end()) ? NULL : i->second;
}

void HyperFlowSynchronizer::processQueuedMsg(cMessage * msg){
    if (dynamic_cast<HF_ReportIn *>(msg) != NULL) {
        HF_ReportIn *castMsg = (HF_ReportIn *) msg;
        handleReportIn(castMsg);

    } else if(dynamic_cast<HF_SyncRequest *>(msg) != NULL){
        HF_SyncRequest *castMsg = (HF_SyncRequest *) msg;
        handleSyncRequest(castMsg);

    } else if(dynamic_cast<HF_ChangeNotification *>(msg) != NULL){
        HF_ChangeNotification *castMsg = (HF_ChangeNotification *) msg;
        handleChangeNotification(castMsg);

    } else {
        TCPSocket *socket = findSocketFor(msg);
        if(!socket){
            socket = new TCPSocket(msg);
            socket->setOutputGate(gate("tcpOut"));
            ASSERT(socketMap.find(socket->getConnectionId())==socketMap.end());
            socketMap[socket->getConnectionId()] = socket;
        }
    }
}

