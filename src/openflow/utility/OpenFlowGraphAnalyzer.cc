#include "openflow/utility/OpenFlowGraphAnalyzer.h"
#include "inet/common/InitStages.h"
#include <queue>
#include <algorithm>
#include <vector>

Define_Module(OpenFlowGraphAnalyzer);

struct compNodeInt {
    bool operator() (const pair<cTopology::Node * ,int> &a, const pair<cTopology::Node * ,int> &b) {
        return a.second > b.second;
    }
};


void OpenFlowGraphAnalyzer::initialize(int stage) {

    OperationalBase::initialize(stage);
    if (stage == INITSTAGE_NETWORK_CONFIGURATION) {
        const char *NodeType = par("NodeType");
        considerOnlyEndToEnd = par("considerOnlyEndToEnd");

       std::vector<std::string> nodeTypes = cStringTokenizer(NodeType).asVector();
       topo.extractByNedTypeName(nodeTypes);


       EV << "cTopology found " << topo.getNumNodes() << "\n";

       for(int i=0;i<topo.getNumNodes();i++){
           if(strstr(topo.getNode(i)->getModule()->getFullPath().c_str(),"switch")!=NULL || strstr(topo.getNode(i)->getModule()->getFullPath().c_str(),"Switch")!=NULL){
               continue;
           }
           for(int j=0;j<topo.getNumNodes();j++){
               if(i==j){
                   continue;
               }
               if(strstr(topo.getNode(j)->getModule()->getFullPath().c_str(),"switch")!=NULL || strstr(topo.getNode(j)->getModule()->getFullPath().c_str(),"Switch")!=NULL){
                   continue;
               }
               computedPaths.push_front(getShortestPath(topo.getNode(i), topo.getNode(j)));
           }
       }

       maxPathLength = 0;
       minPathLength = std::numeric_limits<int>::max();
       numClientNodes = 0;
       numSwitchNodes = 0;
       avgPathLength = .0;

       std::list<std::list<cTopology::Node * > >::iterator iterOuter;
       std::list<cTopology::Node * >::iterator iterInner;
       int pathCounter = 0;
       for(iterOuter = computedPaths.begin(); iterOuter != computedPaths.end();iterOuter++ ){
           if(iterOuter->size()-1 < minPathLength){
               minPathLength = iterOuter->size()-1;
           }
           if(iterOuter->size()-1 > maxPathLength){
               maxPathLength = iterOuter->size()-1;
           }
           pathCounter++;
           avgPathLength += iterOuter->size()-1;


           int temp = 0;
           for(iterInner = iterOuter->begin(); iterInner != iterOuter->end();iterInner++ ){
               if(strstr((*iterInner)->getModule()->getFullName(), "switch") == NULL && strstr((*iterInner)->getModule()->getFullName(), "Switch") == NULL){
                   if(clMap.count((*iterInner)->getModule()->getFullPath()) >0){
                       temp = clMap[(*iterInner)->getModule()->getFullPath()];
                       clMap.erase((*iterInner)->getModule()->getFullPath());
                       clMap[(*iterInner)->getModule()->getFullPath()] = temp+1;
                   }else {
                       clMap[(*iterInner)->getModule()->getFullPath()] = 1;
                   }
               } else {
                   if(swMap.count((*iterInner)->getModule()->getFullPath()) >0){
                       temp = swMap[(*iterInner)->getModule()->getFullPath()];
                       swMap.erase((*iterInner)->getModule()->getFullPath());
                       swMap[(*iterInner)->getModule()->getFullPath()] = temp+1;
                   }else {
                       swMap[(*iterInner)->getModule()->getFullPath()] = 1;
                   }
               }
               EV << "Path" << pathCounter <<" ";
               EV << (*iterInner)->getModule()->getFullPath() << " ";
               EV << endl;
           }

       }

       //compute avg links switch
       int numLinks=0;
       for(int i=0;i<topo.getNumNodes();i++){
           if(strstr(topo.getNode(i)->getModule()->getFullPath().c_str(),"switch")!=NULL || strstr(topo.getNode(i)->getModule()->getFullPath().c_str(),"Switch")!=NULL){

                for(int j = 0;j < topo.getNode(i)->getNumOutLinks();j++){
                    //ignore control plane
                    if(strstr(topo.getNode(i)->getLinkOut(j)->getLocalGate()->getName(),"gateCPlane") != NULL){
                        continue;
                    }
                    numLinks++;
                }
           }
       }


       if(computedPaths.size() > 0){
           avgPathLength = avgPathLength /computedPaths.size();
       } else {
           avgPathLength = -1;
       }

       numClientNodes = clMap.size();
       numSwitchNodes = swMap.size();

       if(numSwitchNodes > 0){
           avgNumSwitchLinks = numLinks/numSwitchNodes;
       } else {
           avgNumSwitchLinks = -1;
       }


       EV << "Min Path Length: " << minPathLength << endl;
       EV << "Max Path Length: " << maxPathLength << endl;
       EV << "Avg Path Length: " << avgPathLength << endl;
       EV << "Num Clients: " << numClientNodes << endl;
       EV << "Num Switches: " << numClientNodes << endl;
       EV << "Avg Switch Links: " << avgNumSwitchLinks << endl;
    }
}

std::list<cTopology::Node *> OpenFlowGraphAnalyzer::getShortestPath(cTopology::Node * src, cTopology::Node * trg){
    std::list<cTopology::Node * > result = std::list<cTopology::Node *>();


    std::map<cTopology::Node *,bool> visited = std::map<cTopology::Node *,bool>();
    std::map<cTopology::Node *,int> dist = std::map<cTopology::Node *,int>();
    std::map<cTopology::Node *, cTopology::Node *> prev = std::map<cTopology::Node *, cTopology::Node *>();

    priority_queue< pair<cTopology::Node* , int> , vector<pair<cTopology::Node* , int>>, compNodeInt > q;

    //init verticies
    for(int i = 0; i< topo.getNumNodes(); i++){
        cTopology::Node * tmpNode = topo.getNode(i);
        if(tmpNode == src){
            continue;
        }
        q.push(pair<cTopology::Node *,int>(tmpNode, std::numeric_limits<int>::max()));
        dist[tmpNode] = std::numeric_limits<int>::max();
        prev[tmpNode] = NULL;
    }

    //init src
    q.push(pair<cTopology::Node *,int>(src, 0));
    dist[src] = 0;
    prev[src] = NULL;

    cTopology::Node * u = NULL;
    while(!q.empty()){

            u = q.top().first;
            q.pop();

            if(visited.count(u)>0){
                continue;
            }

            int alt;

            for(int i = 0;i < u->getNumOutLinks();i++){
                //ignore control plane
                if(strstr(u->getLinkOut(i)->getLocalGate()->getName(),"gateCPlane") != NULL){
                    continue;
                }

                if(visited.count(u->getLinkOut(i)->getRemoteNode())<=0){
                    alt = dist[u]+1;
                    if(alt < dist[u->getLinkOut(i)->getRemoteNode()]){
                        dist[u->getLinkOut(i)->getRemoteNode()] = alt;
                        prev[u->getLinkOut(i)->getRemoteNode()]=u;
                        q.push(pair<cTopology::Node *,int>(u->getLinkOut(i)->getRemoteNode(),alt));
                    }
                }
            }

            visited[u] = true;
    }

    cTopology::Node * tempTrg = trg;
    while(prev[tempTrg] != NULL){
        result.push_back(tempTrg);
        tempTrg = prev[tempTrg];
    }
    result.push_back(tempTrg);

    if(tempTrg != src){
        result.clear();
    }

    return result;
}


void OpenFlowGraphAnalyzer::finish(){
    // record statistics
    recordScalar("minPathLength", minPathLength);
    recordScalar("maxPathLength", maxPathLength);
    recordScalar("avgPathLength", avgPathLength);
    recordScalar("avgNumSwitchLinks", avgNumSwitchLinks);
    recordScalar("numClients", numClientNodes);
    recordScalar("numSwitches", numSwitchNodes);
    recordScalar("numPaths", computedPaths.size());
/*
    std::map<std::string,int>::iterator iterMap;
    for(iterMap = swMap.begin(); iterMap != swMap.end(); iterMap++){
        recordScalar(("nodeInNumPaths-"+iterMap->first).c_str(),iterMap->second);
    }
    for(iterMap = clMap.begin(); iterMap != clMap.end(); iterMap++){
        recordScalar(("nodeInNumPaths-"+iterMap->first).c_str(),iterMap->second);
    }
*/
    for(const auto &elem : swMap){
        recordScalar(("nodeInNumPaths-"+elem.first).c_str(), elem.second);
    }
    for(const auto &elem : clMap){
        recordScalar(("nodeInNumPaths-"+elem.first).c_str(), elem.second);
    }

}


void OpenFlowGraphAnalyzer::handleMessageWhenUp(cMessage *msg) {
    throw cRuntimeError("this module doesn't handle messages, it runs only in initialize()");
}
