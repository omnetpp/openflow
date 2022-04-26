

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
import inet.protocolelement.contract.IProtocolLayer;
//
// TODO documentation
//
module Open_Flow_Controller
{
    parameters:
        @networkNode();
        @labels(node,ethernet-node);
        @display("i=device/server;bgb=794.3,655.2;i2=openflow/OpenFlow-Logo-small");
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
        ethernet.registerProtocol = default(true);
    gates:
        inout ethg[] @labels(EtherFrame-conn);
    submodules:

        at: MessageDispatcher {
            parameters:
                @display("p=400,101;b=580,5,,,,1");
        }
        tn: MessageDispatcher {
            parameters:
                @display("p=400,200;b=580,5,,,,1");
        }
        nl: MessageDispatcher {
            parameters:
                @display("p=400,300;b=500,5,,,,1");
        }

        cb: MessageDispatcher {
            @display("p=400,357;b=500,5");
        }
        bl: MessageDispatcher {
            @display("p=400,436;b=500,5");
        }

        li: MessageDispatcher {
            parameters:
                @display("p=400,532;b=500,5,,,,1");
        }

        bridging: <default("")> like IProtocolLayer if typename != "" {
            @display("p=297,405");
        }

        ethernet: <default(sizeof(ethg) > 0 ? "EthernetEncapsulation" : "")> like IEthernetLayer if typename != "" {
            @display("p=352,478");
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
                @display("p=351,596.7,row,90;q=txQueue");
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

        bl.out++ --> li.in++;
        li.out++ --> bl.in++;

        at.out++ --> tcp.appIn;
        at.in++ <-- tcp.appOut;

        tcp.ipOut --> tn.in++;
        tcp.ipIn <-- tn.out++;

        ipv4.ifIn <-- nl.out++;
        ipv4.ifOut --> nl.in++;

        cb.out++ --> bridging.upperLayerIn if exists(bridging);
        bridging.upperLayerOut --> cb.in++ if exists(bridging);

        cb.out++ --> bl.in++ if !exists(bridging);
        bl.out++ --> cb.in++ if !exists(bridging);


        tn.out++ --> ipv4.transportIn;
        tn.in++ <-- ipv4.transportOut;

        bridging.lowerLayerOut --> bl.in++ if exists(bridging);
        bl.out++ --> bridging.lowerLayerIn if exists(bridging);

        cb.out++ --> nl.in++;
        cb.in++ <-- nl.out++;

        bl.out++ --> ethernet.upperLayerIn if exists(ethernet);
        ethernet.upperLayerOut --> bl.in++ if exists(ethernet);
        
        ethernet.lowerLayerOut --> li.in++ if exists(ethernet);
        li.out++ --> ethernet.lowerLayerIn if exists(ethernet);

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


