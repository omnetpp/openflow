

#include "inet/common/INETDefs.h"
#include "inet/applications/pingapp/PingApp.h"
#include "inet/networklayer/common/L3Address.h"
#include <iostream>
#include <fstream>
#include <vector>

using namespace inet;

/**
 * Generates ping requests and calculates the packet loss and round trip
 * parameters of the replies. Uses cTopology class to get all available destinations
 * and chooses random one
 *
 * See NED file for detailed description of operation.
 */
class LocalityPingAppRandom : public PingApp {
  protected:
    virtual void initialize(int stage) override;
    virtual void handleSelfMessage(omnetpp::cMessage *msg) override;
    virtual bool isEnabled() override;

    cTopology topo;
    std::string connectAddress;
    double localityRelation;
    std::string localId;
    std::map<std::string,std::vector<std::string> > groupToNodes;
};


