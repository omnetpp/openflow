
#ifndef ABSTRACTCONTROLLERAPP_H_
#define ABSTRACTCONTROLLERAPP_H_

#include <list>
#include <map>
#include "inet/common/lifecycle/OperationalBase.h"
#include "inet/common/lifecycle/ModuleOperations.h"
#include "openflow/openflow/controller/OF_Controller.h"
#include "inet/transportlayer/contract/tcp/TcpSocket.h"
#include "openflow/openflow/protocol/openflow.h"
#include "openflow/messages/Open_Flow_Message_m.h"
#include "openflow/messages/OFP_Packet_In_m.h"
#include "openflow/messages/OFP_Packet_Out_m.h"
#include "openflow/messages/OFP_Flow_Mod_m.h"
#include "inet/networklayer/arp/ipv4/ArpPacket_m.h"
#include "inet/networklayer/common/InterfaceTable.h"

struct CommonHeaderFields{
    uint32_t buffer_id;
    Switch_Info * swInfo;
    uint32_t inport;
    MacAddress src_mac;
    MacAddress dst_mac;
    int eth_type;
    Ipv4Address arp_src_adr;
    Ipv4Address arp_dst_adr;
    int arp_op;
};

class AbstractControllerApp: public OperationalBase, public cListener {


    std::map<int, int> ifaceIndex;

protected:


    virtual int getIndexFromId(int id);


    simsignal_t PacketInSignalId;
    simsignal_t PacketOutSignalId;
    simsignal_t PacketFeatureRequestSignalId;
    simsignal_t PacketFeatureReplySignalId;
    simsignal_t BootedSignalId;

    long packetsFlooded;
    long packetsDropped;
    long numPacketOut;
    long numFlowMod;

    OF_Controller * controller;

    virtual int numInitStages() const override { return NUM_INIT_STAGES; }
    virtual void initialize(int stage) override;
    virtual void finish() override;
    virtual void finish(cComponent *component, simsignal_t signalID) override {}
    //using cIListener::finish;

    virtual void handleMessageWhenUp(cMessage *msg) override {
        throw cRuntimeError("Received message, this module should not receive a message");
    }


    virtual void receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) override;

    //virtual OFP_Packet_Out * createFloodPacketFromPacketIn(OFP_Packet_In *packet_in_msg);
    //virtual OFP_Packet_Out * createDropPacketFromPacketIn(OFP_Packet_In *packet_in_msg);
    //virtual OFP_Packet_Out * createPacketOutFromPacketIn(OFP_Packet_In *packet_in_msg, uint32_t outport);
    //virtual OFP_Flow_Mod * createFlowMod(ofp_flow_mod_command mod_com,const oxm_basic_match &match, uint32_t outport,int idleTimeOut, int hardTimeOut);

    virtual Packet * createFloodPacketFromPacketIn(Packet *packet_in_msg);
    virtual Packet * createDropPacketFromPacketIn(Packet *packet_in_msg);
    virtual Packet * createPacketOutFromPacketIn(Packet *packet_in_msg, uint32_t outport);
    virtual Packet * createFlowMod(ofp_flow_mod_command mod_com,const oxm_basic_match &match, uint32_t outport,int idleTimeOut, int hardTimeOut);

    bool chekIcmpEchoRequest(Packet *pkt, int &seqNumber, int &identifier);
    virtual CommonHeaderFields extractCommonHeaderFields(Packet *packet_in_msg);

    //virtual void floodPacket(OFP_Packet_In *packet_in_msg);
    //virtual void dropPacket(OFP_Packet_In *packet_in_msg);
    //virtual void sendPacket(OFP_Packet_In *packet_in_msg, uint32_t outport);
    virtual void floodPacket(Packet *packet_in_msg);
    virtual void dropPacket(Packet *packet_in_msg);
    virtual void sendPacket(Packet *packet_in_msg, uint32_t outport);
    virtual void sendFlowModMessage(ofp_flow_mod_command mod_com,const oxm_basic_match &match, uint32_t outport, TcpSocket *socket,int idleTimeOut, int hardTimeOut);

    // Lifecycle methods
    virtual void handleStartOperation(LifecycleOperation *operation) override;
    virtual void handleStopOperation(LifecycleOperation *operation) override;
    virtual void handleCrashOperation(LifecycleOperation *operation) override;

    virtual bool isInitializeStage(int stage) const override { return stage == INITSTAGE_APPLICATION_LAYER; }
    virtual bool isModuleStartStage(int stage) const override { return stage == ModuleStartOperation::STAGE_APPLICATION_LAYER; }
    virtual bool isModuleStopStage(int stage) const override { return stage == ModuleStopOperation::STAGE_APPLICATION_LAYER; }

public:
    AbstractControllerApp();
    ~AbstractControllerApp();

};


#endif
