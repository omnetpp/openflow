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
import openflow.hyperflow.Hyper_Flow_Synchronizer;
import openflow.nodes.DistanceChannel;
import openflow.nodes.Open_Flow_Domain;
import openflow.openflow.controller.Open_Flow_Controller;
import openflow.utility.ControllerInvolvementFilter;
import openflow.utility.OpenFlowGraphAnalyzer;
import openflow.utility.StaticSpanningTree;


network Scenario_Geant2001
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

        hf_synchronizer: Hyper_Flow_Synchronizer {
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
            @display("p=344,190");
        }
        ofs_2: Open_Flow_Domain {
            @display("p=242,246");
        }
        ofs_3: Open_Flow_Domain {
            @display("p=167,212");
        }
        ofs_4: Open_Flow_Domain {
            @display("p=329,145");
        }
        ofs_5: Open_Flow_Domain {
            @display("p=0,377");
        }
        ofs_6: Open_Flow_Domain {
            @display("p=383,225");
        }
        ofs_7: Open_Flow_Domain {
            @display("p=315,328");
        }
        ofs_8: Open_Flow_Domain {
            @display("p=79,351");
        }
        ofs_9: Open_Flow_Domain {
            @display("p=411,236");
        }
        ofs_10: Open_Flow_Domain {
            @display("p=342,222");
        }
        ofs_11: Open_Flow_Domain {
            @display("p=514,288");
        }
        ofs_12: Open_Flow_Domain {
            @display("p=473,316");
        }
        ofs_13: Open_Flow_Domain {
            @display("p=374,274");
        }
        ofs_14: Open_Flow_Domain {
            @display("p=345,261");
        }
        ofs_15: Open_Flow_Domain {
            @display("p=640,480");
        }
        ofs_16: Open_Flow_Domain {
            @display("p=620,429");
        }
        ofs_17: Open_Flow_Domain {
            @display("p=450,384");
        }
        ofs_18: Open_Flow_Domain {
            @display("p=197,176");
        }
        ofs_19: Open_Flow_Domain {
            @display("p=223,199");
        }
        ofs_20: Open_Flow_Domain {
            @display("p=42,129");
        }
        ofs_21: Open_Flow_Domain {
            @display("p=131,164");
        }
        ofs_22: Open_Flow_Domain {
            @display("p=397,2");
        }
        ofs_23: Open_Flow_Domain {
            @display("p=494,0");
        }
        ofs_24: Open_Flow_Domain {
            @display("p=485,55");
        }
        ofs_25: Open_Flow_Domain {
            @display("p=524,121");
        }
        ofs_26: Open_Flow_Domain {
            @display("p=381,147");
        }
        ofs_27: Open_Flow_Domain {
            @display("p=205,148");
        }
    connections allowunconnected:

        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 280km; } <--> ofs_4.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 280km; } <--> ofs_4.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 291km; } <--> ofs_6.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 291km; } <--> ofs_6.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 314km; } <--> ofs_26.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 314km; } <--> ofs_26.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 435km; } <--> ofs_3.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 435km; } <--> ofs_3.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 689km; } <--> ofs_7.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 689km; } <--> ofs_7.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 534km; } <--> ofs_10.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 534km; } <--> ofs_10.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 878km; } <--> ofs_4.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 878km; } <--> ofs_4.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 1052km; } <--> ofs_8.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 1052km; } <--> ofs_8.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 264km; } <--> ofs_18.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 264km; } <--> ofs_18.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 287km; } <--> ofs_19.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 287km; } <--> ofs_19.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 344km; } <--> ofs_21.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 344km; } <--> ofs_21.gateCPlane++;
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 1184km; } <--> ofs_7.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 473km; } <--> ofs_10.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 1713km; } <--> ofs_17.gateDPlane++;
        ofs_4.gateCPlane++ <--> DistanceChannel {  distance = 1713km; } <--> ofs_17.gateCPlane++;
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 1318km; } <--> ofs_20.gateDPlane++;
        ofs_4.gateCPlane++ <--> DistanceChannel {  distance = 1318km; } <--> ofs_20.gateCPlane++;
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 810km; } <--> ofs_22.gateDPlane++;
        ofs_4.gateCPlane++ <--> DistanceChannel {  distance = 810km; } <--> ofs_22.gateCPlane++;
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 577km; } <--> ofs_27.gateDPlane++;
        ofs_4.gateCPlane++ <--> DistanceChannel {  distance = 577km; } <--> ofs_27.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 502km; } <--> ofs_8.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 502km; } <--> ofs_8.gateCPlane++;
        ofs_6.gateDPlane++ <--> DistanceChannel {  distance = 161km; } <--> ofs_9.gateDPlane++;
        ofs_6.gateCPlane++ <--> DistanceChannel {  distance = 161km; } <--> ofs_9.gateCPlane++;
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 1363km; } <--> ofs_8.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 366km; } <--> ofs_10.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 643km; } <--> ofs_11.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 643km; } <--> ofs_11.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 381km; } <--> ofs_14.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 381km; } <--> ofs_14.gateCPlane++;
        ofs_10.gateDPlane++ <--> DistanceChannel {  distance = 382km; } <--> ofs_13.gateDPlane++;
        ofs_10.gateCPlane++ <--> DistanceChannel {  distance = 382km; } <--> ofs_13.gateCPlane++;
        ofs_10.gateDPlane++ <--> DistanceChannel {  distance = 251km; } <--> ofs_14.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_12.gateDPlane++ <--> DistanceChannel {  distance = 513km; } <--> ofs_17.gateDPlane++;
        ofs_12.gateCPlane++ <--> DistanceChannel {  distance = 513km; } <--> ofs_17.gateCPlane++;
        ofs_15.gateDPlane++ <--> DistanceChannel {  distance = 3603km; } <--> ofs_21.gateDPlane++;
        ofs_15.gateCPlane++ <--> DistanceChannel {  distance = 3603km; } <--> ofs_21.gateCPlane++;
        ofs_16.gateDPlane++ <--> DistanceChannel {  distance = 1091km; } <--> ofs_17.gateDPlane++;
        ofs_16.gateCPlane++ <--> DistanceChannel {  distance = 1091km; } <--> ofs_17.gateCPlane++;
        ofs_17.gateDPlane++ <--> DistanceChannel {  distance = 2252km; } <--> ofs_21.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_18.gateDPlane++ <--> DistanceChannel {  distance = 187km; } <--> ofs_19.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_18.gateDPlane++ <--> DistanceChannel {  distance = 173km; } <--> ofs_27.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_20.gateDPlane++ <--> DistanceChannel {  distance = 464km; } <--> ofs_21.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_21.gateDPlane++ <--> DistanceChannel {  distance = 1433km; } <--> ofs_22.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_21.gateDPlane++ <--> DistanceChannel {  distance = 357km; } <--> ofs_27.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 379km; } <--> ofs_23.gateDPlane++;
        ofs_22.gateCPlane++ <--> DistanceChannel {  distance = 379km; } <--> ofs_23.gateCPlane++;
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 443km; } <--> ofs_24.gateDPlane++;
        ofs_22.gateCPlane++ <--> DistanceChannel {  distance = 443km; } <--> ofs_24.gateCPlane++;
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 817km; } <--> ofs_25.gateDPlane++;
        ofs_22.gateCPlane++ <--> DistanceChannel {  distance = 817km; } <--> ofs_25.gateCPlane++;
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 772km; } <--> ofs_26.gateDPlane++;
        // this edge is not part of the MST, skipping
        // placement 1, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 1);
        // placement 2, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 2);
        // placement 3, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 3);
        // placement 4, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 4);
        // placement 5, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 5);
        // placement 6, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 6);
        // placement 7, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 7);
        // placement 8, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 8);
        // placement 9, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 9);
        // placement 10, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 10);
        // placement 11, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 11);
        // placement 12, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 12);
        // placement 13, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 13);
        // placement 14, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 14);
        // placement 15, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_15.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 15);
        // placement 16, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_15.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 16);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 16);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 16);
        // placement 17, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_18.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 17);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 17);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 17);
        // placement 18, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 18);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 18);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 18);
        // placement 19, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 19);
        // placement 20, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 20);
        // placement 21, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 21);
        // placement 22, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 22);
        // placement 23, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_27.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 23);
        // placement 24, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 24);
        // placement 25, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 25);
        // placement 26, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_27.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 26);
        // placement 27, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_18.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 27);
        // placement 28, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_18.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 28);
        // placement 29, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_18.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 29);
        // placement 30, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 30);
        // placement 31, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 31);
        // placement 32, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 32);
        // placement 33, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 33);
        // placement 34, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 34);
        // placement 35, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 35);
        // placement 36, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 36);
        // placement 37, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_18.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 37);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 37);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 37);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 37);
        // placement 38, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 38);
        // placement 39, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 39);
        // placement 40, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 40);
        // placement 41, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_9.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 41);
        // placement 42, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 42);
        // placement 43, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 43);
        // placement 44, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 44);
        // placement 45, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_18.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 45);
        // placement 46, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 46);
        // placement 47, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 47);
        // placement 48, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 48);
        // placement 49, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 49);
        // placement 50, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 50);
        // placement 51, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 51);
        // placement 52, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 52);
        // placement 53, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 53);
        // placement 54, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_18.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 54);
        // placement 55, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 55);
        // placement 56, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 56);
        // placement 57, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 57);
        // placement 58, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 58);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 58);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 58);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 58);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 58);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 58);
}
