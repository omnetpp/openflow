
#ifndef KANDOO_AGENT_H_
#define KANDOO_AGENT_H_

#include <omnetpp.h>
#include "openflow/controllerApps/AbstractTCPControllerApp.h"
#include "inet/transportlayer/contract/tcp/TcpSocket.h"
#include "openflow/messages/KN_Packet_m.h"

struct SwitchControllerMapping {
    std::string switchId;
    std::string controllerId;
    TcpSocket *socket;
};

class KandooAgent:public AbstractTCPControllerApp {


public:
    KandooAgent();
    ~KandooAgent();

    bool getIsRootController();

    void sendRequest(KandooEntry entry);
    void sendReply(Packet * knpck,KandooEntry entry);

    void handleKandooPacket(Packet * knpck);

    void sendReplyToSwitchAuthoritive(std::string switchId, KandooEntry entry);

protected:

    virtual void initialize(int stage) override;
    virtual void handleMessageWhenUp(cMessage *msg) override;
    virtual void processQueuedMsg(Packet *data_msg) override;

    virtual void handleStartOperation(LifecycleOperation *operation) override;

    bool isRootController;

    std::list<SwitchControllerMapping> switchControllerMapping;

    simsignal_t kandooEventSignalId;


};


#endif
