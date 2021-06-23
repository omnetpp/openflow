

#ifndef TCP_TRAFFIC_GENERATOR_APP_H_
#define TCP_TRAFFIC_GENERATOR_APP_H_

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <set>
#include "inet/applications/base/ApplicationBase.h"
#include "inet/transportlayer/contract/tcp/TcpSocket.h"
#include "inet/networklayer/common/L3Address.h"
#include "inet/applications/tcpapp/TcpAppBase.h"

using namespace std;
using namespace inet;

/**
 * Single-connection TCP application.
 */

struct Stats{
    SimTime connectionStarted;
    SimTime connectionEstablished;
    SimTime connectionFinished;
    long transmittedBytes;
};

class INET_API TCPTrafficGeneratorApp : public ApplicationBase, public TcpSocket::ICallback
{

  protected:
    cTopology topo;
    int  lineNumbers;
    std::set<cMessage *> timerSet;
    virtual void initialize(int stage) override;
    virtual void handleMessageWhenUp(omnetpp::cMessage *msg) override;
    unsigned int FileRead( istream & is, vector <char> & buff );
    unsigned int CountLines( const vector <char> & buff, int sz );
//    virtual void socketDataArrived(int connId, void *yourPtr, cPacket *msg, bool urgent);
//    virtual void socketEstablished(int connId, void *yourPtr);
//    virtual void socketPeerClosed(int connId, void *yourPtr);
//    virtual void socketClosed(int connId, void *yourPtr);
//    virtual void socketFailure(int connId, void *yourPtr, int code);
//    virtual void socketStatusArrived(int connId, void *yourPtr, TcpStatusInfo *status);

    virtual void socketDataArrived(TcpSocket *socket, Packet *packet, bool urgent) override;
    virtual void socketAvailable(TcpSocket *socket, TcpAvailableInfo *availableInfo) override { socket->accept(availableInfo->getNewSocketId()); }
    virtual void socketEstablished(TcpSocket *socket) override;
    virtual void socketPeerClosed(TcpSocket *socket) override;
    virtual void socketClosed(TcpSocket *socket) override;
    virtual void socketFailure(TcpSocket *socket, int code) override;
    virtual void socketStatusArrived(TcpSocket *socket, TcpStatusInfo *status) override;
    virtual void socketDeleted(TcpSocket *socket) override {};

    std::map<TcpSocket *,Stats> statistics;


    //stats
    simsignal_t connectionFinished;
    simsignal_t connectionStarted;
    simsignal_t connectionEstablished;
    simsignal_t transmittedBytes;

    // Lifecycle methods
    virtual void handleStartOperation(LifecycleOperation *operation) override;
    virtual void handleStopOperation(LifecycleOperation *operation) override;
    virtual void handleCrashOperation(LifecycleOperation *operation) override;


};

#endif

