
#ifndef KNARPRESPONDER_H_
#define KNARPRESPONDER_H_

#include <omnetpp.h>
#include "openflow/controllerApps/AbstractControllerApp.h"
#include "inet/transportlayer/contract/tcp/TcpSocket.h"
#include "openflow/openflow/controller/Switch_Info.h"
#include "openflow/messages/OFP_Features_Reply_m.h"
#include "openflow/messages/OFP_Packet_In_m.h"
#include "inet/networklayer/arp/ipv4/ArpPacket_m.h"
#include "openflow/controllerApps/ARPResponder.h"
#include "openflow/kandoo/KandooAgent.h"
#include "openflow/utility/ARP_Wrapper.h"


class KN_ARPResponder:public ARPResponder {


public:
    KN_ARPResponder();
    ~KN_ARPResponder();


protected:
    virtual void receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) override;
    virtual void initialize(int stage) override;
    virtual void handlePacketIn(Packet * packet_in_msg) override;

    KandooAgent * knAgent;
    simsignal_t kandooEventSignalId;
    std::string appName;
};


#endif
