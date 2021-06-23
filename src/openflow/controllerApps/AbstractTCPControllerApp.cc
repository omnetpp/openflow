#include "openflow/controllerApps/AbstractTCPControllerApp.h"
#include "inet/common/socket/SocketTag_m.h"

#define MSGKIND_TCPSERVICETIME                 3098

Define_Module(AbstractTCPControllerApp);

using namespace std;

AbstractTCPControllerApp::AbstractTCPControllerApp()
{

}

AbstractTCPControllerApp::~AbstractTCPControllerApp()
{

}


void AbstractTCPControllerApp::initialize(int stage){
    AbstractControllerApp::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        busy = false;
        serviceTime =par("serviceTime");
        queueSize = registerSignal("queueSize");
        waitingTime = registerSignal("waitingTime");
        lastQueueSize =0;
        lastChangeTime=0.0;
    }

}

void AbstractTCPControllerApp::handleMessageWhenUp(cMessage *msg){
    if (msg->isSelfMessage()){
        if(msg->getKind()==MSGKIND_TCPSERVICETIME){
            //This is message which has been scheduled due to service time
            //Get the Original message
            auto data_msg = dynamic_cast<Packet *>((cObject *)msg->getContextPointer());
            if (data_msg == nullptr)
                throw cRuntimeError("AbstractTCPControllerApp::handleMessage not of type Packet");
            emit(waitingTime,(simTime()-data_msg->getArrivalTime()-serviceTime));
            processQueuedMsg(data_msg);
            //Trigger next service time
            if (msgList.empty()){
                busy = false;
            } else {
                auto msgFromList = msgList.front();
                msgList.pop_front();
                cMessage *event = new cMessage("event");
                event->setKind(MSGKIND_TCPSERVICETIME);
                event->setContextPointer(msgFromList);
                scheduleAt(simTime()+serviceTime, event);
            }
            calcAvgQueueSize(msgList.size());

            //delete the msg for efficiency
            delete msg;
        }


    } else {
        //imlement service time
        auto data_msg = dynamic_cast<Packet *>(msg);
        if (data_msg == nullptr)
            throw cRuntimeError("AbstractTCPControllerApp::handleMessage not of type Packet");
        if (busy) {
            msgList.push_back(data_msg);
        } else {
            busy = true;
            cMessage *event = new cMessage("event");
            event->setKind(MSGKIND_TCPSERVICETIME);
            event->setContextPointer(msg);
            scheduleAt(simTime()+serviceTime, event);
        }
        emit(queueSize,msgList.size());
        if(packetsPerSecond.count(floor(simTime().dbl())) <=0){
            packetsPerSecond.insert(pair<int,int>(floor(simTime().dbl()),1));
        } else {
            packetsPerSecond[floor(simTime().dbl())]++;
        }
        calcAvgQueueSize(msgList.size());
    }
}

TcpSocket * AbstractTCPControllerApp::findSocketFor(Packet *pkt) {

    auto tag = pkt->findTag<SocketInd>();
    if (tag == nullptr)
        throw cRuntimeError("SocketMap: findSocketFor(): no SocketInd (not from TCP?)");

    //TCPCommand *ind = dynamic_cast<TCPCommand *>(msg->getControlInfo());
    //if (!ind)
    //    throw cRuntimeError("SocketMap: findSocketFor(): no TCPCommand control info in message (not from TCP?)");
    auto i = socketMap.find(tag->getSocketId());
    ASSERT(i==socketMap.end() || i->first==i->second->getSocketId());
    return (i==socketMap.end()) ? nullptr : i->second;
}

void AbstractTCPControllerApp::calcAvgQueueSize(int size){
    if(lastQueueSize != size){
        double timeDiff = simTime().dbl() - lastChangeTime;
        if(avgQueueSize.count(floor(simTime().dbl())) <=0){
            avgQueueSize.insert(pair<int,double>(floor(simTime().dbl()),lastQueueSize*timeDiff));
        } else {
            avgQueueSize[floor(simTime().dbl())] += lastQueueSize*timeDiff;
        }
            lastChangeTime = simTime().dbl();
            lastQueueSize = size;
        }
}

void AbstractTCPControllerApp::finish(){
    // record statistics

    std::map<int,int>::iterator iterMap;
    for(iterMap = packetsPerSecond.begin(); iterMap != packetsPerSecond.end(); iterMap++){
        stringstream name;
        name << "packetsPerSecondAt-" << iterMap->first;
        recordScalar(name.str().c_str(),iterMap->second);
    }

    std::map<int,double>::iterator iterMap2;
    for(iterMap2 = avgQueueSize.begin(); iterMap2 != avgQueueSize.end(); iterMap2++){
        stringstream name;
        name << "avgQueueSizeAt-" << iterMap2->first;
        recordScalar(name.str().c_str(),(iterMap2->second/1.0));
    }
}
