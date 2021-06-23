
#ifndef LEARNINGSWITCH_H_
#define LEARNINGSWITCH_H_

#include <omnetpp.h>
#include "openflow/controllerApps/AbstractControllerApp.h"
#include "inet/linklayer/common/MacAddress.h"

class LearningSwitch:public AbstractControllerApp {


public:
    LearningSwitch();
    ~LearningSwitch();

protected:
    virtual void receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) override;
    virtual void initialize(int stage) override;
    void doSwitching(Packet *packet_in_msg);

    virtual void handleMessageWhenUp(cMessage *msg) override {
        throw cRuntimeError("Received message, this module should not receive a message");
    }


    std::map<Switch_Info *,std::map<MacAddress,uint32_t> > lookupTable;

    int idleTimeout;
    int hardTimeout;


};


#endif
