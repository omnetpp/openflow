
#ifndef ABSTRACTTCPCONTROLLERAPP_H_
#define ABSTRACTTCPCONTROLLERAPP_H_

#include "openflow/controllerApps/AbstractControllerApp.h"
#include "inet/transportlayer/contract/tcp/TcpSocket.h"


class AbstractTCPControllerApp: public AbstractControllerApp {

protected:

    virtual void initialize(int stage) override;
    virtual void handleMessageWhenUp(cMessage *msg) override;
    virtual void processQueuedMsg(Packet *data_msg) {};
    virtual void calcAvgQueueSize(int size);
    virtual void finish() override;

    //stats
    simsignal_t queueSize;
    simsignal_t waitingTime;

    std::map<int,int> packetsPerSecond;

    int lastQueueSize;
    double lastChangeTime;
    std::map<int,double> avgQueueSize;

    bool busy;
    std::list<Packet *> msgList;
    double serviceTime;

    TcpSocket socket;

    TcpSocket *findSocketFor(Packet *msg);
    std::map< int,TcpSocket * > socketMap;


public:
    AbstractTCPControllerApp();
    ~AbstractTCPControllerApp();

};


#endif
