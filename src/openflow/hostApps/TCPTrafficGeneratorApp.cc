

#include "openflow/hostApps/TCPTrafficGeneratorApp.h"
#include "inet/transportlayer/contract/tcp/TcpSocket.h"
#include "inet/networklayer/common/L3AddressResolver.h"
#include "inet/applications/tcpapp/GenericAppMsg_m.h"
#include "inet/common/TimeTag_m.h"

using namespace std;
using namespace inet;


Define_Module(TCPTrafficGeneratorApp);

void TCPTrafficGeneratorApp::handleStartOperation(LifecycleOperation *operation)
{
    simtime_t startTime = par("startSending");
    simtime_t start = std::max(startTime, simTime());
    cMessage *msg = new cMessage("newConnection");
    msg->setKind(1);
    timerSet.insert(msg);
    scheduleAt(start, msg);
}

void TCPTrafficGeneratorApp::handleStopOperation(LifecycleOperation *operation)
{
    while(!timerSet.empty()) {
        cancelAndDelete(*timerSet.begin());
        timerSet.erase(timerSet.begin());
    }
}

void TCPTrafficGeneratorApp::handleCrashOperation(LifecycleOperation *operation)
{
    while(!timerSet.empty()) {
        cancelAndDelete(*timerSet.begin());
        timerSet.erase(timerSet.begin());
    }
}


void TCPTrafficGeneratorApp::initialize(int stage){
    ApplicationBase::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        topo.extractByNedTypeName(cStringTokenizer(par("destinationNedType")).asVector());

    //determine the first connection setup

        //stats
        connectionFinished =registerSignal("connectionFinished");
        connectionStarted = registerSignal("connectionStarted");
        connectionEstablished =registerSignal("connectionEstablished");
        transmittedBytes = registerSignal("transmittedBytes");
        //determine linenumbers
        const int SZ = 1024 * 1024;
        std::vector <char> buff( SZ );
        std::string path = par("pathToFlowSizes");
        ifstream ifs( path.c_str() );
        while( int cc = FileRead( ifs, buff ) ) {
            lineNumbers += CountLines( buff, cc );
        }
        ifs.close();
    }
}

void TCPTrafficGeneratorApp::handleMessageWhenUp(omnetpp::cMessage *msg){
    if (msg->isSelfMessage()){
        auto timerIt = timerSet.find(msg);
        if (timerIt != timerSet.end())
            timerSet.erase(timerIt);
        if(msg->getKind() == 1){
            //determine random target
            int random_num = intrand(topo.getNumNodes());
            std::string connectAddress = topo.getNode(random_num)->getModule()->getFullPath();
            L3Address destAddr = L3AddressResolver().resolve(connectAddress.c_str());

            while (topo.getNode(random_num)->getModule() == getParentModule() || destAddr.isUnspecified()) {
                // avoid same source and destination
                random_num = intrand(topo.getNumNodes());
                connectAddress = topo.getNode(random_num)->getModule()->getFullPath();
                destAddr = L3AddressResolver().resolve(connectAddress.c_str());
            }
            //generate socket
            TcpSocket *tempSocket = new TcpSocket();
            tempSocket->setOutputGate(gate("socketOut"));
            tempSocket->setCallback(this);

            int connectPort = par("connectPort");

            tempSocket->connect(destAddr, connectPort);

            //generate packet
            const auto& payload = makeShared<GenericAppMsg>();
            Packet *packet = new Packet("data");

            int pos = floor(uniform(0,lineNumbers));

            //get the size of the nth line
            std::string path = par("pathToFlowSizes");
            std::ifstream f(path.c_str());
            std::string s;
            for (int i = 1; i <= pos; i++)
                    std::getline(f, s);

            //convert to long
            long size = (long) atof(s.c_str());

            f.close();

            payload->setChunkLength(B(size));
            payload->setServerClose(false);
            payload->addTag<CreationTimeTag>()->setCreationTime(simTime());
            packet->insertAtBack(payload);

            //send everything
            tempSocket->send(packet);

            //add to map
            Stats temp = Stats();
            temp.connectionStarted=simTime();
            temp.transmittedBytes=size;

            statistics[tempSocket]=temp;

            //schedule next connection
            cMessage *newMsg = new cMessage("newConnection");
            newMsg->setKind(1);
            double rnd = gamma_d(0.4754,13.7300);
            scheduleAt(simTime()+rnd, newMsg);
        }
        delete msg;
    } else {
        TcpSocket * tempSocket = nullptr;
        for (auto elem : statistics) {
            if (elem.first->belongsToSocket(msg)) {
                tempSocket = elem.first;
                break;
            }
        }
        if(tempSocket){
            //process the message
            tempSocket->processMessage(msg);
        } else {
            delete msg;
        }
    }
}


void TCPTrafficGeneratorApp::socketDataArrived(TcpSocket *socket, Packet *packet, bool urgent) {
    EV<< "TCPTrafficGenerator Data Arrived" << endl;
    delete packet;
}

void TCPTrafficGeneratorApp::socketEstablished(TcpSocket *socket){
    EV<< "TCPTrafficGenerator Connection Established" << endl;
    if (socket != nullptr) {
        statistics[socket].connectionEstablished = simTime();
    }
}


void TCPTrafficGeneratorApp::socketPeerClosed(TcpSocket *socket){
    EV<< "TCPTrafficGenerator Peer Closed -> Closing Too" << endl;
    if (socket != nullptr) {
        statistics[socket].connectionFinished=simTime();

        //emit vectors
        emit(connectionStarted,statistics[socket].connectionStarted);
        emit(connectionEstablished,statistics[socket].connectionEstablished);
        emit(connectionFinished,statistics[socket].connectionFinished);
        emit(transmittedBytes,statistics[socket].transmittedBytes);
        socket->close();
    }
}

void TCPTrafficGeneratorApp::socketClosed(TcpSocket *socket){
    EV<< "TCPTrafficGenerator Socket Closed" << endl;

    if (socket != nullptr) {
            //remove the socket
            statistics.erase(socket);
            //clear up space
            delete socket;
    }
}

void TCPTrafficGeneratorApp::socketFailure(TcpSocket *socket, int code)  {
    EV<< "TCPTrafficGenerator Socket Failed" << endl;
    if (code==TCP_I_CONNECTION_RESET)
        EV << "Connection reset!\\n";
    else if (code==TCP_I_CONNECTION_REFUSED)
        EV << "Connection refused!\\n";
    else if (code==TCP_I_TIMED_OUT)
        EV << "Connection timed out!\\n";
}

void TCPTrafficGeneratorApp::socketStatusArrived(TcpSocket *socket, TcpStatusInfo *status){
    EV<< "TCPTrafficGenerator Status Arrived" << endl;
    delete status;
}



unsigned int TCPTrafficGeneratorApp::FileRead( istream & is, vector <char> & buff ) {
    is.read( &buff[0], buff.size() );
    return is.gcount();
}

unsigned int TCPTrafficGeneratorApp::CountLines( const vector <char> & buff, int sz ) {
    int newlines = 0;
    const char * p = &buff[0];
    for ( int i = 0; i < sz; i++ ) {
        if ( p[i] == '\n' ) {
            newlines++;
        }
    }
    return newlines;
}







