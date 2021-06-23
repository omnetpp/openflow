
#ifndef SWITCH_INFO_H_
#define SWITCH_INFO_H_

#include "openflow/openflow/protocol/openflow.h"
#include "inet/transportlayer/contract/tcp/TcpSocket.h"

using namespace __gnu_cxx;

class Switch_Info {
    public:
        Switch_Info();

        int getConnId() const;
        void setConnId(int connId);
        int getVersion() const;
        void setVersion(int version);
        std::string getMacAddress() const;
        void setMacAddress(std::string macAddress);
        int getNumOfPorts() const;
        void setNumOfPorts(int numOfPorts);
        TcpSocket* getSocket() const;
        void setSocket(TcpSocket* socket);

        void setSwitchPortsIndexId(const int &, const int &);


        int getIndexPort(const int&);
        int getIdPort(const int&);


    protected:
        std::vector<int> idPort;

        int connID;
        int numOfPorts;
        std::string macAddress;
        TcpSocket *socket;
        int version;

};

#endif /* FLOW_TABLE_H_ */
