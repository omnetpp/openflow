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


network Scenario_Sanet_KN
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
            @display("p=272,0");
        }
        ofs_2: Open_Flow_Domain {
            @display("p=260,152");
        }
        ofs_3: Open_Flow_Domain {
            @display("p=192,109");
        }
        ofs_4: Open_Flow_Domain {
            @display("p=226,30");
        }
        ofs_5: Open_Flow_Domain {
            @display("p=295,52");
        }
        ofs_6: Open_Flow_Domain {
            @display("p=339,47");
        }
        ofs_7: Open_Flow_Domain {
            @display("p=318,212");
        }
        ofs_8: Open_Flow_Domain {
            @display("p=320,163");
        }
        ofs_9: Open_Flow_Domain {
            @display("p=374,47");
        }
        ofs_10: Open_Flow_Domain {
            @display("p=450,19");
        }
        ofs_11: Open_Flow_Domain {
            @display("p=208,218");
        }
        ofs_12: Open_Flow_Domain {
            @display("p=256,332");
        }
        ofs_13: Open_Flow_Domain {
            @display("p=206,408");
        }
        ofs_14: Open_Flow_Domain {
            @display("p=174,354");
        }
        ofs_15: Open_Flow_Domain {
            @display("p=379,294");
        }
        ofs_16: Open_Flow_Domain {
            @display("p=421,278");
        }
        ofs_17: Open_Flow_Domain {
            @display("p=640,157");
        }
        ofs_18: Open_Flow_Domain {
            @display("p=638,96");
        }
        ofs_19: Open_Flow_Domain {
            @display("p=561,74");
        }
        ofs_20: Open_Flow_Domain {
            @display("p=452,58");
        }
        ofs_21: Open_Flow_Domain {
            @display("p=483,91");
        }
        ofs_22: Open_Flow_Domain {
            @display("p=479,185");
        }
        ofs_23: Open_Flow_Domain {
            @display("p=561,168");
        }
        ofs_24: Open_Flow_Domain {
            @display("p=615,196");
        }
        ofs_25: Open_Flow_Domain {
            @display("p=168,207");
        }
        ofs_26: Open_Flow_Domain {
            @display("p=168,155");
        }
        ofs_27: Open_Flow_Domain {
            @display("p=27,9");
        }
        ofs_28: Open_Flow_Domain {
            @display("p=0,335");
        }
        ofs_29: Open_Flow_Domain {
            @display("p=85,355");
        }
        ofs_30: Open_Flow_Domain {
            @display("p=141,283");
        }
        ofs_31: Open_Flow_Domain {
            @display("p=201,480");
        }
        ofs_32: Open_Flow_Domain {
            @display("p=209,446");
        }
        ofs_33: Open_Flow_Domain {
            @display("p=197,303");
        }
    connections allowunconnected:

        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 31km; } <--> ofs_4.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 31km; } <--> ofs_4.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 22km; } <--> ofs_5.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 22km; } <--> ofs_5.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 42km; } <--> ofs_7.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 42km; } <--> ofs_7.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 40km; } <--> ofs_11.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 40km; } <--> ofs_11.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 34km; } <--> ofs_4.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 34km; } <--> ofs_4.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 22km; } <--> ofs_26.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 22km; } <--> ofs_26.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 28km; } <--> ofs_6.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 28km; } <--> ofs_6.gateCPlane++;
        ofs_6.gateDPlane++ <--> DistanceChannel {  distance = 41km; } <--> ofs_8.gateDPlane++;
        ofs_6.gateCPlane++ <--> DistanceChannel {  distance = 41km; } <--> ofs_8.gateCPlane++;
        ofs_6.gateDPlane++ <--> DistanceChannel {  distance = 22km; } <--> ofs_9.gateDPlane++;
        ofs_6.gateCPlane++ <--> DistanceChannel {  distance = 22km; } <--> ofs_9.gateCPlane++;
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 17km; } <--> ofs_8.gateDPlane++;
        ofs_7.gateCPlane++ <--> DistanceChannel {  distance = 17km; } <--> ofs_8.gateCPlane++;
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 57km; } <--> ofs_12.gateDPlane++;
        ofs_7.gateCPlane++ <--> DistanceChannel {  distance = 57km; } <--> ofs_12.gateCPlane++;
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 48km; } <--> ofs_15.gateDPlane++;
        ofs_7.gateCPlane++ <--> DistanceChannel {  distance = 48km; } <--> ofs_15.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 49km; } <--> ofs_20.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 49km; } <--> ofs_20.gateCPlane++;
        ofs_10.gateDPlane++ <--> DistanceChannel {  distance = 13km; } <--> ofs_20.gateDPlane++;
        ofs_10.gateCPlane++ <--> DistanceChannel {  distance = 13km; } <--> ofs_20.gateCPlane++;
        ofs_11.gateDPlane++ <--> DistanceChannel {  distance = 30km; } <--> ofs_33.gateDPlane++;
        ofs_11.gateCPlane++ <--> DistanceChannel {  distance = 30km; } <--> ofs_33.gateCPlane++;
        ofs_12.gateDPlane++ <--> DistanceChannel {  distance = 41km; } <--> ofs_13.gateDPlane++;
        ofs_12.gateCPlane++ <--> DistanceChannel {  distance = 41km; } <--> ofs_13.gateCPlane++;
        ofs_13.gateDPlane++ <--> DistanceChannel {  distance = 28km; } <--> ofs_14.gateDPlane++;
        ofs_13.gateCPlane++ <--> DistanceChannel {  distance = 28km; } <--> ofs_14.gateCPlane++;
        ofs_14.gateDPlane++ <--> DistanceChannel {  distance = 58km; } <--> ofs_29.gateDPlane++;
        ofs_14.gateCPlane++ <--> DistanceChannel {  distance = 58km; } <--> ofs_29.gateCPlane++;
        ofs_15.gateDPlane++ <--> DistanceChannel {  distance = 28km; } <--> ofs_16.gateDPlane++;
        ofs_15.gateCPlane++ <--> DistanceChannel {  distance = 28km; } <--> ofs_16.gateCPlane++;
        ofs_16.gateDPlane++ <--> DistanceChannel {  distance = 48km; } <--> ofs_22.gateDPlane++;
        ofs_16.gateCPlane++ <--> DistanceChannel {  distance = 48km; } <--> ofs_22.gateCPlane++;
        ofs_17.gateDPlane++ <--> DistanceChannel {  distance = 20km; } <--> ofs_18.gateDPlane++;
        ofs_17.gateCPlane++ <--> DistanceChannel {  distance = 20km; } <--> ofs_18.gateCPlane++;
        ofs_17.gateDPlane++ <--> DistanceChannel {  distance = 21km; } <--> ofs_24.gateDPlane++;
        ofs_17.gateCPlane++ <--> DistanceChannel {  distance = 21km; } <--> ofs_24.gateCPlane++;
        ofs_19.gateDPlane++ <--> DistanceChannel {  distance = 50km; } <--> ofs_21.gateDPlane++;
        ofs_19.gateCPlane++ <--> DistanceChannel {  distance = 50km; } <--> ofs_21.gateCPlane++;
        ofs_19.gateDPlane++ <--> DistanceChannel {  distance = 32km; } <--> ofs_23.gateDPlane++;
        ofs_19.gateCPlane++ <--> DistanceChannel {  distance = 32km; } <--> ofs_23.gateCPlane++;
        ofs_20.gateDPlane++ <--> DistanceChannel {  distance = 22km; } <--> ofs_21.gateDPlane++;
        ofs_20.gateCPlane++ <--> DistanceChannel {  distance = 22km; } <--> ofs_21.gateCPlane++;
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 53km; } <--> ofs_23.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_23.gateDPlane++ <--> DistanceChannel {  distance = 35km; } <--> ofs_24.gateDPlane++;
        ofs_23.gateCPlane++ <--> DistanceChannel {  distance = 35km; } <--> ofs_24.gateCPlane++;
        ofs_25.gateDPlane++ <--> DistanceChannel {  distance = 18km; } <--> ofs_26.gateDPlane++;
        ofs_25.gateCPlane++ <--> DistanceChannel {  distance = 18km; } <--> ofs_26.gateCPlane++;
        ofs_25.gateDPlane++ <--> DistanceChannel {  distance = 31km; } <--> ofs_30.gateDPlane++;
        ofs_25.gateCPlane++ <--> DistanceChannel {  distance = 31km; } <--> ofs_30.gateCPlane++;
        ofs_27.gateDPlane++ <--> DistanceChannel {  distance = 122km; } <--> ofs_29.gateDPlane++;
        ofs_27.gateCPlane++ <--> DistanceChannel {  distance = 122km; } <--> ofs_29.gateCPlane++;
        ofs_28.gateDPlane++ <--> DistanceChannel {  distance = 55km; } <--> ofs_29.gateDPlane++;
        ofs_28.gateCPlane++ <--> DistanceChannel {  distance = 55km; } <--> ofs_29.gateCPlane++;
        ofs_29.gateDPlane++ <--> DistanceChannel {  distance = 44km; } <--> ofs_30.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_30.gateDPlane++ <--> DistanceChannel {  distance = 36km; } <--> ofs_33.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_31.gateDPlane++ <--> DistanceChannel {  distance = 13km; } <--> ofs_32.gateDPlane++;
        ofs_31.gateCPlane++ <--> DistanceChannel {  distance = 13km; } <--> ofs_32.gateCPlane++;
        ofs_32.gateDPlane++ <--> DistanceChannel {  distance = 49km; } <--> ofs_33.gateDPlane++;
        ofs_32.gateCPlane++ <--> DistanceChannel {  distance = 49km; } <--> ofs_33.gateCPlane++;
        // placement 1, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 1);
        // placement 2, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 2);
        // placement 3, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 3);
        // placement 4, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 4);
        // placement 5, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 5);
        // placement 6, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 6);
        // placement 7, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 7);
        // placement 8, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 8);
        // placement 9, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 9);
        // placement 10, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 10);
        // placement 11, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 11);
        // placement 12, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 12);
        // placement 13, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 13);
        // placement 14, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 14);
        // placement 15, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 15);
        // placement 16, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 16);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 16);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 16);
        // placement 17, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_31.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 17);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 17);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 17);
        // placement 18, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 18);
        // placement 19, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 19);
        // placement 20, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 20);
        // placement 21, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 21);
        // placement 22, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 22);
        // placement 23, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 23);
        // placement 24, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 24);
        // placement 25, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 25);
        // placement 26, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 26);
        // placement 27, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 27);
        // placement 28, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 28);
        // placement 29, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 29);
        // placement 30, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 30);
        // placement 31, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 31);
        // placement 32, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 32);
        // placement 33, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 33);
        // placement 34, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 34);
        // placement 35, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_20.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 35);
        // placement 36, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 36);
        // placement 37, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 37);
        // placement 38, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 38);
        // placement 39, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 39);
        // placement 40, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 40);
        // placement 41, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 41);
        // placement 42, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 42);
        // placement 43, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 43);
        // placement 44, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 44);
        // placement 45, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 45);
        // placement 46, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 46);
        // placement 47, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 47);
        // placement 48, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 48);
        // placement 49, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 49);
        // placement 50, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_26.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 50);
        // placement 51, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 51);
        // placement 52, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 52);
        // placement 53, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 53);
        // placement 54, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 54);
        // placement 55, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 55);
        // placement 56, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 56);
        // placement 57, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 57);
}
