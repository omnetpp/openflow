#include "openflow/kandoo/KandooAgent.h"
#include "inet/networklayer/common/L3AddressResolver.h"
#include "openflow/openflow/controller/Switch_Info.h"
#include "algorithm"
#include "string"

#define MSGKIND_KNCONNECT 1404

Define_Module(KandooAgent);

KandooAgent::KandooAgent(){

}

KandooAgent::~KandooAgent(){

}

void KandooAgent::initialize(int stage){
    AbstractTCPControllerApp::initialize(stage);

    if (stage == INITSTAGE_LOCAL) {
        //init socket to synchronizer
        isRootController = par("isRootController");
        //register signals
        kandooEventSignalId =registerSignal("KandooEvent");
    }
    else if (stage == INITSTAGE_APPLICATION_LAYER) {
        const char *localAddress = par("localAddress");
        int localPort = par("localPort");

        if(isRootController){
            socket.setOutputGate(gate("socketOut"));
            // socket.setDataTransferMode(TCP_TRANSFER_OBJECT);
            socket.bind(localAddress[0] ? L3Address(localAddress) : L3Address(), par("connectPortRootController"));
            socket.listen();
        } else {
            socket.bind(localAddress[0] ? L3Address(localAddress) : L3Address(), localPort);
            socket.setOutputGate(gate("socketOut"));
            //socket.setDataTransferMode(TCP_TRANSFER_OBJECT);


        }
    }
}

void KandooAgent::handleStartOperation(LifecycleOperation *operation) {
    cMessage *initiateConnection = new cMessage("initiateConnection");
    initiateConnection->setKind(MSGKIND_KNCONNECT);
    simtime_t connectAt = par("connectAt");
    simtime_t start = std::max(simTime(), connectAt);
    scheduleAt(start, initiateConnection);
}


void KandooAgent::handleMessageWhenUp(cMessage *msg){
    AbstractTCPControllerApp::handleMessage(msg);

    if (msg->isSelfMessage()){
        if (msg->getKind()== MSGKIND_KNCONNECT){
            //init socket to synchronizer
            const char *connectAddressRootController = par("connectAddressRootController");
            int connectPort = par("connectPortRootController");
            socket.connect(L3AddressResolver().resolve(connectAddressRootController), connectPort);
            delete msg;
        }
    }

}



void KandooAgent::processQueuedMsg(Packet *msg){

    if(isRootController){
        auto chunk = msg->peekAtFront<Chunk>();
        if(dynamicPtrCast<const KN_Packet>(chunk) != nullptr){
            auto castMsg = dynamicPtrCast<const KN_Packet>(chunk);
            bool found = false;
            std::list<SwitchControllerMapping>::iterator iter;
            for(iter = switchControllerMapping.begin(); iter != switchControllerMapping.end();iter++){
                if(strcmp(iter->switchId.c_str(),castMsg->getKnEntry().srcSwitch.c_str())==0){
                    found = true;
                    break;
                }
            }
            if(!found){
                SwitchControllerMapping mapping = SwitchControllerMapping();
                mapping.controllerId = castMsg->getKnEntry().srcController;
                mapping.switchId = castMsg->getKnEntry().srcSwitch;
                mapping.socket = findSocketFor(msg);

                switchControllerMapping.push_front(mapping);
            }

            handleKandooPacket(msg);
            auto castAux =  msg->removeAtFront<KN_Packet>();
            delete castAux->getKnEntryForUpdate().payload;
            msg->insertAtFront(castAux);

        } else {
            TcpSocket *socket = findSocketFor(msg);
            if(!socket){
                socket = new TcpSocket(msg);
                socket->setOutputGate(gate("socketOut"));
                ASSERT(socketMap.find(socket->getSocketId())==socketMap.end());
                socketMap[socket->getSocketId()] = socket;
            }
        }
        delete msg;
    } else {
         //check if message was received via our socket
         if(socket.belongsToSocket(msg)){
             if(msg->getKind() == TCP_I_ESTABLISHED){
                 socket.processMessage(msg);
             } else {
                 auto chunk = msg->peekAtFront<Chunk>();
                 if (dynamicPtrCast<const KN_Packet>(chunk) != nullptr) {
                     handleKandooPacket(msg);
                     auto castMsg = msg->removeAtFront<KN_Packet>();
                     delete castMsg->getKnEntryForUpdate().payload;
                     msg->insertAtFront(castMsg);
                 }
                 delete msg;
             }
         } else {
             delete msg;
         }
    }

}


bool KandooAgent::getIsRootController(){
    return isRootController;
}


void KandooAgent::sendRequest(KandooEntry entry){
    Enter_Method_Silent();

    auto knpck = makeShared<KN_Packet>();
    auto pkt = new Packet("KN Req");
    knpck->setKnEntry(entry);
    knpck->setChunkLength(B(1));
    pkt->setKind(TCP_C_SEND);
    pkt->insertAtFront(knpck);
    socket.send(pkt);
}

void KandooAgent::sendReply(Packet * pktIn, KandooEntry entry){
    Enter_Method_Silent();

    auto knpck = pktIn->peekAtFront<KN_Packet>();
    auto knrep = makeShared<KN_Packet>();
    auto pkt = new Packet("KN Rep");
    knrep->setKnEntry(entry);
    knrep->setChunkLength(B(1));
    pkt->setKind(TCP_C_SEND);
    pkt->insertAtFront(knrep);

    TcpSocket * tempSocket = findSocketFor(pktIn);
    tempSocket->send(pkt);
}

void KandooAgent::sendReplyToSwitchAuthoritive(std::string switchId, KandooEntry entry){
    Enter_Method_Silent();

    auto knrep = makeShared<KN_Packet>();
    auto pkt = new Packet("KN Rep");
    knrep->setKnEntry(entry);
    knrep->setChunkLength(B(1));
    pkt->setKind(TCP_C_SEND);
    pkt->insertAtFront(knrep);

    TcpSocket * tempSocket = NULL;
    std::list<SwitchControllerMapping>::iterator iter;
    for(iter = switchControllerMapping.begin(); iter != switchControllerMapping.end(); ++iter){
        if(strcmp(iter->switchId.c_str(),switchId.c_str())==0){
            tempSocket = iter->socket;
            break;
        }
    }

    if(tempSocket != NULL){
        tempSocket->send(pkt);
    }

}


void KandooAgent::handleKandooPacket(Packet * pktIn){
    auto knpck = pktIn->peekAtFront<KN_Packet>();
    emit(kandooEventSignalId,pktIn);
}





