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


network Scenario_Roedunet_KN
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
            @display("p=217,429");
        }
        ofs_2: Open_Flow_Domain {
            @display("p=265,415");
        }
        ofs_3: Open_Flow_Domain {
            @display("p=174,341");
        }
        ofs_4: Open_Flow_Domain {
            @display("p=265,334");
        }
        ofs_5: Open_Flow_Domain {
            @display("p=412,415");
        }
        ofs_6: Open_Flow_Domain {
            @display("p=457,381");
        }
        ofs_7: Open_Flow_Domain {
            @display("p=347,468");
        }
        ofs_8: Open_Flow_Domain {
            @display("p=401,480");
        }
        ofs_9: Open_Flow_Domain {
            @display("p=516,442");
        }
        ofs_10: Open_Flow_Domain {
            @display("p=627,444");
        }
        ofs_11: Open_Flow_Domain {
            @display("p=419,243");
        }
        ofs_12: Open_Flow_Domain {
            @display("p=247,249");
        }
        ofs_13: Open_Flow_Domain {
            @display("p=199,217");
        }
        ofs_14: Open_Flow_Domain {
            @display("p=308,365");
        }
        ofs_15: Open_Flow_Domain {
            @display("p=357,355");
        }
        ofs_16: Open_Flow_Domain {
            @display("p=405,353");
        }
        ofs_17: Open_Flow_Domain {
            @display("p=474,328");
        }
        ofs_18: Open_Flow_Domain {
            @display("p=503,262");
        }
        ofs_19: Open_Flow_Domain {
            @display("p=479,155");
        }
        ofs_20: Open_Flow_Domain {
            @display("p=344,188");
        }
        ofs_21: Open_Flow_Domain {
            @display("p=281,158");
        }
        ofs_22: Open_Flow_Domain {
            @display("p=277,84");
        }
        ofs_23: Open_Flow_Domain {
            @display("p=550,147");
        }
        ofs_24: Open_Flow_Domain {
            @display("p=577,292");
        }
        ofs_25: Open_Flow_Domain {
            @display("p=640,326");
        }
        ofs_26: Open_Flow_Domain {
            @display("p=571,314");
        }
        ofs_27: Open_Flow_Domain {
            @display("p=432,111");
        }
        ofs_28: Open_Flow_Domain {
            @display("p=424,21");
        }
        ofs_29: Open_Flow_Domain {
            @display("p=460,6");
        }
        ofs_30: Open_Flow_Domain {
            @display("p=539,80");
        }
        ofs_31: Open_Flow_Domain {
            @display("p=56,310");
        }
        ofs_32: Open_Flow_Domain {
            @display("p=121,391");
        }
        ofs_33: Open_Flow_Domain {
            @display("p=140,0");
        }
        ofs_34: Open_Flow_Domain {
            @display("p=198,18");
        }
        ofs_35: Open_Flow_Domain {
            @display("p=201,130");
        }
        ofs_36: Open_Flow_Domain {
            @display("p=154,76");
        }
        ofs_37: Open_Flow_Domain {
            @display("p=60,93");
        }
        ofs_38: Open_Flow_Domain {
            @display("p=8,202");
        }
        ofs_39: Open_Flow_Domain {
            @display("p=0,256");
        }
        ofs_40: Open_Flow_Domain {
            @display("p=141,255");
        }
    connections allowunconnected:

        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 47km; } <--> ofs_2.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 47km; } <--> ofs_2.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 91km; } <--> ofs_3.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 91km; } <--> ofs_3.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 98km; } <--> ofs_4.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 98km; } <--> ofs_4.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 184km; } <--> ofs_5.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 184km; } <--> ofs_5.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 97km; } <--> ofs_32.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 97km; } <--> ofs_32.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 257km; } <--> ofs_39.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 257km; } <--> ofs_39.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 52km; } <--> ofs_6.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 52km; } <--> ofs_6.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 79km; } <--> ofs_7.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 79km; } <--> ofs_7.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 62km; } <--> ofs_8.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 62km; } <--> ofs_8.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 101km; } <--> ofs_9.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 101km; } <--> ofs_9.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 204km; } <--> ofs_10.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 204km; } <--> ofs_10.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 109km; } <--> ofs_14.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 109km; } <--> ofs_14.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 76km; } <--> ofs_15.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 76km; } <--> ofs_15.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 58km; } <--> ofs_16.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 58km; } <--> ofs_16.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 98km; } <--> ofs_17.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 98km; } <--> ofs_17.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 264km; } <--> ofs_21.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 264km; } <--> ofs_21.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 190km; } <--> ofs_24.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 190km; } <--> ofs_24.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 325km; } <--> ofs_30.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 325km; } <--> ofs_30.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 325km; } <--> ofs_35.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 325km; } <--> ofs_35.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 410km; } <--> ofs_39.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_11.gateDPlane++ <--> DistanceChannel {  distance = 147km; } <--> ofs_21.gateDPlane++;
        ofs_11.gateCPlane++ <--> DistanceChannel {  distance = 147km; } <--> ofs_21.gateCPlane++;
        ofs_12.gateDPlane++ <--> DistanceChannel {  distance = 88km; } <--> ofs_21.gateDPlane++;
        ofs_12.gateCPlane++ <--> DistanceChannel {  distance = 88km; } <--> ofs_21.gateCPlane++;
        ofs_13.gateDPlane++ <--> DistanceChannel {  distance = 78km; } <--> ofs_35.gateDPlane++;
        ofs_13.gateCPlane++ <--> DistanceChannel {  distance = 78km; } <--> ofs_35.gateCPlane++;
        ofs_18.gateDPlane++ <--> DistanceChannel {  distance = 73km; } <--> ofs_24.gateDPlane++;
        ofs_18.gateCPlane++ <--> DistanceChannel {  distance = 73km; } <--> ofs_24.gateCPlane++;
        ofs_19.gateDPlane++ <--> DistanceChannel {  distance = 85km; } <--> ofs_30.gateDPlane++;
        ofs_19.gateCPlane++ <--> DistanceChannel {  distance = 85km; } <--> ofs_30.gateCPlane++;
        ofs_20.gateDPlane++ <--> DistanceChannel {  distance = 63km; } <--> ofs_21.gateDPlane++;
        ofs_20.gateCPlane++ <--> DistanceChannel {  distance = 63km; } <--> ofs_21.gateCPlane++;
        ofs_21.gateDPlane++ <--> DistanceChannel {  distance = 242km; } <--> ofs_30.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_21.gateDPlane++ <--> DistanceChannel {  distance = 77km; } <--> ofs_35.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 80km; } <--> ofs_35.gateDPlane++;
        ofs_22.gateCPlane++ <--> DistanceChannel {  distance = 80km; } <--> ofs_35.gateCPlane++;
        ofs_23.gateDPlane++ <--> DistanceChannel {  distance = 60km; } <--> ofs_30.gateDPlane++;
        ofs_23.gateCPlane++ <--> DistanceChannel {  distance = 60km; } <--> ofs_30.gateCPlane++;
        ofs_24.gateDPlane++ <--> DistanceChannel {  distance = 67km; } <--> ofs_25.gateDPlane++;
        ofs_24.gateCPlane++ <--> DistanceChannel {  distance = 67km; } <--> ofs_25.gateCPlane++;
        ofs_24.gateDPlane++ <--> DistanceChannel {  distance = 21km; } <--> ofs_26.gateDPlane++;
        ofs_24.gateCPlane++ <--> DistanceChannel {  distance = 21km; } <--> ofs_26.gateCPlane++;
        ofs_24.gateDPlane++ <--> DistanceChannel {  distance = 194km; } <--> ofs_30.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_27.gateDPlane++ <--> DistanceChannel {  distance = 100km; } <--> ofs_30.gateDPlane++;
        ofs_27.gateCPlane++ <--> DistanceChannel {  distance = 100km; } <--> ofs_30.gateCPlane++;
        ofs_28.gateDPlane++ <--> DistanceChannel {  distance = 114km; } <--> ofs_30.gateDPlane++;
        ofs_28.gateCPlane++ <--> DistanceChannel {  distance = 114km; } <--> ofs_30.gateCPlane++;
        ofs_29.gateDPlane++ <--> DistanceChannel {  distance = 96km; } <--> ofs_30.gateDPlane++;
        ofs_29.gateCPlane++ <--> DistanceChannel {  distance = 96km; } <--> ofs_30.gateCPlane++;
        ofs_31.gateDPlane++ <--> DistanceChannel {  distance = 72km; } <--> ofs_39.gateDPlane++;
        ofs_31.gateCPlane++ <--> DistanceChannel {  distance = 72km; } <--> ofs_39.gateCPlane++;
        ofs_33.gateDPlane++ <--> DistanceChannel {  distance = 127km; } <--> ofs_35.gateDPlane++;
        ofs_33.gateCPlane++ <--> DistanceChannel {  distance = 127km; } <--> ofs_35.gateCPlane++;
        ofs_34.gateDPlane++ <--> DistanceChannel {  distance = 99km; } <--> ofs_35.gateDPlane++;
        ofs_34.gateCPlane++ <--> DistanceChannel {  distance = 99km; } <--> ofs_35.gateCPlane++;
        ofs_35.gateDPlane++ <--> DistanceChannel {  distance = 64km; } <--> ofs_36.gateDPlane++;
        ofs_35.gateCPlane++ <--> DistanceChannel {  distance = 64km; } <--> ofs_36.gateCPlane++;
        ofs_35.gateDPlane++ <--> DistanceChannel {  distance = 215km; } <--> ofs_39.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_37.gateDPlane++ <--> DistanceChannel {  distance = 156km; } <--> ofs_39.gateDPlane++;
        ofs_37.gateCPlane++ <--> DistanceChannel {  distance = 156km; } <--> ofs_39.gateCPlane++;
        ofs_38.gateDPlane++ <--> DistanceChannel {  distance = 49km; } <--> ofs_39.gateDPlane++;
        ofs_38.gateCPlane++ <--> DistanceChannel {  distance = 49km; } <--> ofs_39.gateCPlane++;
        ofs_39.gateDPlane++ <--> DistanceChannel {  distance = 130km; } <--> ofs_40.gateDPlane++;
        ofs_39.gateCPlane++ <--> DistanceChannel {  distance = 130km; } <--> ofs_40.gateCPlane++;
        // placement 1, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 1);
        // placement 2, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 2);
        // placement 3, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 3);
        // placement 4, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 4);
        // placement 5, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 5);
        // placement 6, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 6);
        // placement 7, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 7);
        // placement 8, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 8);
        // placement 9, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 9);
        // placement 10, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 10);
        // placement 11, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 11);
        // placement 12, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 12);
        // placement 13, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 13);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 13);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 13);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 13);
        // placement 14, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 14);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 14);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 14);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 14);
        // placement 15, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 15);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 15);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 15);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 15);
        // placement 16, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 16);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 16);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 16);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 16);
        // placement 17, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 17);
        // placement 18, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 18);
        // placement 19, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 19);
        // placement 20, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 20);
        // placement 21, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 21);
        // placement 22, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 22);
        // placement 23, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 23);
        // placement 24, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 24);
        // placement 25, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 25);
        // placement 26, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 26);
        // placement 27, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 27);
        // placement 28, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 28);
        // placement 29, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 29);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 29);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 29);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 29);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 29);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 29);
        // placement 30, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 30);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 30);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 30);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 30);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 30);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 30);
        // placement 31, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 31);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 31);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 31);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 31);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 31);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 31);
        // placement 32, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 32);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 32);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 32);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 32);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 32);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 32);
        // placement 33, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 33);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 33);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 33);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 33);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 33);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 33);
        // placement 34, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 34);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 34);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 34);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 34);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 34);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 34);
        // placement 35, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 35);
        // placement 36, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 36);
        // placement 37, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 37);
        // placement 38, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 38);
        // placement 39, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 39);
        // placement 40, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 40);
        // placement 41, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 41);
        // placement 42, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 42);
        // placement 43, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_35.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_39.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 43);
}
