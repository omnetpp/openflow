

package openflow.openflow.controller;
import inet.applications.contract.IApp;
import inet.linklayer.ethernet.EthernetInterface;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.contract.INetworkLayer;
import inet.networklayer.contract.IRoutingTable;
import inet.transportlayer.contract.ITcp;
import openflow.controllerApps.AbstractControllerApp;
import inet.common.MessageDispatcher;
import inet.linklayer.ethernet.contract.IEthernetLayer;
//
// TODO documentation
//
module Open_Flow_Controller
{
    parameters:
        @networkNode();
        @labels(node,ethernet-node);
        @display("i=device/server;bgb=795,445;i2=openflow/OpenFlow-Logo-small");
        int numControllerApps = default(0);
        int numTcpControllerApps = default(0);

		//submodules
		bool hasTcp = default(firstAvailableOrEmpty("Tcp", "TcpLwip", "TcpNsc") != "");
        //string tcpType = default("TCP");  // tcp implementation (e.g. TCP, TCP_old, TCP_NSC)
        bool forwarding = default(false);
        bool multicastForwarding = default(false);
        string routingFile = default("");
        int numExtInterfaces = default(0);
        double serviceTime @unit("s") = default(0s);

        *.forwarding = this.forwarding;
        *.multicastForwarding = this.multicastForwarding;   // for IPv4, IPv6, Generic
        OF_Controller.serviceTime = this.serviceTime;
        //*.routingTableModule = default(absPath(".routingTable"));
        *.interfaceTableModule = default(absPath(".interfaceTable"));

    gates:
        inout ethg[] @labels(EtherFrame-conn);
    submodules:

        at: MessageDispatcher {
            parameters:
                @display("p=400,97;b=580,5,,,,1");
        }
        tn: MessageDispatcher {
            parameters:
                @display("p=400,200;b=580,5,,,,1");
        }
        nl: MessageDispatcher {
            parameters:
                @display("p=400,300;b=580,5,,,,1");
        }
        li: MessageDispatcher {
            parameters:
                @display("p=400,348;b=580,5,,,,1");
        }

        controllerApps[numControllerApps]: <> like AbstractControllerApp {
            parameters:
                @display("p=654,36,row,60");
        }

        tcpControllerApps[numTcpControllerApps]: <> like IApp {
            parameters:
                @display("p=201,36,row,60");
        }

        tcp: <default(firstAvailableOrEmpty("Tcp", "TcpLwip", "TcpNsc"))> like ITcp if hasTcp {
            parameters:
                @display("p=368,145");
        }

        ipv4: <default("Ipv4NetworkLayer")> like INetworkLayer {
            parameters:
                @display("p=368,247;q=queue");
        }
        eth[sizeof(ethg)]: EthernetInterface {
            parameters:
                @display("p=474,392,row,90;q=txQueue");
        }
        interfaceTable: InterfaceTable {
            parameters:
                @display("p=44,145");
        }
        OF_Controller: OF_Controller {
            @display("p=424,48");
            //serviceTime = this.serviceTime;
        }

    connections allowunconnected:
        at.out++ --> tn.in++;
        at.in++ <-- tn.out++;

        tn.out++ --> nl.in++;
        tn.in++ <-- nl.out++;

        nl.out++ --> li.in++;
        nl.in++ <-- li.out++;

        at.out++ --> tcp.appIn;
        at.in++ <-- tcp.appOut;

        tcp.ipOut --> tn.in++;
        tcp.ipIn <-- tn.out++;

        ipv4.ifIn <-- nl.out++;
        ipv4.ifOut --> nl.in++;

        tn.out++ --> ipv4.transportIn;
        tn.in++ <-- ipv4.transportOut;

        for i=0..sizeof(ethg)-1 {
            eth[i].upperLayerOut --> li.in++;
            eth[i].upperLayerIn <-- li.out++;
        }

        for i=0..sizeof(ethg)-1 {
            ethg[i] <--> { @display("m=s"); } <--> eth[i].phys;
        }

        for i=0..numTcpControllerApps-1 {
            tcpControllerApps[i].socketOut --> at.in++;
            tcpControllerApps[i].socketIn <-- at.out++;
        }

        OF_Controller.socketOut --> at.in++;
        OF_Controller.socketIn <-- at.out++;



}


