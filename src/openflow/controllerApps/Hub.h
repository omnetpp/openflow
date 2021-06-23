
#ifndef HUB_H_
#define HUB_H_

#include <omnetpp.h>
#include "openflow/controllerApps/AbstractControllerApp.h"

class Hub:public AbstractControllerApp {


public:
    Hub();
    ~Hub();

protected:
    void receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) override;
    void initialize(int stage) override;
};


#endif
