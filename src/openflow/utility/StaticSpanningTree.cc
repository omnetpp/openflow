#include "openflow/utility/StaticSpanningTree.h"
Define_Module(StaticSpanningTree);


void StaticSpanningTree::initialize(int stage) {

    OperationalBase::initialize(stage);
    if (stage == INITSTAGE_NETWORK_LAYER) {
        const char *NodeType = par("NodeType");
        int startNode = par("startNode");


       std::vector<std::string> nodeTypes = cStringTokenizer(NodeType).asVector();
       topo_spanntree.extractByNedTypeName(nodeTypes);
       EV << "cTopology found " << topo_spanntree.getNumNodes() << "\n";

       if (topo_spanntree.getNumNodes() == 0)
           throw cRuntimeError("Impossible to compute the Spanning tree, 0 nodes found");

        nodeInfo.resize(topo_spanntree.getNumNodes());
        for (int i = 0; i < topo_spanntree.getNumNodes(); i++) {
            nodeInfo[i].moduleID = topo_spanntree.getNode(i)->getModuleId();
            nodeInfo[i].treeNeighbors.resize(topo_spanntree.getNumNodes(),0);
        }

        // start node for calculation of spanning tree
        if(startNode < topo_spanntree.getNumNodes()){
            nodeInfo[startNode].isInTree = true;
            EV << "Starting at Node: " << topo_spanntree.getNode(startNode)->getModule()->getFullPath() << "\n";
        }else{
            int tempInt = intrand(topo_spanntree.getNumNodes());
            nodeInfo[tempInt].isInTree = true;
            EV << "Starting at Node: " << topo_spanntree.getNode(tempInt)->getModule()->getFullPath() << "\n";
        }

        int counter = 0;
        while (counter != topo_spanntree.getNumNodes()) {
            counter = 0;
            for (int i = 0; i < topo_spanntree.getNumNodes(); i++) {

                if (nodeInfo[i].isProcessed) {
                    counter++;
                }

                if (nodeInfo[i].isInTree && !nodeInfo[i].isProcessed) {
                    EV << "Processing node " << topo_spanntree.getNode(i)->getModule()->getName() << " with index "<< i << ".\n";
                    nodeInfo[i].isProcessed = true;
                    // for loop over all neighbors
                    for (int j = 0; j < topo_spanntree.getNode(i)->getNumOutLinks(); j++) {
                        //ignore control plane
                        if(strstr(topo_spanntree.getNode(i)->getLinkOut(j)->getLocalGate()->getName(),"gateCPlane") != NULL){
                            continue;
                        }

                        // for loop over all nodes to identify neighbors
                        for (int x = 0; x < topo_spanntree.getNumNodes(); x++) {
                            // test, if node x is neighbor of node i by using moduleID and is not yet in tree

                            if (nodeInfo[x].moduleID == topo_spanntree.getNode(i)->getLinkOut(j)->getRemoteNode()->getModuleId())
                            {
                                if(!nodeInfo[x].isInTree){
                                    // Neighbor is not yet in tree and will be added
                                    nodeInfo[x].isInTree = true;
                                    nodeInfo[x].treeNeighbors[i]=1;

                                }else{
                                    if(nodeInfo[i].treeNeighbors[x]== 1){
                                        // Link is already part of spanning tree and must not be disabled
                                        continue;
                                    }
                                    // Neighbor is already in tree, deactivate corresponding link
                                    nodeInfo[i].ports.push_back(topo_spanntree.getNode(i)->getLinkOut(j)->getLocalGate()->getIndex());
                                    EV << "Disable link with index " << topo_spanntree.getNode(i)->getLinkOut(j)->getLocalGate()->getIndex() <<
                                            " at node " << i << " to node " << x << "!" << endl;

                                }
                            }
                        }

                    }

                }
            }

        }
        // disable ports for all nodes
        for (int x = 0; x < topo_spanntree.getNumNodes(); x++) {
            // Find open_flow_swich module within submodules
            if (topo_spanntree.getNode(x)->getModule()->findSubmodule("open_flow_switch")>=0) {
                cModule *mod = topo_spanntree.getNode(x)->getModule()->getSubmodule("open_flow_switch")->getSubmodule("OF_Switch");
                OF_Switch *proc = check_and_cast<OF_Switch *>(mod);
                proc->disablePorts(nodeInfo[x].ports);
            }else if (topo_spanntree.getNode(x)->getModule()->findSubmodule("OF_Switch")>=0) {
                cModule *mod = topo_spanntree.getNode(x)->getModule()->getSubmodule("OF_Switch");
                OF_Switch *proc = check_and_cast<OF_Switch *>(mod);
                proc->disablePorts(nodeInfo[x].ports);
            }
        }
    }
}

void StaticSpanningTree::handleMessageWhenUp(cMessage *msg) {
    error("this module doesn't handle messages, it runs only in initialize()");
}
