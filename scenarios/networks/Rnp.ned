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


network Scenario_Rnp
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
            @display("p=640,152");
        }
        ofs_2: Open_Flow_Domain {
            @display("p=623,175");
        }
        ofs_3: Open_Flow_Domain {
            @display("p=620,141");
        }
        ofs_4: Open_Flow_Domain {
            @display("p=640,139");
        }
        ofs_5: Open_Flow_Domain {
            @display("p=386,263");
        }
        ofs_6: Open_Flow_Domain {
            @display("p=464,324");
        }
        ofs_7: Open_Flow_Domain {
            @display("p=597,193");
        }
        ofs_8: Open_Flow_Domain {
            @display("p=569,222");
        }
        ofs_9: Open_Flow_Domain {
            @display("p=534,330");
        }
        ofs_10: Open_Flow_Domain {
            @display("p=478,369");
        }
        ofs_11: Open_Flow_Domain {
            @display("p=151,83");
        }
        ofs_12: Open_Flow_Domain {
            @display("p=360,276");
        }
        ofs_13: Open_Flow_Domain {
            @display("p=228,260");
        }
        ofs_14: Open_Flow_Domain {
            @display("p=360,407");
        }
        ofs_15: Open_Flow_Domain {
            @display("p=322,480");
        }
        ofs_16: Open_Flow_Domain {
            @display("p=374,441");
        }
        ofs_17: Open_Flow_Domain {
            @display("p=411,378");
        }
        ofs_18: Open_Flow_Domain {
            @display("p=76,162");
        }
        ofs_19: Open_Flow_Domain {
            @display("p=0,180");
        }
        ofs_20: Open_Flow_Domain {
            @display("p=378,183");
        }
        ofs_21: Open_Flow_Domain {
            @display("p=256,332");
        }
        ofs_22: Open_Flow_Domain {
            @display("p=486,111");
        }
        ofs_23: Open_Flow_Domain {
            @display("p=633,121");
        }
        ofs_24: Open_Flow_Domain {
            @display("p=139,0");
        }
        ofs_25: Open_Flow_Domain {
            @display("p=325,39");
        }
        ofs_26: Open_Flow_Domain {
            @display("p=375,60");
        }
        ofs_27: Open_Flow_Domain {
            @display("p=457,75");
        }
        ofs_28: Open_Flow_Domain {
            @display("p=569,91");
        }
    connections allowunconnected:

        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 143km; } <--> ofs_3.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 143km; } <--> ofs_3.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 935km; } <--> ofs_22.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 935km; } <--> ofs_22.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 201km; } <--> ofs_7.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 201km; } <--> ofs_7.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 113km; } <--> ofs_4.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 113km; } <--> ofs_4.gateCPlane++;
        ofs_4.gateDPlane++ <--> DistanceChannel {  distance = 152km; } <--> ofs_23.gateDPlane++;
        ofs_4.gateCPlane++ <--> DistanceChannel {  distance = 152km; } <--> ofs_23.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 625km; } <--> ofs_6.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 625km; } <--> ofs_6.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 934km; } <--> ofs_10.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 934km; } <--> ofs_10.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 1934km; } <--> ofs_11.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 1934km; } <--> ofs_11.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 2498km; } <--> ofs_24.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 2498km; } <--> ofs_24.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 1792km; } <--> ofs_25.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 1792km; } <--> ofs_25.gateCPlane++;
        ofs_6.gateDPlane++ <--> DistanceChannel {  distance = 965km; } <--> ofs_8.gateDPlane++;
        ofs_6.gateCPlane++ <--> DistanceChannel {  distance = 965km; } <--> ofs_8.gateCPlane++;
        ofs_6.gateDPlane++ <--> DistanceChannel {  distance = 490km; } <--> ofs_17.gateDPlane++;
        ofs_6.gateCPlane++ <--> DistanceChannel {  distance = 490km; } <--> ofs_17.gateCPlane++;
        ofs_6.gateDPlane++ <--> DistanceChannel {  distance = 1894km; } <--> ofs_28.gateDPlane++;
        ofs_6.gateCPlane++ <--> DistanceChannel {  distance = 1894km; } <--> ofs_28.gateCPlane++;
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 277km; } <--> ofs_8.gateDPlane++;
        ofs_7.gateCPlane++ <--> DistanceChannel {  distance = 277km; } <--> ofs_8.gateCPlane++;
        ofs_8.gateDPlane++ <--> DistanceChannel {  distance = 840km; } <--> ofs_9.gateDPlane++;
        ofs_8.gateCPlane++ <--> DistanceChannel {  distance = 840km; } <--> ofs_9.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 413km; } <--> ofs_10.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_10.gateDPlane++ <--> DistanceChannel {  distance = 358km; } <--> ofs_17.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_12.gateDPlane++ <--> DistanceChannel {  distance = 741km; } <--> ofs_13.gateDPlane++;
        ofs_12.gateCPlane++ <--> DistanceChannel {  distance = 741km; } <--> ofs_13.gateCPlane++;
        ofs_12.gateDPlane++ <--> DistanceChannel {  distance = 725km; } <--> ofs_20.gateDPlane++;
        ofs_12.gateCPlane++ <--> DistanceChannel {  distance = 725km; } <--> ofs_20.gateCPlane++;
        ofs_13.gateDPlane++ <--> DistanceChannel {  distance = 1139km; } <--> ofs_18.gateDPlane++;
        ofs_13.gateCPlane++ <--> DistanceChannel {  distance = 1139km; } <--> ofs_18.gateCPlane++;
        ofs_13.gateDPlane++ <--> DistanceChannel {  distance = 560km; } <--> ofs_21.gateDPlane++;
        ofs_13.gateCPlane++ <--> DistanceChannel {  distance = 560km; } <--> ofs_21.gateCPlane++;
        ofs_14.gateDPlane++ <--> DistanceChannel {  distance = 547km; } <--> ofs_15.gateDPlane++;
        ofs_14.gateCPlane++ <--> DistanceChannel {  distance = 547km; } <--> ofs_15.gateCPlane++;
        ofs_14.gateDPlane++ <--> DistanceChannel {  distance = 339km; } <--> ofs_17.gateDPlane++;
        ofs_14.gateCPlane++ <--> DistanceChannel {  distance = 339km; } <--> ofs_17.gateCPlane++;
        ofs_14.gateDPlane++ <--> DistanceChannel {  distance = 781km; } <--> ofs_21.gateDPlane++;
        ofs_14.gateCPlane++ <--> DistanceChannel {  distance = 781km; } <--> ofs_21.gateCPlane++;
        ofs_15.gateDPlane++ <--> DistanceChannel {  distance = 376km; } <--> ofs_16.gateDPlane++;
        ofs_15.gateCPlane++ <--> DistanceChannel {  distance = 376km; } <--> ofs_16.gateCPlane++;
        ofs_16.gateDPlane++ <--> DistanceChannel {  distance = 489km; } <--> ofs_17.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_18.gateDPlane++ <--> DistanceChannel {  distance = 449km; } <--> ofs_19.gateDPlane++;
        ofs_18.gateCPlane++ <--> DistanceChannel {  distance = 449km; } <--> ofs_19.gateCPlane++;
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 751km; } <--> ofs_26.gateDPlane++;
        ofs_22.gateCPlane++ <--> DistanceChannel {  distance = 751km; } <--> ofs_26.gateCPlane++;
        ofs_23.gateDPlane++ <--> DistanceChannel {  distance = 436km; } <--> ofs_28.gateDPlane++;
        ofs_23.gateCPlane++ <--> DistanceChannel {  distance = 436km; } <--> ofs_28.gateCPlane++;
        ofs_26.gateDPlane++ <--> DistanceChannel {  distance = 482km; } <--> ofs_27.gateDPlane++;
        ofs_26.gateCPlane++ <--> DistanceChannel {  distance = 482km; } <--> ofs_27.gateCPlane++;
        ofs_27.gateDPlane++ <--> DistanceChannel {  distance = 653km; } <--> ofs_28.gateDPlane++;
        // this edge is not part of the MST, skipping
        // placement 1, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 1);
        // placement 2, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 2);
        // placement 3, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 3);
        // placement 4, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 4);
        // placement 5, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 5);
        // placement 6, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 6);
        // placement 7, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 7);
        // placement 8, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 8);
        // placement 9, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 9);
        // placement 10, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 10);
        // placement 11, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 11);
        // placement 12, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 12);
        // placement 13, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_10.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 13);
        // placement 14, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 14);
        // placement 15, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 15);
        // placement 16, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 16);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 16);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 16);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 16);
        // placement 17, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 17);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 17);
        // placement 18, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 18);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 18);
        // placement 19, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 19);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 19);
        // placement 20, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 20);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 20);
        // placement 21, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_23.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 21);
        // placement 22, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 22);
        // placement 23, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 23);
        // placement 24, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 24);
        // placement 25, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 25);
        // placement 26, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 26);
        // placement 27, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 27);
        // placement 28, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 28);
        // placement 29, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 29);
        // placement 30, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 30);
        // placement 31, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 31);
        // placement 32, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 32);
        // placement 33, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 33);
        // placement 34, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 34);
        // placement 35, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 35);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 35);
        // placement 36, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_4.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 36);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 36);
        // placement 37, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 37);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 37);
        // placement 38, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 38);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 38);
        // placement 39, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 39);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 39);
        // placement 40, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 40);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 40);
        // placement 41, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 41);
        // placement 42, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 42);
        // placement 43, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 43);
        // placement 44, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 44);
        // placement 45, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 45);
        // placement 46, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_17.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 46);
        // placement 47, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_17.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 47);
        // placement 48, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_17.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 48);
        // placement 49, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_6.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_13.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 49);
        // placement 50, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_17.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 50);
        // placement 51, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_17.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_23.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 51);
        // placement 52, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_17.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 52);
        // placement 53, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_17.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_6.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 53);
        // placement 54, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_17.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 54);
        // placement 55, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_17.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 55);
}
