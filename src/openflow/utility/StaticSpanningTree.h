

#ifndef STATICSPANNINGTREE_H_
#define STATICSPANNINGTREE_H_

#include "inet/common/lifecycle/OperationalBase.h"
#include "inet/common/lifecycle/ModuleOperations.h"
#include "openflow/openflow/switch/OF_Switch.h"

class StaticSpanningTree : public OperationalBase
{
protected:
    struct NodeInfo {
            NodeInfo() {isInTree=false;isProcessed=false;}
            bool isInTree;
            bool isProcessed;
            int moduleID;
            std::vector<int> ports;
            std::vector<int> treeNeighbors;
        };

        typedef std::vector<NodeInfo> NodeInfoVector;
        cTopology topo_spanntree;
        NodeInfoVector nodeInfo;

        virtual void initialize(int stage) override;
        virtual void handleMessageWhenUp(cMessage *msg) override;

        // Lifecycle methods
        virtual void handleStartOperation(LifecycleOperation *operation) override {};
        virtual void handleStopOperation(LifecycleOperation *operation) override {};
        virtual void handleCrashOperation(LifecycleOperation *operation) override {};

        virtual bool isInitializeStage(int stage) const override { return stage == INITSTAGE_APPLICATION_LAYER; }
        virtual bool isModuleStartStage(int stage) const override { return stage == ModuleStartOperation::STAGE_APPLICATION_LAYER; }
        virtual bool isModuleStopStage(int stage) const override { return stage == ModuleStopOperation::STAGE_APPLICATION_LAYER; }

};


#endif /* SPANNINGTREE_H_ */
