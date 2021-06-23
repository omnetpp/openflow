
#ifndef ARPRESPONDER_H_
#define ARPRESPONDER_H_

#include <omnetpp.h>
#include "openflow/controllerApps/AbstractControllerApp.h"
#include "inet/transportlayer/contract/tcp/TcpSocket.h"
#include "openflow/openflow/controller/Switch_Info.h"
#include "openflow/messages/OFP_Features_Reply_m.h"
#include "openflow/messages/OFP_Packet_In_m.h"
#include "inet/networklayer/arp/ipv4/ArpPacket_m.h"


class ARPResponder:public AbstractControllerApp {


public:
    ARPResponder();
    ~ARPResponder();
    virtual void finish() override;

    bool addEntry(std::string srcIp, MacAddress srcMac);

protected:

    virtual void handleStartOperation(LifecycleOperation *operation) override {}

    virtual void handleStopOperation(LifecycleOperation *operation) override {}

    virtual void handleCrashOperation(LifecycleOperation *operation) override {}

    void receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) override;
    void initialize(int stage) override;
    virtual void handleMessageWhenUp(cMessage *msg) override;
    //virtual void handlePacketIn(OFP_Packet_In * packet_in_msg);
    virtual void handlePacketIn(Packet * pkt);

    virtual Packet * createArpReply(Ipv4Address srcIp, Ipv4Address dstIp, MacAddress srcMac,MacAddress dstMac);

    std::map<MacAddress,std::string> macToIp;
    std::map<std::string,MacAddress> ipToMac;

    long answeredArp;
    long floodedArp;
};


#endif
