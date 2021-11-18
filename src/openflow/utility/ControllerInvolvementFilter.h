

#ifndef CONTROLLERINVOLVEMENTFILTER_H_
#define CONTROLLERINVOLVEMENTFILTER_H_

#include "inet/common/lifecycle/OperationalBase.h"
#include "inet/common/lifecycle/ModuleOperations.h"
using namespace inet;

class ControllerInvolvementFilter : public OperationalBase,  public cListener
{
protected:

        //stats
        simsignal_t cpPingPacketHash;

        virtual void initialize(int stage) override;
        virtual void finish() override;
        virtual void finish(cComponent *component, simsignal_t signalID) override {cListener::finish(component, signalID);}
        virtual void handleMessageWhenUp(cMessage *msg) override;

        virtual void receiveSignal(cComponent *source, simsignal_t signalID, unsigned long l, cObject *details) override;

        std::map<long,int> controllerInvolvements;

        // Lifecycle methods
        virtual void handleStartOperation(LifecycleOperation *operation) override {};
        virtual void handleStopOperation(LifecycleOperation *operation) override {};
        virtual void handleCrashOperation(LifecycleOperation *operation) override {};

        virtual bool isInitializeStage(int stage) override { return stage == INITSTAGE_APPLICATION_LAYER; }
        virtual bool isModuleStartStage(int stage) override { return stage == ModuleStartOperation::STAGE_APPLICATION_LAYER; }
        virtual bool isModuleStopStage(int stage) override { return stage == ModuleStopOperation::STAGE_APPLICATION_LAYER; }


};


#endif
