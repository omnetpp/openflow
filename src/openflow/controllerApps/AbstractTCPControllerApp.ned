//
// Copyright (C) 2004 Andras Varga
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program; if not, see <http://www.gnu.org/licenses/>.
//


package openflow.controllerApps;

import inet.applications.contract.IApp;


//
// Template for TCP applications. It shows what gates a TCP app
// needs, to be able to be used in ~StandardHost etc.
//
simple AbstractTCPControllerApp like AbstractControllerApp, IApp
{
    parameters:
        @display("i=block/app");
        @signal[queueSize](type="unsigned long");
        @statistic[queueSize](title="QueueSize"; record=vector?,stats; interpolationmode=none);
        @signal[waitingTime](type="simtime_t");
        @statistic[waitingTime](title="WaitingTime"; record=vector?,stats?; interpolationmode=none);
        double serviceTime @unit("s") = default(0s);

    gates:
        input socketIn @labels(TcpCommand/up);
        output socketOut @labels(TcpCommand/down);
}


