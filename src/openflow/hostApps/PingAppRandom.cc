



#include "openflow/hostApps/PingAppRandom.h"

#include "inet/networklayer/common/L3AddressResolver.h"

#include <iostream>
#include <functional>
#include <string>
#include <algorithm>

using namespace inet;

Define_Module(PingAppRandom);


void PingAppRandom::initialize(int stage){
    if (stage == INITSTAGE_LOCAL){
        topo.extractByNedTypeName(cStringTokenizer(par("destinationNedType")).asVector());
        EV << "Number of extracted nodes: " << topo.getNumNodes() << endl;
    }
    PingApp::initialize(stage);
    pingPacketHash = registerSignal("pingPacketHash");

}

void PingAppRandom::handleSelfMessage(cMessage *msg){

        if (msg == timer){
            // connect to random destination node
            unsigned nodeNum = topo.getNumNodes();
            if (nodeNum == 0)
                throw cRuntimeError("No potential destination nodes found");
            int random_num = intrand(nodeNum);
            connectAddress =topo.getNode(random_num)->getModule()->getFullPath();
            while (topo.getNode(random_num)->getModule() == getParentModule()) {

                // avoid same source and destination
                random_num = intrand(topo.getNumNodes());
                connectAddress =topo.getNode(random_num)->getModule()->getFullPath();
            }

            destAddr = inet::L3AddressResolver().resolve(connectAddress.c_str());
            ASSERT(!destAddr.isUnspecified());
            srcAddr = inet::L3AddressResolver().resolve(par("srcAddr"));
            EV << "Starting up: dest=" << destAddr << "  src=" << srcAddr << "\n";

            sendPingRequest();
            if (isEnabled())
                scheduleNextPingRequest(simTime(), true);
        }
}

