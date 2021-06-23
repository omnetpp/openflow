#include <omnetpp.h>
#include "openflow/openflow/controller/Switch_Info.h"

using namespace std;

Switch_Info::Switch_Info(){

}


int Switch_Info::getConnId() const {
        return connID;
}

void Switch_Info::setConnId(int connId) {
        connID = connId;
}

int Switch_Info::getVersion() const {
        return connID;
}

void Switch_Info::setVersion(int version_t) {
        version = version_t;
}


string Switch_Info::getMacAddress() const {
        return macAddress;
}

void Switch_Info::setMacAddress(string macAddress) {
        this->macAddress = macAddress;
}

int Switch_Info::getNumOfPorts() const {
        return numOfPorts;
}

void Switch_Info::setNumOfPorts(int numOfPorts) {
        this->numOfPorts = numOfPorts;
        if (numOfPorts > 0) {
            this->idPort.resize(numOfPorts);
            std::fill(this->idPort.begin(), this->idPort.end(), -1);
        }
        else
            this->idPort.clear();
}

void Switch_Info::setSwitchPortsIndexId(const int &index, const int &id) {
    if (index >= (int) this->idPort.size() || index < 0)
        throw cRuntimeError("Index port doesn't exist");
    this->idPort[index] = id;
}


int Switch_Info::getIndexPort(const int &index) {
    if (index >= (int) this->idPort.size() || index < 0)
        throw cRuntimeError("Index port doesn't exist");
    return this->idPort[index];
}

int Switch_Info::getIdPort(const int &id) {
    auto it = std::find(this->idPort.begin(), this->idPort.end(), id);
    if (it == this->idPort.end())
        return -1;
    return (*it);
}


TcpSocket* Switch_Info::getSocket() const {
        return socket;
}

void Switch_Info::setSocket(TcpSocket* socket) {
        this->socket = socket;
}
