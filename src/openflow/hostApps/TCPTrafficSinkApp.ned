

package openflow.hostApps;


import inet.applications.contract.IApp;


simple TCPTrafficSinkApp like IApp
{
    parameters:
        @display("i=block/app");
        string localAddress = default("");
        int localPort = default(-1);  // local port

    gates:
        input socketIn @labels(TcpCommand/up);
        output socketOut @labels(TcpCommand/down);
}

