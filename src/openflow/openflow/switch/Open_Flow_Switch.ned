

package openflow.openflow.switch;

import inet.linklayer.contract.IWiredInterface;
import inet.linklayer.ethernet.EthernetInterface;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.contract.INetworkLayer;
import inet.networklayer.contract.IRoutingTable;
import inet.transportlayer.contract.ITcp;
import inet.common.MessageDispatcher;
import inet.linklayer.ethernet.contract.IEthernetLayer;
import inet.protocolelement.contract.IProtocolLayer;

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


        ethernet1.registerProtocol = default(true);
        ethernet.registerProtocol = default(true);

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

        ethernet: <default(sizeof(gateControlPlane) > 0 ? "EthernetEncapsulation" : "")> like IEthernetLayer if typename != "" {
            @display("p=352,478");
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
                @display("p=313,664,row,90;q=txQueue");
        }

        etherMAC[sizeof(gateDataPlane)]: <default("EthernetInterface")> like IWiredInterface {
            parameters:
                mac.promiscuous = true;
                @display("p=736,572,c,70");
        }


        ethDisp: MessageDispatcher {
            parameters:
                @display("p=731,520;b=50,5,,,,1");
        }

        swDisp: MessageDispatcher {
            parameters:
                @display("p=731,394;b=50,5,,,,1");
        }


        OF_Switch: OF_Switch {
            @display("p=442,43");

        }

        ethernet1: <default(sizeof(gateControlPlane) > 0 ? "EthernetEncapsulation" : "")> like IEthernetLayer if typename != "" {
            @display("p=731,458");
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

        at.out++ --> OF_Switch.controlPlaneIn;
        OF_Switch.controlPlaneOut --> at.in++;

        bl.out++ --> ethernet.upperLayerIn if exists(ethernet);
        ethernet.upperLayerOut --> bl.in++ if exists(ethernet);

        ethernet.lowerLayerOut --> li.in++ if exists(ethernet);
        li.out++ --> ethernet.lowerLayerIn if exists(ethernet);

        for i=0..sizeof(gateControlPlane)-1 {
            eth[i].upperLayerOut --> li.in++;
            eth[i].upperLayerIn <-- li.out++;
            eth[i].phys <--> { @display("m=s"); } <--> gateControlPlane[i];
        }


        OF_Switch.dataPlaneOut --> swDisp.in++;
        OF_Switch.dataPlaneIn <-- swDisp.out++;

        ethernet1.upperLayerOut --> swDisp.in++;
        swDisp.out++ --> ethernet1.upperLayerIn;

        ethernet1.lowerLayerOut --> ethDisp.in++;
        ethDisp.out++ --> ethernet1.lowerLayerIn;


        for i=0..sizeof(gateDataPlane)-1 {
            ethDisp.out++ --> etherMAC[i].upperLayerIn;
            etherMAC[i].upperLayerOut --> ethDisp.in++;
            etherMAC[i].phys <--> { @display("m=s"); } <--> gateDataPlane[i];
        }
}
