#include "openflow/utility/ControllerInvolvementFilter.h"


Define_Module(ControllerInvolvementFilter);


void ControllerInvolvementFilter::initialize(int stage) {
    OperationalBase::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        cpPingPacketHash = registerSignal("cpPingPacketHash");
        getParentModule()->subscribe("cpPingPacketHash",this);
    }
}

void ControllerInvolvementFilter::receiveSignal(cComponent *source, simsignal_t signalID, unsigned long l, cObject *details) {
    Enter_Method("ControllerInvolvementFilter::receiveSignal %s", cComponent::getSignalName(signalID));
    if(signalID==cpPingPacketHash){
        if(controllerInvolvements.count(l) <=0){
            controllerInvolvements.insert(std::pair<long,int>(l,1));
        } else {
            controllerInvolvements[l]++;
        }
    }
}

void ControllerInvolvementFilter::handleMessageWhenUp(cMessage *msg) {
    error("this module doesn't handle messages, it runs only in initialize()");
}

void ControllerInvolvementFilter::finish(){
    std::map<long,int>::iterator iterMap;
    for(iterMap = controllerInvolvements.begin(); iterMap != controllerInvolvements.end(); iterMap++){
        std::stringstream name;
        name << "controllerInvolvementsFor-" << iterMap->first;
        recordScalar(name.str().c_str(),iterMap->second);
    }
}
