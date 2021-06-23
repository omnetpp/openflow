

package openflow.hostApps;


import inet.applications.contract.IApp;


simple TCPTrafficGeneratorApp like IApp
{
    parameters:
        @signal[connectionFinished](type="simtime_t");
        @statistic[connectionFinished](title="ConnectionFinished"; record=vector?,stats; interpolationmode=none);
        @signal[connectionStarted](type="simtime_t");
        @statistic[connectionStarted](title="ConnectionStarted"; record=vector?,stats; interpolationmode=none);
        @signal[connectionEstablished](type="simtime_t");
        @statistic[connectionEstablished](title="ConnectionEstablished"; record=vector?,stats; interpolationmode=none);
        @signal[transmittedBytes](type="double");
        @statistic[transmittedBytes](title="BytesTransmitted"; record=vector?,stats; interpolationmode=none);
        @display("i=block/app");
        double startSending @unit("s") = default(2s);
        int connectPort = default(1000);
        string destinationNedType = default("inet.node.inet.StandardHost");
        string pathToFlowSizes = default("");

    gates:
        input socketIn @labels(TcpCommand/up);
        output socketOut @labels(TcpCommand/down);
}

