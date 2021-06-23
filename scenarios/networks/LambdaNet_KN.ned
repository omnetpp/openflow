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


network Scenario_LambdaNet_KN
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
            @display("p=467,175");
        }
        ofs_2: Open_Flow_Domain {
            @display("p=372,167");
        }
        ofs_3: Open_Flow_Domain {
            @display("p=613,146");
        }
        ofs_4: Open_Flow_Domain {
            @display("p=526,240");
        }
        ofs_5: Open_Flow_Domain {
            @display("p=640,262");
        }
        ofs_6: Open_Flow_Domain {
            @display("p=414,267");
        }
        ofs_7: Open_Flow_Domain {
            @display("p=408,322");
        }
        ofs_8: Open_Flow_Domain {
            @display("p=417,384");
        }
        ofs_9: Open_Flow_Domain {
            @display("p=33,281");
        }
        ofs_10: Open_Flow_Domain {
            @display("p=58,249");
        }
        ofs_11: Open_Flow_Domain {
            @display("p=72,271");
        }
        ofs_12: Open_Flow_Domain {
            @display("p=85,286");
        }
        ofs_13: Open_Flow_Domain {
            @display("p=78,231");
        }
        ofs_14: Open_Flow_Domain {
            @display("p=216,334");
        }
        ofs_15: Open_Flow_Domain {
            @display("p=401,463");
        }
        ofs_16: Open_Flow_Domain {
            @display("p=0,283");
        }
        ofs_17: Open_Flow_Domain {
            @display("p=192,416");
        }
        ofs_18: Open_Flow_Domain {
            @display("p=259,433");
        }
        ofs_19: Open_Flow_Domain {
            @display("p=447,434");
        }
        ofs_20: Open_Flow_Domain {
            @display("p=459,480");
        }
        ofs_21: Open_Flow_Domain {
            @display("p=322,358");
        }
        ofs_22: Open_Flow_Domain {
            @display("p=217,333");
        }
        ofs_23: Open_Flow_Domain {
            @display("p=199,380");
        }
        ofs_24: Open_Flow_Domain {
            @display("p=339,0");
        }
        ofs_25: Open_Flow_Domain {
            @display("p=73,270");
        }
        ofs_26: Open_Flow_Domain {
            @display("p=114,226");
        }
        ofs_27: Open_Flow_Domain {
            @display("p=192,196");
        }
        ofs_28: Open_Flow_Domain {
            @display("p=205,185");
        }
        ofs_29: Open_Flow_Domain {
            @display("p=217,177");
        }
        ofs_30: Open_Flow_Domain {
            @display("p=228,102");
        }
        ofs_31: Open_Flow_Domain {
            @display("p=305,159");
        }
        ofs_32: Open_Flow_Domain {
            @display("p=327,64");
        }
    connections allowunconnected:

        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 78km; } <--> ofs_2.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 78km; } <--> ofs_2.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 125km; } <--> ofs_3.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 125km; } <--> ofs_3.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 56km; } <--> ofs_31.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 56km; } <--> ofs_31.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 165km; } <--> ofs_5.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 165km; } <--> ofs_5.gateCPlane++;
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 101km; } <--> ofs_5.gateDPlane++;
        ofs_4.gateCPlane++ <--> DistanceChannel {  distance = 101km; } <--> ofs_5.gateCPlane++;
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 101km; } <--> ofs_6.gateDPlane++;
        ofs_4.gateCPlane++ <--> DistanceChannel {  distance = 101km; } <--> ofs_6.gateCPlane++;
        ofs_6.gateDPlane++ <--> DistanceChannel {  distance = 80km; } <--> ofs_7.gateDPlane++;
        ofs_6.gateCPlane++ <--> DistanceChannel {  distance = 80km; } <--> ofs_7.gateCPlane++;
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 91km; } <--> ofs_8.gateDPlane++;
        ofs_7.gateCPlane++ <--> DistanceChannel {  distance = 91km; } <--> ofs_8.gateCPlane++;
        ofs_8.gateDPlane++ <--> DistanceChannel {  distance = 80km; } <--> ofs_19.gateDPlane++;
        ofs_8.gateCPlane++ <--> DistanceChannel {  distance = 80km; } <--> ofs_19.gateCPlane++;
        ofs_8.gateDPlane++ <--> DistanceChannel {  distance = 90km; } <--> ofs_21.gateDPlane++;
        ofs_8.gateCPlane++ <--> DistanceChannel {  distance = 90km; } <--> ofs_21.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 51km; } <--> ofs_10.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 51km; } <--> ofs_10.gateCPlane++;
        ofs_10.gateDPlane++ <--> DistanceChannel {  distance = 34km; } <--> ofs_11.gateDPlane++;
        ofs_10.gateCPlane++ <--> DistanceChannel {  distance = 34km; } <--> ofs_11.gateCPlane++;
        ofs_10.gateDPlane++ <--> DistanceChannel {  distance = 30km; } <--> ofs_13.gateDPlane++;
        ofs_10.gateCPlane++ <--> DistanceChannel {  distance = 30km; } <--> ofs_13.gateCPlane++;
        ofs_10.gateDPlane++ <--> DistanceChannel {  distance = 69km; } <--> ofs_16.gateDPlane++;
        ofs_10.gateCPlane++ <--> DistanceChannel {  distance = 69km; } <--> ofs_16.gateCPlane++;
        ofs_10.gateDPlane++ <--> DistanceChannel {  distance = 33km; } <--> ofs_25.gateDPlane++;
        ofs_10.gateCPlane++ <--> DistanceChannel {  distance = 33km; } <--> ofs_25.gateCPlane++;
        ofs_11.gateDPlane++ <--> DistanceChannel {  distance = 25km; } <--> ofs_12.gateDPlane++;
        ofs_11.gateCPlane++ <--> DistanceChannel {  distance = 25km; } <--> ofs_12.gateCPlane++;
        ofs_12.gateDPlane++ <--> DistanceChannel {  distance = 131km; } <--> ofs_22.gateDPlane++;
        ofs_12.gateCPlane++ <--> DistanceChannel {  distance = 131km; } <--> ofs_22.gateCPlane++;
        ofs_13.gateDPlane++ <--> DistanceChannel {  distance = 31km; } <--> ofs_26.gateDPlane++;
        ofs_13.gateCPlane++ <--> DistanceChannel {  distance = 31km; } <--> ofs_26.gateCPlane++;
        ofs_14.gateDPlane++ <--> DistanceChannel {  distance = 2km; } <--> ofs_22.gateDPlane++;
        ofs_14.gateCPlane++ <--> DistanceChannel {  distance = 2km; } <--> ofs_22.gateCPlane++;
        ofs_15.gateDPlane++ <--> DistanceChannel {  distance = 134km; } <--> ofs_18.gateDPlane++;
        ofs_15.gateCPlane++ <--> DistanceChannel {  distance = 134km; } <--> ofs_18.gateCPlane++;
        ofs_15.gateDPlane++ <--> DistanceChannel {  distance = 57km; } <--> ofs_20.gateDPlane++;
        ofs_15.gateCPlane++ <--> DistanceChannel {  distance = 57km; } <--> ofs_20.gateCPlane++;
        ofs_17.gateDPlane++ <--> DistanceChannel {  distance = 63km; } <--> ofs_18.gateDPlane++;
        ofs_17.gateCPlane++ <--> DistanceChannel {  distance = 63km; } <--> ofs_18.gateCPlane++;
        ofs_17.gateDPlane++ <--> DistanceChannel {  distance = 54km; } <--> ofs_23.gateDPlane++;
        ofs_17.gateCPlane++ <--> DistanceChannel {  distance = 54km; } <--> ofs_23.gateCPlane++;
        ofs_19.gateDPlane++ <--> DistanceChannel {  distance = 71km; } <--> ofs_20.gateDPlane++;
        ofs_19.gateCPlane++ <--> DistanceChannel {  distance = 71km; } <--> ofs_20.gateCPlane++;
        ofs_21.gateDPlane++ <--> DistanceChannel {  distance = 97km; } <--> ofs_22.gateDPlane++;
        ofs_21.gateCPlane++ <--> DistanceChannel {  distance = 97km; } <--> ofs_22.gateCPlane++;
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 72km; } <--> ofs_23.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_24.gateDPlane++ <--> DistanceChannel {  distance = 86km; } <--> ofs_32.gateDPlane++;
        ofs_24.gateCPlane++ <--> DistanceChannel {  distance = 86km; } <--> ofs_32.gateCPlane++;
        ofs_26.gateDPlane++ <--> DistanceChannel {  distance = 77km; } <--> ofs_27.gateDPlane++;
        ofs_26.gateCPlane++ <--> DistanceChannel {  distance = 77km; } <--> ofs_27.gateCPlane++;
        ofs_27.gateDPlane++ <--> DistanceChannel {  distance = 18km; } <--> ofs_28.gateDPlane++;
        ofs_27.gateCPlane++ <--> DistanceChannel {  distance = 18km; } <--> ofs_28.gateCPlane++;
        ofs_28.gateDPlane++ <--> DistanceChannel {  distance = 15km; } <--> ofs_29.gateDPlane++;
        ofs_28.gateCPlane++ <--> DistanceChannel {  distance = 15km; } <--> ofs_29.gateCPlane++;
        ofs_29.gateDPlane++ <--> DistanceChannel {  distance = 76km; } <--> ofs_31.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_30.gateDPlane++ <--> DistanceChannel {  distance = 100km; } <--> ofs_31.gateDPlane++;
        ofs_30.gateCPlane++ <--> DistanceChannel {  distance = 100km; } <--> ofs_31.gateCPlane++;
        ofs_30.gateDPlane++ <--> DistanceChannel {  distance = 95km; } <--> ofs_32.gateDPlane++;
        ofs_30.gateCPlane++ <--> DistanceChannel {  distance = 95km; } <--> ofs_32.gateCPlane++;
        // placement 1, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 1);
        // placement 2, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_21.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 2);
        // placement 3, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 3);
        // placement 4, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 4);
        // placement 5, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 5);
        // placement 6, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_8.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 6);
        // placement 7, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 7);
        // placement 8, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 8);
        // placement 9, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 9);
        // placement 10, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 10);
        // placement 11, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 11);
        // placement 12, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_14.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 12);
        // placement 13, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 13);
        // placement 14, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 14);
        // placement 15, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_27.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 15);
        // placement 16, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_28.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 2 && placementID == 16);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 16);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 16);
        // placement 17, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 17);
        // placement 18, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_31.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 18);
        // placement 19, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 19);
        // placement 20, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 20);
        // placement 21, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 21);
        // placement 22, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 22);
        // placement 23, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 23);
        // placement 24, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_12.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 24);
        // placement 25, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 25);
        // placement 26, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 26);
        // placement 27, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 27);
        // placement 28, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 28);
        // placement 29, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 29);
        // placement 30, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 30);
        // placement 31, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 31);
        // placement 32, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 32);
        // placement 33, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_13.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 33);
        // placement 34, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 34);
        // placement 35, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 35);
        // placement 36, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_28.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 36);
        // placement 37, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 37);
        // placement 38, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 38);
        // placement 39, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 39);
        // placement 40, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 40);
        // placement 41, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 41);
        // placement 42, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 42);
        // placement 43, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 43);
        // placement 44, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 44);
        // placement 45, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_12.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 45);
        // placement 46, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 46);
        // placement 47, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 47);
        // placement 48, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 48);
        // placement 49, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 49);
        // placement 50, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 50);
        // placement 51, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_22.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 51);
        // placement 52, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 52);
        // placement 53, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 53);
        // placement 54, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 54);
        // placement 55, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 55);
        // placement 56, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 56);
        // placement 57, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> root.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 57);
}
