
#ifndef OF_CONTROLLER_H_
#define OF_CONTROLLER_H_

#include "inet/transportlayer/contract/tcp/TcpSocket.h"
#include "openflow/messages/Open_Flow_Message_m.h"
#include "openflow/messages/OFP_Packet_In_m.h"
#include "openflow/messages/OFP_Hello_m.h"
#include "openflow/openflow/controller/Switch_Info.h"
#include "inet/common/lifecycle/OperationalBase.h"
#include "inet/common/lifecycle/ModuleOperations.h"

class AbstractControllerApp;

class OF_Controller: public OperationalBase
{
public:
    OF_Controller();
    ~OF_Controller();
    virtual void finish() override;

    void sendPacketOut(Packet *of_msg, TcpSocket * socket);

    void registerApp(AbstractControllerApp * app);

    TcpSocket *findSocketFor(Packet *) const;
    Switch_Info *findSwitchInfoFor(Packet *msg) ;
    TcpSocket *findSocketForChassisId(std::string chassisId) const;

    std::vector<Switch_Info >* getSwitchesList() ;
    std::vector<AbstractControllerApp *>* getAppList() ;

    virtual void sendPacket(TcpSocket *tcp, Packet *msg);


protected:
    simsignal_t PacketInSignalId;
    simsignal_t PacketOutSignalId;
    simsignal_t PacketHelloSignalId;
    simsignal_t PacketFeatureRequestSignalId;
    simsignal_t PacketFeatureReplySignalId;
    simsignal_t BootedSignalId;

    //stats
    simsignal_t queueSize;
    simsignal_t waitingTime;
    long numPacketIn;
    std::map<int,int> packetsPerSecond;

    int lastQueueSize;
    double lastChangeTime;
    std::map<int,double> avgQueueSize;

    bool busy;
    double serviceTime;
    std::list<cMessage *> msgList;

    std::vector<Switch_Info > switchesList;
    std::vector<AbstractControllerApp *> apps;

    inet::TcpSocket socket;

    virtual void initialize(int stage) override;
    virtual void handleMessageWhenUp(cMessage *msg) override;
    void processQueuedMsg(Packet *);
    void calcAvgQueueSize(int size);
    void sendHello(Packet *msg);
    virtual void registerConnection(Indication *sockInfo);
    virtual void checkConnection(Packet *msg);
    void sendFeatureRequest(Packet *msg);
    virtual void handleFeaturesReply(Packet *of_msg);
    virtual void handlePacketIn(Packet *of_msg);

    // Lifecycle methods
    virtual void handleStartOperation(LifecycleOperation *operation) override;
    virtual void handleStopOperation(LifecycleOperation *operation) override {};
    virtual void handleCrashOperation(LifecycleOperation *operation) override {};

    virtual bool isInitializeStage(int stage) override { return stage == INITSTAGE_APPLICATION_LAYER; }
    virtual bool isModuleStartStage(int stage) override { return stage == ModuleStartOperation::STAGE_APPLICATION_LAYER; }
    virtual bool isModuleStopStage(int stage) override { return stage == ModuleStopOperation::STAGE_APPLICATION_LAYER; }

};



#endif /* OF_CONTROLLER_H_ */
