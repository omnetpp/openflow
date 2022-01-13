

package openflow.openflow.switch;

import inet.linklayer.contract.IWiredInterface;
import inet.linklayer.ethernet.EthernetInterface;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.contract.INetworkLayer;
import inet.networklayer.contract.IRoutingTable;
import inet.transportlayer.contract.ITcp;
import inet.common.MessageDispatcher;

module Open_Flow_Switch
{
    parameters:
        @networkNode();
        @OF_Switch();
        @labels(node,ethernet-node);
        @display("i=device/switch;i2=openflow/OpenFlow-Logo-small");
        bool sendCompletePacket = default(false);
        double serviceTime @unit("s") = default(0s);
        
        bool duplexMode = default(true);      // selects full-duplex (true) or half-duplex (false) operation
        bool csmacdSupport = default(!duplexMode);  // by default CSMA/CD is turned off, so only point-to-point duplex links are supported.
        
        string networkLayerType = default("Ipv4NetworkLayer");
        string routingTableType = default("Ipv4RoutingTable");

        //submodules
        bool hasTcp = default(firstAvailableOrEmpty("Tcp", "TcpLwip", "TcpNsc") != "");
        //string tcpType = default("TCP");  // tcp implementation (e.g. TCP, TCP_old, TCP_NSC)
        bool forwarding = default(false);
        bool multicastForwarding = default(false);
        string routingFile = default("");

        *.forwarding = this.forwarding;
        *.multicastForwarding = this.multicastForwarding;   // for IPv4, IPv6, Generic
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        etherMAC[*].encap.typename = "OmittedEthernetEncapsulation"; //etherMAC[*].encapType = "EtherEncapDummy";
        etherMAC[*].csmacdSupport = this.csmacdSupport;
        etherMAC[*].duplexMode = this.duplexMode;
        OF_Switch.sendCompletePacket = this.sendCompletePacket;
        ipv4.arp.proxyArpInterfaces = default(""); //*.proxyARP = false;

    gates:
        inout gateControlPlane[] @labels(ControlPlane);
        inout gateDataPlane[] @labels(DataPlane);

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
                @display("p=36,279");
        }
        tcp: <default(firstAvailableOrEmpty("Tcp", "TcpLwip", "TcpNsc"))> like ITcp if hasTcp {
            parameters:
                @display("p=330,145");
        }
        ipv4: <default("Ipv4NetworkLayer")> like INetworkLayer {
            parameters:
                @display("p=352,249;q=queue");
        }
        eth[sizeof(gateControlPlane)]: EthernetInterface {
            parameters:
                @display("p=352,393,row,90;q=txQueue");
        }
        etherMAC[sizeof(gateDataPlane)]: <default("EthernetInterface")> like IWiredInterface {
            parameters:
                mac.promiscuous = true;
                @display("p=635,393,c,70");
        }

        OF_Switch: OF_Switch {
            @display("p=442,43");

//            gates:
//                dataPlaneOut[sizeof(this.gateDataPlane)];
//                dataPlaneIn[sizeof(this.gateDataPlane)];
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

        at.out++ --> OF_Switch.controlPlaneIn;
        OF_Switch.controlPlaneOut --> at.in++;
        
        for i=0..sizeof(gateControlPlane)-1 {
            eth[i].upperLayerOut --> li.in++;
            eth[i].upperLayerIn <-- li.out++;
            eth[i].phys <--> { @display("m=s"); } <--> gateControlPlane[i];
        }


        for i=0..sizeof(gateDataPlane)-1 {
            OF_Switch.dataPlaneOut++ --> etherMAC[i].upperLayerIn;
            etherMAC[i].upperLayerOut --> OF_Switch.dataPlaneIn++;            
            etherMAC[i].phys <--> { @display("m=s"); } <--> gateDataPlane[i];
        }
}
