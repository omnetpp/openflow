

package openflow.openflow.controller;

//Communication with OpenFlow switch;
//Sending Packet-Out messages;
//Sending Flow Modification messages;

simple OF_Controller
{
    parameters:
        @signal[PacketIn](type="cPacket");
        @signal[PacketOut](type="cPacket");
        @signal[PacketHello](type="cPacket");
        @signal[PacketFeatureRequest](type="cPacket");
        @signal[PacketFeatureReply](type="cPacket");
        @signal[Booted](type="OF_Controller");
        @signal[queueSize](type="unsigned long");
        @statistic[queueSize](title="QueueSize"; record=vector?,stats?; interpolationmode=none);
        @signal[waitingTime](type="simtime_t");
        @statistic[waitingTime](title="WaitingTime"; record=vector?,stats?; interpolationmode=none);
        @display("i=block/app");
        
        string address = default("");
        int port = default(6633);
        double serviceTime @unit("s") = default(0s);
        
    gates:
        input socketIn @labels(TcpCommand/up);
        output socketOut @labels(TcpCommand/down);
}
