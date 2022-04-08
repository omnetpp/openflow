
#ifndef OPENFLOWGRAPHANALYZER_H_
#define OPENFLOWGRAPHANALYZER_H_

#include "inet/common/lifecycle/OperationalBase.h"
#include "inet/common/lifecycle/ModuleOperations.h"
#include "openflow/openflow/switch/OF_Switch.h"

class Node;

class OpenFlowGraphAnalyzer : public OperationalBase
{

public:
    virtual void finish() override;


protected:
        cTopology topo;

        std::list<std::list<cTopology::Node *> > computedPaths;
        std::list<cTopology::Node * > getShortestPath(cTopology::Node * src, cTopology::Node * trg);

        int maxPathLength;
        int minPathLength;
        double avgPathLength;
        int numClientNodes;
        int numSwitchNodes;
        double avgNumSwitchLinks;
        bool considerOnlyEndToEnd;

        std::map<std::string,int> swMap;
        std::map<std::string,int> clMap;


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
