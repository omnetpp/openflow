#include <omnetpp.h>
#include "openflow/hyperflow/HyperFlowSynchronizer.h"
#include "openflow/messages/HF_SyncRequest_m.h"
#include "openflow/messages/HF_ReportIn_m.h"
#include "openflow/messages/HF_SyncReply_m.h"
#include "inet/common/socket/SocketTag_m.h"

using namespace std;

Define_Module(HyperFlowSynchronizer);



HyperFlowSynchronizer::HyperFlowSynchronizer(){

}

HyperFlowSynchronizer::~HyperFlowSynchronizer(){
    for(auto&& msg : msgList) {
      delete msg;
    }
    msgList.clear();

    for(auto&& pair : socketMap){
        delete pair.second;
    }
    socketMap.clear();
}

void HyperFlowSynchronizer::initialize(int stage){

    //stats
    OperationalBase::initialize(stage);
    if (stage == INITSTAGE_LINK_LAYER) {
        queueSize = registerSignal("queueSize");
        waitingTime = registerSignal("waitingTime");
        // TCP socket; listen on incoming connections
        const char *address = par("address");
        int port = par("port");
        socket.setOutputGate(gate("socketOut"));
        //socket.setDataTransferMode(TCP_TRANSFER_OBJECT);
        socket.bind(address[0] ? L3Address(address) : L3Address(), port);
        dataChannelSizeCache =0;

        serviceTime = par("serviceTime");
        busy=false;
    }
    else if (stage == INITSTAGE_APPLICATION_LAYER) {
        socket.listen();
    }
}


void HyperFlowSynchronizer::handleMessageWhenUp(cMessage *msg){
    if(msg->isSelfMessage()){
        //This is message which has been scheduled due to service time
        //Get the Original message
        cMessage *data_msg = (cMessage *) msg->getContextPointer();
        emit(waitingTime,(simTime()-data_msg->getArrivalTime()-serviceTime));
        auto pkt = check_and_cast<Packet *>(data_msg);
        processQueuedMsg(pkt);

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
        auto recPacket = dynamic_cast<Packet *>(msg);
        if (recPacket == nullptr) {
            delete msg;
            return;
        }

        if (busy) {
            msgList.push_back(recPacket);
        }else{
            busy = true;
            cMessage *event = new cMessage("event");
            event->setContextPointer(recPacket);
            scheduleAt(simTime()+serviceTime, event);
        }
        emit(queueSize,msgList.size());
    }


}

void HyperFlowSynchronizer::handleChangeNotification(Packet * pkt){
    auto msg = pkt->peekAtFront<HF_ChangeNotification>();

    dataChannel.push_front(msg->getEntry());
    dataChannelSizeCache++;
}

void HyperFlowSynchronizer::handleSyncRequest(Packet *pkt){
    //return syncreply

    auto msg = pkt->peekAtFront<HF_SyncRequest>();

    TcpSocket *socket = findSocketFor(pkt);

    auto reply = makeShared<HF_SyncReply>();
    //HF_SyncReply * reply = new HF_SyncReply("SyncReply");
    auto pktReply = new Packet("SyncReply");

    //create control channel
    std::list<ControlChannelEntry> tempControlChannel = std::list<ControlChannelEntry>();
    SimTime lastValidTime = simTime()-par("aliveInterval");

    auto iterControl = controlChannel.begin();
    while(iterControl!=controlChannel.end()){
        if((*iterControl).time >= lastValidTime){
           tempControlChannel.push_back(*iterControl);
           ++iterControl;
        } else {
            iterControl = controlChannel.erase(iterControl);
        }
    }
    reply->getControlChannelForUpdate().insert(reply->getControlChannel().end(), tempControlChannel.begin(), tempControlChannel.end());

    //copy only the relevant parts of the datachannel
    std::list<DataChannelEntry> tempDataChannel = std::list<DataChannelEntry>();
    std::list<DataChannelEntry>::iterator iterData;
    int counter = dataChannelSizeCache - msg->getLastSyncCounter();
    for(iterData=dataChannel.begin();counter != 0 && iterData != dataChannel.end(); ++iterData){
        counter--;
        tempDataChannel.push_back(*iterData);
    }
    reply->setDataChannel(tempDataChannel);
    reply->setChunkLength(B(sizeof(controlChannel)+sizeof(tempDataChannel)));
    //reply->setByteLength(sizeof(controlChannel)+sizeof(tempDataChannel));
    pktReply->insertAtFront(reply);
    pktReply->setKind(TCP_C_SEND);
    socket->send(pktReply);
}


void HyperFlowSynchronizer::handleReportIn(Packet * pkt){
    //store to datachannel

    auto msg = pkt->peekAtFront<HF_ReportIn>();
    ControlChannelEntry entry = ControlChannelEntry();
    entry.switches= std::list<Switch_Info *>(msg->getSwitchInfoList());
    entry.controllerId = msg->getControllerId();
    entry.time = simTime();
    controlChannel.push_front(entry);
}


TcpSocket * HyperFlowSynchronizer::findSocketFor(cMessage *msg){

    auto pkt = check_and_cast<Packet *>(msg);
    auto tag = pkt->findTag<SocketInd>();
    if (tag == nullptr)
        throw cRuntimeError("TcpSocketMap: findSocketFor(): no SocketInd (not from TCP?)");
    int connId = tag->getSocketId();
    auto i = socketMap.find(connId);
    ASSERT(i==socketMap.end() || i->first==i->second->getSocketId());
    return (i==socketMap.end()) ? nullptr : i->second;
}

void HyperFlowSynchronizer::processQueuedMsg(Packet * msg){
    auto chunk = msg->peekAtFront<Chunk>();
    if (dynamicPtrCast<const HF_ReportIn>(chunk) != nullptr) {
        handleReportIn(msg);

    } else if(dynamicPtrCast<const HF_SyncRequest>(chunk) != nullptr){
        handleSyncRequest(msg);
    } else if(dynamicPtrCast<const HF_ChangeNotification>(chunk) != nullptr){
        handleChangeNotification(msg);
    } else {
        TcpSocket *socket = findSocketFor(msg);
        if(!socket){
            socket = new TcpSocket(msg);
            socket->setOutputGate(gate("socketOut"));
            ASSERT(socketMap.find(socket->getSocketId())==socketMap.end());
            socketMap[socket->getSocketId()] = socket;
        }
    }
}

