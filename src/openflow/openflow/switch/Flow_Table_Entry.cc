#include <omnetpp.h>
#include "inet/linklayer/ethernet/common/EthernetMacHeader_m.h"
#include "inet/linklayer/common/MacAddress.h"
#include "inet/networklayer/arp/ipv4/ArpPacket_m.h"
#include "openflow/openflow/switch/Flow_Table_Entry.h"

using namespace std;

Flow_Table_Entry::Flow_Table_Entry(){
    idleTimeout = 0.;
    hardTimeout = 0.;
}

Flow_Table_Entry::Flow_Table_Entry(const OFP_Flow_Mod *flowModMsg){
    match = flowModMsg->getMatch();

    instructions[0] = flowModMsg->getActions(0);

    priority = flowModMsg->getPriority();
    hardTimeout = flowModMsg->getHard_timeout();
    idleTimeout = flowModMsg->getIdle_timeout();

    if(idleTimeout != 0){
        expiresAt = idleTimeout+simTime();
    } else {
        expiresAt = hardTimeout+simTime();
    }
}

flow_table_cookie Flow_Table_Entry::getCookie() const{
    return cookie;
}

flow_table_counters Flow_Table_Entry::getCounters() const{
    return counters;
}

flow_table_flags Flow_Table_Entry::getFlags() const{
    return flags;
}

double Flow_Table_Entry::getHardTimeout() const{
    return hardTimeout;
}

double Flow_Table_Entry::getIdleTimeout() const{
    return idleTimeout;
}

SimTime Flow_Table_Entry::getExpiresAt() const{
    return expiresAt;
}

ofp_action_output Flow_Table_Entry::getInstructions() const{
    return instructions[0];
}

oxm_basic_match Flow_Table_Entry::getMatch() const{
    return match;
}

int Flow_Table_Entry::getPriority() const{
    return priority;
}

void Flow_Table_Entry::setCookie(flow_table_cookie cookie){
    this->cookie = cookie;
}

void Flow_Table_Entry::setCounters(flow_table_counters counters){
    this->counters = counters;
}

void Flow_Table_Entry::setFlags(flow_table_flags flags){
    this->flags = flags;
}

void Flow_Table_Entry::setHardTimeout(double hardTimeout){
    this->hardTimeout = hardTimeout;
}

void Flow_Table_Entry::setIdleTimeout(double idleTimeout){
    this->idleTimeout = idleTimeout;
}

void Flow_Table_Entry::setExpiresAt(SimTime expiresAt){
    this->expiresAt = expiresAt;
}

void Flow_Table_Entry::setInstructions(ofp_action_output instructions[1]){
    this->instructions[0] = instructions[0];
}

void Flow_Table_Entry::setMatch(oxm_basic_match match){
    this->match = match;
}

void Flow_Table_Entry::setPriority(int priority){
    this->priority = priority;
}
