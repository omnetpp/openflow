//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package scenarios.networks;

import inet.common.misc.ThruputMeteringChannel;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import openflow.nodes.DistanceChannel;
import openflow.nodes.Open_Flow_Domain;
import openflow.openflow.controller.Open_Flow_Controller;
import openflow.utility.ControllerInvolvementFilter;
import openflow.utility.OpenFlowGraphAnalyzer;
import openflow.utility.StaticSpanningTree;


network Scenario_Integra_KN
{
    parameters:
        int numControllers = default(1);
        int placementID = default(1);
    types:
        channel backboneline extends ThruputMeteringChannel
        {
            delay = 1us;
            datarate = 40Gbps;
            thruputDisplayFormat = "u";
        }
    submodules:
        configurator: Ipv4NetworkConfigurator {
            parameters:
                @display("p=449,598");
        }

        controllerInvolvementFilter: ControllerInvolvementFilter {
            @display("p=59,39");
        }
        spanningTree: StaticSpanningTree {
            @display("p=349,598");
        }

        openFlowGraphAnalyzer: OpenFlowGraphAnalyzer {
            @display("p=218,598");
        }

        root: Open_Flow_Controller {
            @display("p=396,23");
        }
        open_flow_controller1: Open_Flow_Controller if numControllers >=1 {
            @display("p=20,100");
        }
        open_flow_controller2: Open_Flow_Controller if numControllers >=2 {
            @display("p=40,100");
        }
        open_flow_controller3: Open_Flow_Controller if numControllers >=3 {
            @display("p=60,100");
        }
        open_flow_controller4: Open_Flow_Controller if numControllers >=4 {
            @display("p=80,100");
        }
        open_flow_controller5: Open_Flow_Controller if numControllers >=5 {
            @display("p=100,100");
        }
        ofs_1: Open_Flow_Domain {
            @display("p=462,200");
        }
        ofs_2: Open_Flow_Domain {
            @display("p=343,480");
        }
        ofs_3: Open_Flow_Domain {
            @display("p=377,75");
        }
        ofs_4: Open_Flow_Domain {
            @display("p=389,95");
        }
        ofs_5: Open_Flow_Domain {
            @display("p=63,443");
        }
        ofs_6: Open_Flow_Domain {
            @display("p=15,343");
        }
        ofs_7: Open_Flow_Domain {
            @display("p=104,379");
        }
        ofs_8: Open_Flow_Domain {
            @display("p=144,461");
        }
        ofs_9: Open_Flow_Domain {
            @display("p=21,305");
        }
        ofs_10: Open_Flow_Domain {
            @display("p=5,310");
        }
        ofs_11: Open_Flow_Domain {
            @display("p=1,96");
        }
        ofs_12: Open_Flow_Domain {
            @display("p=23,127");
        }
        ofs_13: Open_Flow_Domain {
            @display("p=0,127");
        }
        ofs_14: Open_Flow_Domain {
            @display("p=43,275");
        }
        ofs_15: Open_Flow_Domain {
            @display("p=23,305");
        }
        ofs_16: Open_Flow_Domain {
            @display("p=640,237");
        }
        ofs_17: Open_Flow_Domain {
            @display("p=595,291");
        }
        ofs_18: Open_Flow_Domain {
            @display("p=74,0");
        }
        ofs_19: Open_Flow_Domain {
            @display("p=343,28");
        }
        ofs_20: Open_Flow_Domain {
            @display("p=190,67");
        }
        ofs_21: Open_Flow_Domain {
            @display("p=236,269");
        }
        ofs_22: Open_Flow_Domain {
            @display("p=145,221");
        }
        ofs_23: Open_Flow_Domain {
            @display("p=149,251");
        }
        ofs_24: Open_Flow_Domain {
            @display("p=146,236");
        }
        ofs_25: Open_Flow_Domain {
            @display("p=90,142");
        }
        ofs_26: Open_Flow_Domain {
            @display("p=5,76");
        }
        ofs_27: Open_Flow_Domain {
            @display("p=10,2");
        }
    connections allowunconnected:

        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 571km; } <--> ofs_4.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 571km; } <--> ofs_4.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 914km; } <--> ofs_17.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 914km; } <--> ofs_17.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 1475km; } <--> ofs_21.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 1475km; } <--> ofs_21.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 1423km; } <--> ofs_8.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 1423km; } <--> ofs_8.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 1065km; } <--> ofs_21.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 1065km; } <--> ofs_21.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 95km; } <--> ofs_4.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 95km; } <--> ofs_4.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 250km; } <--> ofs_19.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 250km; } <--> ofs_19.gateCPlane++;
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 1636km; } <--> ofs_16.gateDPlane++;
        ofs_4.gateCPlane++ <--> DistanceChannel {  distance = 1636km; } <--> ofs_16.gateCPlane++;
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 345km; } <--> ofs_19.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 2239km; } <--> ofs_27.gateDPlane++;
        ofs_4.gateCPlane++ <--> DistanceChannel {  distance = 2239km; } <--> ofs_27.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 497km; } <--> ofs_6.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 497km; } <--> ofs_6.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 368km; } <--> ofs_7.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 368km; } <--> ofs_7.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 574km; } <--> ofs_8.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 574km; } <--> ofs_8.gateCPlane++;
        ofs_6.gateDPlane++ <--> DistanceChannel {  distance = 142km; } <--> ofs_9.gateDPlane++;
        ofs_6.gateCPlane++ <--> DistanceChannel {  distance = 142km; } <--> ofs_9.gateCPlane++;
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 412km; } <--> ofs_8.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 583km; } <--> ofs_24.gateDPlane++;
        ofs_7.gateCPlane++ <--> DistanceChannel {  distance = 583km; } <--> ofs_24.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 107km; } <--> ofs_10.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 107km; } <--> ofs_10.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 179km; } <--> ofs_14.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 179km; } <--> ofs_14.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 17km; } <--> ofs_15.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 17km; } <--> ofs_15.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 778km; } <--> ofs_26.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 778km; } <--> ofs_26.gateCPlane++;
        ofs_11.gateDPlane++ <--> DistanceChannel {  distance = 99km; } <--> ofs_13.gateDPlane++;
        ofs_11.gateCPlane++ <--> DistanceChannel {  distance = 99km; } <--> ofs_13.gateCPlane++;
        ofs_11.gateDPlane++ <--> DistanceChannel {  distance = 70km; } <--> ofs_26.gateDPlane++;
        ofs_11.gateCPlane++ <--> DistanceChannel {  distance = 70km; } <--> ofs_26.gateCPlane++;
        ofs_12.gateDPlane++ <--> DistanceChannel {  distance = 195km; } <--> ofs_26.gateDPlane++;
        ofs_12.gateCPlane++ <--> DistanceChannel {  distance = 195km; } <--> ofs_26.gateCPlane++;
        ofs_12.gateDPlane++ <--> DistanceChannel {  distance = 402km; } <--> ofs_27.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_14.gateDPlane++ <--> DistanceChannel {  distance = 687km; } <--> ofs_24.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_16.gateDPlane++ <--> DistanceChannel {  distance = 350km; } <--> ofs_17.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_18.gateDPlane++ <--> DistanceChannel {  distance = 711km; } <--> ofs_20.gateDPlane++;
        ofs_18.gateCPlane++ <--> DistanceChannel {  distance = 711km; } <--> ofs_20.gateCPlane++;
        ofs_18.gateDPlane++ <--> DistanceChannel {  distance = 368km; } <--> ofs_27.gateDPlane++;
        ofs_18.gateCPlane++ <--> DistanceChannel {  distance = 368km; } <--> ofs_27.gateCPlane++;
        ofs_20.gateDPlane++ <--> DistanceChannel {  distance = 731km; } <--> ofs_21.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_21.gateDPlane++ <--> DistanceChannel {  distance = 614km; } <--> ofs_22.gateDPlane++;
        ofs_21.gateCPlane++ <--> DistanceChannel {  distance = 614km; } <--> ofs_22.gateCPlane++;
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 106km; } <--> ofs_23.gateDPlane++;
        ofs_22.gateCPlane++ <--> DistanceChannel {  distance = 106km; } <--> ofs_23.gateCPlane++;
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 52km; } <--> ofs_24.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_23.gateDPlane++ <--> DistanceChannel {  distance = 54km; } <--> ofs_24.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_24.gateDPlane++ <--> DistanceChannel {  distance = 476km; } <--> ofs_25.gateDPlane++;
        ofs_24.gateCPlane++ <--> DistanceChannel {  distance = 476km; } <--> ofs_25.gateCPlane++;
        ofs_25.gateDPlane++ <--> DistanceChannel {  distance = 555km; } <--> ofs_26.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_26.gateDPlane++ <--> DistanceChannel {  distance = 233km; } <--> ofs_27.gateDPlane++;
        // this edge is not part of the MST, skipping
        // placement 1, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 1);
        // placement 2, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 2);
        // placement 3, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 3);
        // placement 4, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 4);
        // placement 5, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 5);
        // placement 6, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 6);
        // placement 7, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 7);
        // placement 8, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 8);
        // placement 9, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 9);
        // placement 10, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 10);
        // placement 11, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 11);
        // placement 12, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 12);
        // placement 13, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 13);
        // placement 14, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 14);
        // placement 15, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_12.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 15);
        // placement 16, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 16);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 16);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 16);
        // placement 17, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 17);
        // placement 18, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 18);
        // placement 19, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 19);
        // placement 20, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 20);
        // placement 21, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 21);
        // placement 22, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 22);
        // placement 23, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 23);
        // placement 24, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 24);
        // placement 25, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 25);
        // placement 26, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 26);
        // placement 27, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_27.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 27);
        // placement 28, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 28);
        // placement 29, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 29);
        // placement 30, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 30);
        // placement 31, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 31);
        // placement 32, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 32);
        // placement 33, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 33);
        // placement 34, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 34);
        // placement 35, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 35);
        // placement 36, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 36);
        // placement 37, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 37);
        // placement 38, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 38);
        // placement 39, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 39);
        // placement 40, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 40);
        // placement 41, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 41);
        // placement 42, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 42);
        // placement 43, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 43);
        // placement 44, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 44);
        // placement 45, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 45);
        // placement 46, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 46);
        // placement 47, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 47);
        // placement 48, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 48);
        // placement 49, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 49);
        // placement 50, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 50);
        // placement 51, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 51);
        // placement 52, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 52);
        // placement 53, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 53);
        // placement 54, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 54);
        // placement 55, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 55);
        // placement 56, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 56);
        // placement 57, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 57);
}
