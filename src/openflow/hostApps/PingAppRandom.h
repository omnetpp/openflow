
#include "inet/common/INETDefs.h"
#include "inet/applications/pingapp/PingApp.h"
#include "inet/networklayer/common/L3Address.h"

/**
 * Generates ping requests and calculates the packet loss and round trip
 * parameters of the replies. Uses cTopology class to get all available destinations
 * and chooses random one
 *
 * See NED file for detailed description of operation.
 */
class PingAppRandom : public inet::PingApp {
  protected:
    virtual bool isEnabled() override;
    virtual void initialize(int stage) override;
    virtual void handleSelfMessage(omnetpp::cMessage *msg) override;

    omnetpp::cTopology topo;
    std::string connectAddress;

    //stats
    inet::simsignal_t pingPacketHash;
};


