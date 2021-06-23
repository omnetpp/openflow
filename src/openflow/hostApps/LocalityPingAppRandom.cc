

#include <iostream>

#include "openflow/hostApps/LocalityPingAppRandom.h"
#include "inet/networklayer/common/L3AddressResolver.h"
#include "inet/networklayer/common/L3AddressTag_m.h"
#include "inet/networklayer/common/NetworkInterface.h"
#include "inet/networklayer/contract/IInterfaceTable.h"
#include "inet/networklayer/contract/IL3AddressType.h"
#include "inet/networklayer/contract/L3Socket.h"
#include "inet/networklayer/contract/ipv4/Ipv4Socket.h"
#include "inet/networklayer/contract/ipv6/Ipv6Socket.h"

#include "inet/networklayer/common/L3AddressResolver.h"

using namespace std;
using std::cout;
using namespace inet;

Define_Module(LocalityPingAppRandom);


void LocalityPingAppRandom::initialize(int stage){
    PingApp::initialize(stage);
    if(stage == INITSTAGE_LOCAL){
        //set params
        localityRelation = par("localityRelation");

        //read in config
        std::string path = par("pathToGroupConfigFile");
        ifstream ifs( path.c_str() );
        if(ifs){
            string node="";
            string group="";
            string line="";
            while(!ifs.eof()){
                getline(ifs, line);

                node = (cStringTokenizer(line.c_str(),";").asVector())[0];
                group = (cStringTokenizer(line.c_str(),";").asVector())[1];

                //check if the node is me
                if(strstr(getParentModule()->getFullPath().c_str(),node.c_str())!=NULL){
                    localId = group;
                } else {
                    if(groupToNodes.count(group)== 0){
                        groupToNodes[group] = std::vector<std::string>();
                        groupToNodes[group].push_back(node);
                    } else {
                        groupToNodes[group].push_back(node);
                    }
                }
            }
        } else {
            EV << "File not found!" << endl;
        }
        ifs.close();

    }
}



void LocalityPingAppRandom::handleSelfMessage(omnetpp::cMessage *msg)
{
    if (msg == timer){
        //determine local oder global
        if(dblrand() <= localityRelation){
            //determine random local target
            std::vector<std::string> tempVec = groupToNodes[localId];
            connectAddress = (tempVec[intrand(groupToNodes[localId].size())]);
        } else {
            //determine random global target
            //determine group
            int tempRand = intrand(groupToNodes.size());
            while(tempRand == atoi(localId.c_str())){
                tempRand = intrand(groupToNodes.size());
            }
            //determine host
            std::vector<std::string> tempVec = groupToNodes[std::to_string(tempRand)];
            connectAddress = (tempVec[intrand(groupToNodes[std::to_string(tempRand)].size())]);
        }

        destAddr = L3AddressResolver().resolve(connectAddress.c_str());
        ASSERT(!destAddr.isUnspecified());
        srcAddr = L3AddressResolver().resolve(par("srcAddr"));
        EV << "Starting up: dest=" << destAddr << "  src=" << srcAddr << "\n";
        sendPingRequest();
        if (isEnabled())
            scheduleNextPingRequest(simTime(), true);
    }
}

bool LocalityPingAppRandom::isEnabled(){
    return (count == -1 || sentCount < count);
}

