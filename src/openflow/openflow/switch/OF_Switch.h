

#ifndef OF_SWITCH_H_
#define OF_SWITCH_H_

#include "inet/common/lifecycle/OperationalBase.h"
#include "inet/common/lifecycle/ModuleOperations.h"
#include "inet/transportlayer/contract/tcp/TcpSocket.h"

#include "openflow/openflow/switch/Buffer.h"
#include "openflow/messages/Open_Flow_Message_m.h"
#include "openflow/openflow/switch/Flow_Table.h"
#include "inet/networklayer/common/NetworkInterface.h"
#include <vector>

class OF_Switch: public OperationalBase
{
    std::map<int, int> ifaceIndex;
    std::map<int, int> controlPlaneIndex;
public:
    OF_Switch();
    ~OF_Switch();
    void disablePorts(std::vector<int> ports);
    virtual void finish() override;
    virtual int getIndexFromId(int id);

protected:
    double flowTimeoutPollInterval;
    double serviceTime;
    bool busy;
    bool sendCompletePacket;

    long controlPlanePacket;
    long dataPlanePacket;
    long flowTableHit;
    long flowTableMiss;

    //stats
    simsignal_t dpPingPacketHash;
    simsignal_t cpPingPacketHash;
    simsignal_t queueSize;
    simsignal_t bufferSize;
    simsignal_t waitingTime;

    std::list<cMessage *> msgList;
    std::vector<ofp_port> portVector;



    Buffer buffer;
    Flow_Table flowTable;
    TcpSocket socket;
    std::vector<NetworkInterface *> listInterfacesToDelete;

    virtual void initialize(int stage) override;
    virtual void handleMessageWhenUp(cMessage *msg) override;
    void connect(const char *connectToAddress);

    void processQueuedMsg(Packet *data_msg);
    void handleFeaturesRequestMessage(Packet *of_msg);
    void handleFlowModMessage(Packet *of_msg);
    void handlePacketOutMessage(Packet *of_msg);
    void executePacketOutAction(const ofp_action_header *action, Packet *frame, uint32_t inport);
    void processFrame(Packet *frame);
    void handleMissMatchedPacket(Packet *frame);

    // Lifecycle methods
    virtual void handleStartOperation(LifecycleOperation *operation) override;
    virtual void handleStopOperation(LifecycleOperation *operation) override {};
    virtual void handleCrashOperation(LifecycleOperation *operation) override {};

    virtual bool isInitializeStage(int stage) override { return stage == INITSTAGE_APPLICATION_LAYER; }
    virtual bool isModuleStartStage(int stage) override { return stage == ModuleStartOperation::STAGE_APPLICATION_LAYER; }
    virtual bool isModuleStopStage(int stage) override { return stage == ModuleStopOperation::STAGE_APPLICATION_LAYER; }

};


#endif /* OF_SWITCH_H_ */
