
#ifndef ARPRESPONDER_H_
#define ARPRESPONDER_H_

#include <omnetpp.h>
#include "openflow/controllerApps/AbstractControllerApp.h"
#include "inet/transportlayer/contract/tcp/TCPSocket.h"
#include "openflow/openflow/controller/Switch_Info.h"
#include "openflow/messages/OFP_Features_Reply_m.h"
#include "openflow/messages/OFP_Packet_In_m.h"
#include "inet/networklayer/arp/ipv4/ARPPacket_m.h"
#include "inet/linklayer/ethernet/EtherFrame_m.h"

class ARPResponder:public AbstractControllerApp {


public:
    ARPResponder();
    ~ARPResponder();
    virtual void finish();

    bool addEntry(std::string srcIp, MACAddress srcMac);

protected:
    void receiveSignal(cComponent *src, simsignal_t id, cObject *obj, cObject *details) override;
    void initialize();
    virtual void handleMessage(cMessage *msg);
    virtual void handlePacketIn(OFP_Packet_In * packet_in_msg);

    virtual EtherFrame * createArpReply(IPv4Address srcIp, IPv4Address dstIp, MACAddress srcMac,MACAddress dstMac);

    std::map<MACAddress,std::string> macToIp;
    std::map<std::string,MACAddress> ipToMac;

    long answeredArp;
    long floodedArp;
};


#endif
