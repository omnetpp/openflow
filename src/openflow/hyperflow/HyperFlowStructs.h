
#ifndef HYPERFLOWSTRUCTS_H_
#define HYPERFLOWSTRUCTS_H_

#include "openflow/openflow/controller/Switch_Info.h"

struct ControlChannelEntry{
    std::list<Switch_Info *> switches;
    std::string controllerId;
    SimTime time;
};

struct DataChannelEntry{
    std::string srcController;
    std::string trgSwitch;
    int eventId;
    omnetpp::cObject * payload;
};



#endif /* OF_CONTROLLER_H_ */
