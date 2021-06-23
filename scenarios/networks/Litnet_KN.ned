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
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import openflow.nodes.DistanceChannel;
import openflow.nodes.Open_Flow_Domain;
import openflow.openflow.controller.Open_Flow_Controller;
import openflow.utility.ControllerInvolvementFilter;
import openflow.utility.OpenFlowGraphAnalyzer;
import openflow.utility.StaticSpanningTree;


network Scenario_Litnet_KN
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
        configurator: IPv4NetworkConfigurator {
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
            @display("p=620,124");
        }
        ofs_2: Open_Flow_Domain {
            @display("p=393,124");
        }
        ofs_3: Open_Flow_Domain {
            @display("p=540,75");
        }
        ofs_4: Open_Flow_Domain {
            @display("p=466,103");
        }
        ofs_5: Open_Flow_Domain {
            @display("p=223,145");
        }
        ofs_6: Open_Flow_Domain {
            @display("p=295,107");
        }
        ofs_7: Open_Flow_Domain {
            @display("p=93,87");
        }
        ofs_8: Open_Flow_Domain {
            @display("p=146,226");
        }
        ofs_9: Open_Flow_Domain {
            @display("p=76,203");
        }
        ofs_10: Open_Flow_Domain {
            @display("p=345,354");
        }
        ofs_11: Open_Flow_Domain {
            @display("p=462,354");
        }
        ofs_12: Open_Flow_Domain {
            @display("p=610,205");
        }
        ofs_13: Open_Flow_Domain {
            @display("p=441,226");
        }
        ofs_14: Open_Flow_Domain {
            @display("p=464,268");
        }
        ofs_15: Open_Flow_Domain {
            @display("p=203,262");
        }
        ofs_16: Open_Flow_Domain {
            @display("p=235,288");
        }
        ofs_17: Open_Flow_Domain {
            @display("p=235,350");
        }
        ofs_18: Open_Flow_Domain {
            @display("p=273,368");
        }
        ofs_19: Open_Flow_Domain {
            @display("p=357,402");
        }
        ofs_20: Open_Flow_Domain {
            @display("p=347,480");
        }
        ofs_21: Open_Flow_Domain {
            @display("p=516,422");
        }
        ofs_22: Open_Flow_Domain {
            @display("p=520,230");
        }
        ofs_23: Open_Flow_Domain {
            @display("p=640,153");
        }
        ofs_24: Open_Flow_Domain {
            @display("p=399,55");
        }
        ofs_25: Open_Flow_Domain {
            @display("p=339,299");
        }
        ofs_26: Open_Flow_Domain {
            @display("p=348,218");
        }
        ofs_27: Open_Flow_Domain {
            @display("p=246,200");
        }
        ofs_28: Open_Flow_Domain {
            @display("p=542,174");
        }
        ofs_29: Open_Flow_Domain {
            @display("p=483,168");
        }
        ofs_30: Open_Flow_Domain {
            @display("p=385,261");
        }
        ofs_31: Open_Flow_Domain {
            @display("p=504,342");
        }
        ofs_32: Open_Flow_Domain {
            @display("p=6,128");
        }
        ofs_33: Open_Flow_Domain {
            @display("p=141,72");
        }
        ofs_34: Open_Flow_Domain {
            @display("p=151,0");
        }
        ofs_35: Open_Flow_Domain {
            @display("p=305,16");
        }
        ofs_36: Open_Flow_Domain {
            @display("p=441,25");
        }
        ofs_37: Open_Flow_Domain {
            @display("p=269,82");
        }
        ofs_38: Open_Flow_Domain {
            @display("p=0,85");
        }
        ofs_39: Open_Flow_Domain {
            @display("p=22,94");
        }
    connections allowunconnected:

        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 119km; } <--> ofs_2.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 119km; } <--> ofs_2.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 130km; } <--> ofs_23.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 130km; } <--> ofs_23.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 53km; } <--> ofs_29.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 53km; } <--> ofs_29.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 130km; } <--> ofs_31.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 130km; } <--> ofs_31.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 58km; } <--> ofs_36.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 58km; } <--> ofs_36.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 68km; } <--> ofs_37.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 68km; } <--> ofs_37.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 141km; } <--> ofs_37.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 141km; } <--> ofs_37.gateCPlane++;
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 104km; } <--> ofs_37.gateDPlane++;
        ofs_4.gateCPlane++ <--> DistanceChannel {  distance = 104km; } <--> ofs_37.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 41km; } <--> ofs_37.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 41km; } <--> ofs_37.gateCPlane++;
        ofs_6.gateDPlane++ <--> DistanceChannel {  distance = 19km; } <--> ofs_37.gateDPlane++;
        ofs_6.gateCPlane++ <--> DistanceChannel {  distance = 19km; } <--> ofs_37.gateCPlane++;
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 92km; } <--> ofs_37.gateDPlane++;
        ofs_7.gateCPlane++ <--> DistanceChannel {  distance = 92km; } <--> ofs_37.gateCPlane++;
        ofs_8.gateDPlane++ <--> DistanceChannel {  distance = 90km; } <--> ofs_32.gateDPlane++;
        ofs_8.gateCPlane++ <--> DistanceChannel {  distance = 90km; } <--> ofs_32.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 54km; } <--> ofs_32.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 54km; } <--> ofs_32.gateCPlane++;
        ofs_10.gateDPlane++ <--> DistanceChannel {  distance = 30km; } <--> ofs_25.gateDPlane++;
        ofs_10.gateCPlane++ <--> DistanceChannel {  distance = 30km; } <--> ofs_25.gateCPlane++;
        ofs_11.gateDPlane++ <--> DistanceChannel {  distance = 23km; } <--> ofs_31.gateDPlane++;
        ofs_11.gateCPlane++ <--> DistanceChannel {  distance = 23km; } <--> ofs_31.gateCPlane++;
        ofs_12.gateDPlane++ <--> DistanceChannel {  distance = 93km; } <--> ofs_31.gateDPlane++;
        ofs_12.gateCPlane++ <--> DistanceChannel {  distance = 93km; } <--> ofs_31.gateCPlane++;
        ofs_13.gateDPlane++ <--> DistanceChannel {  distance = 71km; } <--> ofs_31.gateDPlane++;
        ofs_13.gateCPlane++ <--> DistanceChannel {  distance = 71km; } <--> ofs_31.gateCPlane++;
        ofs_14.gateDPlane++ <--> DistanceChannel {  distance = 45km; } <--> ofs_31.gateDPlane++;
        ofs_14.gateCPlane++ <--> DistanceChannel {  distance = 45km; } <--> ofs_31.gateCPlane++;
        ofs_15.gateDPlane++ <--> DistanceChannel {  distance = 75km; } <--> ofs_25.gateDPlane++;
        ofs_15.gateCPlane++ <--> DistanceChannel {  distance = 75km; } <--> ofs_25.gateCPlane++;
        ofs_16.gateDPlane++ <--> DistanceChannel {  distance = 56km; } <--> ofs_25.gateDPlane++;
        ofs_16.gateCPlane++ <--> DistanceChannel {  distance = 56km; } <--> ofs_25.gateCPlane++;
        ofs_17.gateDPlane++ <--> DistanceChannel {  distance = 62km; } <--> ofs_25.gateDPlane++;
        ofs_17.gateCPlane++ <--> DistanceChannel {  distance = 62km; } <--> ofs_25.gateCPlane++;
        ofs_18.gateDPlane++ <--> DistanceChannel {  distance = 51km; } <--> ofs_25.gateDPlane++;
        ofs_18.gateCPlane++ <--> DistanceChannel {  distance = 51km; } <--> ofs_25.gateCPlane++;
        ofs_19.gateDPlane++ <--> DistanceChannel {  distance = 56km; } <--> ofs_25.gateDPlane++;
        ofs_19.gateCPlane++ <--> DistanceChannel {  distance = 56km; } <--> ofs_25.gateCPlane++;
        ofs_20.gateDPlane++ <--> DistanceChannel {  distance = 113km; } <--> ofs_31.gateDPlane++;
        ofs_20.gateCPlane++ <--> DistanceChannel {  distance = 113km; } <--> ofs_31.gateCPlane++;
        ofs_21.gateDPlane++ <--> DistanceChannel {  distance = 117km; } <--> ofs_25.gateDPlane++;
        ofs_21.gateCPlane++ <--> DistanceChannel {  distance = 117km; } <--> ofs_25.gateCPlane++;
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 61km; } <--> ofs_31.gateDPlane++;
        ofs_22.gateCPlane++ <--> DistanceChannel {  distance = 61km; } <--> ofs_31.gateCPlane++;
        ofs_24.gateDPlane++ <--> DistanceChannel {  distance = 162km; } <--> ofs_31.gateDPlane++;
        ofs_24.gateCPlane++ <--> DistanceChannel {  distance = 162km; } <--> ofs_31.gateCPlane++;
        ofs_25.gateDPlane++ <--> DistanceChannel {  distance = 43km; } <--> ofs_26.gateDPlane++;
        ofs_25.gateCPlane++ <--> DistanceChannel {  distance = 43km; } <--> ofs_26.gateCPlane++;
        ofs_25.gateDPlane++ <--> DistanceChannel {  distance = 72km; } <--> ofs_27.gateDPlane++;
        ofs_25.gateCPlane++ <--> DistanceChannel {  distance = 72km; } <--> ofs_27.gateCPlane++;
        ofs_25.gateDPlane++ <--> DistanceChannel {  distance = 32km; } <--> ofs_30.gateDPlane++;
        ofs_25.gateCPlane++ <--> DistanceChannel {  distance = 32km; } <--> ofs_30.gateCPlane++;
        ofs_25.gateDPlane++ <--> DistanceChannel {  distance = 92km; } <--> ofs_31.gateDPlane++;
        ofs_25.gateCPlane++ <--> DistanceChannel {  distance = 92km; } <--> ofs_31.gateCPlane++;
        ofs_25.gateDPlane++ <--> DistanceChannel {  distance = 198km; } <--> ofs_32.gateDPlane++;
        ofs_25.gateCPlane++ <--> DistanceChannel {  distance = 198km; } <--> ofs_32.gateCPlane++;
        ofs_28.gateDPlane++ <--> DistanceChannel {  distance = 92km; } <--> ofs_31.gateDPlane++;
        ofs_28.gateCPlane++ <--> DistanceChannel {  distance = 92km; } <--> ofs_31.gateCPlane++;
        ofs_32.gateDPlane++ <--> DistanceChannel {  distance = 76km; } <--> ofs_33.gateDPlane++;
        ofs_32.gateCPlane++ <--> DistanceChannel {  distance = 76km; } <--> ofs_33.gateCPlane++;
        ofs_32.gateDPlane++ <--> DistanceChannel {  distance = 139km; } <--> ofs_37.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_32.gateDPlane++ <--> DistanceChannel {  distance = 22km; } <--> ofs_38.gateDPlane++;
        ofs_32.gateCPlane++ <--> DistanceChannel {  distance = 22km; } <--> ofs_38.gateCPlane++;
        ofs_32.gateDPlane++ <--> DistanceChannel {  distance = 20km; } <--> ofs_39.gateDPlane++;
        ofs_32.gateCPlane++ <--> DistanceChannel {  distance = 20km; } <--> ofs_39.gateCPlane++;
        ofs_34.gateDPlane++ <--> DistanceChannel {  distance = 74km; } <--> ofs_37.gateDPlane++;
        ofs_34.gateCPlane++ <--> DistanceChannel {  distance = 74km; } <--> ofs_37.gateCPlane++;
        ofs_35.gateDPlane++ <--> DistanceChannel {  distance = 39km; } <--> ofs_37.gateDPlane++;
        ofs_35.gateCPlane++ <--> DistanceChannel {  distance = 39km; } <--> ofs_37.gateCPlane++;
        // placement 1, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 1);
        // placement 2, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 2);
        // placement 3, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_36.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 3);
        // placement 4, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 4);
        // placement 5, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 5);
        // placement 6, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 6);
        // placement 7, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_14.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 7);
        // placement 8, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 8);
        // placement 9, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 9);
        // placement 10, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 10);
        // placement 11, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_31.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 11);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 11);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 11);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 11);
        // placement 12, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_32.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 12);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 12);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 12);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 12);
        // placement 13, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 13);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 13);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 13);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 13);
        // placement 14, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_37.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 14);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 14);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 14);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 14);
        // placement 15, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_37.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 15);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 15);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 15);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 15);
        // placement 16, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_37.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 16);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 16);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 16);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 16);
        // placement 17, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 17);
        // placement 18, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_31.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 18);
        // placement 19, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 19);
        // placement 20, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_31.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 20);
        // placement 21, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_32.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 21);
        // placement 22, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_37.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 22);
        // placement 23, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_32.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_38.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 23);
        // placement 24, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_37.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 24);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 24);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 24);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 24);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 24);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 24);
        // placement 25, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 25);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 25);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 25);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 25);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 25);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 25);
        // placement 26, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_37.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 26);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 26);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 26);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 26);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 26);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 26);
        // placement 27, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 27);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 27);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 27);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 27);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 27);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 27);
        // placement 28, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_37.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 28);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 28);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 28);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 28);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 28);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 28);
        // placement 29, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_37.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 29);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 29);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 29);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 29);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 29);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 29);
        // placement 30, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 30);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 30);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 30);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 30);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 30);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 30);
        // placement 31, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 31);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 31);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 31);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 31);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 31);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 31);
        // placement 32, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 32);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 32);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 32);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 32);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 32);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 32);
        // placement 33, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 33);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 33);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 33);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 33);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 33);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 33);
        // placement 34, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 34);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 34);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 34);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 34);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 34);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 34);
        // placement 35, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_36.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 35);
        // placement 36, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_37.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 36);
        // placement 37, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 37);
        // placement 38, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 38);
        // placement 39, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 39);
        // placement 40, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 40);
        // placement 41, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 41);
}
