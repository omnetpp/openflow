
package openflow.hyperflow;

//Communication with OpenFlow switch;
//Sending Packet-Out messages;
//Sending Flow Modification messages;

simple HyperFlowSynchronizer
{
    parameters:
        @display("i=block/app");
        @signal[queueSize](type="unsigned long");
        @statistic[queueSize](title="QueueSize"; record=vector?,stats; interpolationmode=none);
        @signal[waitingTime](type="simtime_t");
        @statistic[waitingTime](title="WaitingTime"; record=vector?,stats?; interpolationmode=none);
        
        
        string address = default("");
        int port = default(1003);
        
        //should be the same as the checkaliveevery value of the agent module
        double aliveInterval @unit("s") = default(3s);
        
        double serviceTime @unit("s") = default(0s);
        
    gates:
        input socketIn @labels(TcpCommand/up);
        output socketOut @labels(TcpCommand/down);
}
