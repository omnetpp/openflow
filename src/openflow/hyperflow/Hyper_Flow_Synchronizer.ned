

package openflow.hyperflow;
import inet.linklayer.ethernet.EthernetInterface;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.contract.INetworkLayer;
import inet.networklayer.contract.IRoutingTable;
import inet.transportlayer.contract.ITcp;
import inet.common.MessageDispatcher;

//
// TODO documentation
//
module Hyper_Flow_Synchronizer
{
    parameters:
        @networkNode();
        @labels(node,ethernet-node);
        @display("i=device/server;bgb=840,433;i2=openflow/OpenFlow-Logo-small");
        bool hasTcp = default(firstAvailableOrEmpty("Tcp", "TcpLwip", "TcpNsc") != "");
		//submodules
        //string tcpType = default("TCP");  // tcp implementation (e.g. TCP, TCP_old, TCP_NSC)
        int numExtInterfaces = default(0);
        double serviceTime @unit("s") = default(0s);

        string networkLayerType = default("IPv4NetworkLayer");
        string routingTableType = default("IPv4RoutingTable");

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
                @display("p=400,300;b=580,5,,,,1");
        }
        li: MessageDispatcher {
            parameters:
                @display("p=400,348;b=580,5,,,,1");
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
                @display("p=491,399,row,90;q=txQueue");
        }
        HyperFlowSynchronizer: HyperFlowSynchronizer {
            @display("p=213,44");
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

        at.out++ --> HyperFlowSynchronizer.socketIn;
        HyperFlowSynchronizer.socketOut --> at.in++;
}


