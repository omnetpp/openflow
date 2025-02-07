

package openflow.hyperflow;
import inet.common.MessageDispatcher;
import inet.linklayer.contract.IEthernetLayer;
import inet.linklayer.ethernet.basic.EthernetInterface;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.contract.INetworkLayer;
import inet.protocolelement.contract.IProtocolLayer;
import inet.transportlayer.contract.ITcp;


//
// TODO documentation
//
module Hyper_Flow_Synchronizer
{
    parameters:
        @networkNode();
        @labels(node,ethernet-node);
        @display("i=device/server;bgb=839.358,713.18;i2=openflow/OpenFlow-Logo-small");
        bool hasTcp = default(firstAvailableOrEmpty("Tcp", "TcpLwip", "TcpNsc") != "");
		//submodules
        //string tcpType = default("TCP");  // tcp implementation (e.g. TCP, TCP_old, TCP_NSC)
        int numExtInterfaces = default(0);
        double serviceTime @unit("s") = default(0s);

        string networkLayerType = default("IPv4NetworkLayer");
        string routingTableType = default("IPv4RoutingTable");
        ethernet.registerProtocol = default(true);
        bool forwarding = default(false);
        bool multicastForwarding = default(false);
        string routingFile = default("");

        routingTable.forwarding = forwarding;
        routingTable.multicastForwarding = multicastForwarding;   // for IPv4, IPv6, Generic
        *.routingTableModule = default(absPath(".routingTable"));
        *.interfaceTableModule = default(absPath(".interfaceTable"));

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

        interfaceTable: InterfaceTable {
            parameters:
                @display("p=63,249");
        }

        tcp: <default(firstAvailableOrEmpty("Tcp", "TcpLwip", "TcpNsc"))> like ITcp if hasTcp {
            parameters:
                @display("p=360,142");
        }
        ipv4: <default("Ipv4NetworkLayer")> like INetworkLayer {
            parameters:
                @display("p=352,249;q=queue");
        }
        eth[sizeof(ethg)]: EthernetInterface {
            parameters:
                @display("p=374.4195,613.0605,row,90;q=txQueue");
        }
        HyperFlowSynchronizer: HyperFlowSynchronizer {
            @display("p=213,44");
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

        at.out++ --> HyperFlowSynchronizer.socketIn;
        HyperFlowSynchronizer.socketOut --> at.in++;
}


