#include <omnetpp.h>
#include "openflow/controllerApps/LLDPMibGraph.h"

#include <vector>
#include <sstream>


using namespace std;




LLDPMibGraph::LLDPMibGraph(){
    numOfEdges=0;
    numOfVerticies=0;
    version = 0;
}

const std::string LLDPMibGraph::getStringGraph(){
    std::stringstream stream;

    for(auto iterKey= verticies.begin(); iterKey!= verticies.end(); ++iterKey){
        for(auto iterList=verticies[iterKey->first].begin(); iterList!=verticies[iterKey->first].end(); ++iterList){
            stream << " ("<<iterList->getSrcId() << "," <<iterList->getSrcPort() << ") ->" << "("<<iterList->getDstId() << "," <<iterList->getDstPort() << ") Expires at:"<< iterList->getExpiresAt() << "\n";
        }
    }

    return stream.str();
}


bool LLDPMibGraph::addEntry(std::string src, int srcPort, std::string dst, int dstPort, SimTime timeOut) {
    //check if we have an arp packet
    if(srcPort == -1){
        if(verticies.count(dst) >0){
            //we have seen this arp before, check if we are the first hop
            for(auto iterList=verticies[dst].begin();iterList!=verticies[dst].end(); ++iterList){
                if(iterList->getSrcPort() == dstPort && iterList->getDstPort() != -1){
                    return false;
                }
            }
        }
    }

    //enter src to dst
    //check if vertex exists
    if(verticies.count(src) <= 0){
        verticies[src] = std::vector<LLDPMib>();
        verticies[src].push_back(LLDPMib(srcPort,dstPort,src,dst,simTime()+timeOut));
        numOfVerticies++;
        numOfEdges++;
        version++;
    } else {
        //check if entry exists
        LLDPMib mib = LLDPMib(srcPort,dstPort,src,dst,simTime()+timeOut);
        auto iterMib = std::find(verticies[src].begin(), verticies[src].end(), mib);
        if(iterMib != verticies[src].end()){
            (*iterMib).setExpiresAt(simTime()+timeOut);
        } else {
            verticies[src].push_back(mib);
            numOfEdges++;
            version++;
        }
    }

    //enter dst to src
    //check if vertex exists
    if(verticies.count(dst) <= 0){
        verticies[dst] = std::vector<LLDPMib>();
        verticies[dst].push_back(LLDPMib(dstPort,srcPort,dst,src,simTime()+timeOut));
        numOfVerticies++;
        numOfEdges++;
        version++;
     } else {
        //check if entry exists
        LLDPMib mib = LLDPMib(dstPort,srcPort,dst,src,simTime()+timeOut);
        auto iterMib = std::find(verticies[dst].begin(), verticies[dst].end(), mib);
        if(iterMib != verticies[dst].end()){
            (*iterMib).setExpiresAt(simTime()+timeOut);
        } else {
            verticies[dst].push_back(mib);
            numOfEdges++;
            version++;
        }
     }
    return true;

}


void LLDPMibGraph::removeExpiredEntries(){
    simtime_t curSimTime = simTime();
    auto iterKey = verticies.begin();
    while(iterKey != verticies.end()){
        //remove expired list entries
        auto iterList=iterKey->second.begin();
        while(iterList != iterKey->second.end()){
            if(iterList->getExpiresAt() < curSimTime){
                iterKey->second.erase(iterList);
                iterList--;
                numOfEdges--;
                version++;
            }
            iterList++;
        }

        //remove vertex if no link is left
        if(iterKey->second.empty()){
            verticies.erase(iterKey);
            iterKey--;
            numOfVerticies--;
            version++;
        }
        iterKey++;
    }
}






long LLDPMibGraph::getNumOfEdges() const {
    return numOfEdges;
}

long LLDPMibGraph::getNumOfVerticies() const {
    return numOfVerticies;
}


const std::map<std::string, std::vector<LLDPMib> >& LLDPMibGraph::getVerticies() const {
    return verticies;
}

long LLDPMibGraph::getVersion() const {
    return version;
}

