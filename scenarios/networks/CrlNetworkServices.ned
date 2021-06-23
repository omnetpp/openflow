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


network Scenario_CrlNetworkServices
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
            @display("p=132,358");
        }
        ofs_2: Open_Flow_Domain {
            @display("p=199,320");
        }
        ofs_3: Open_Flow_Domain {
            @display("p=59,349");
        }
        ofs_4: Open_Flow_Domain {
            @display("p=69,375");
        }
        ofs_5: Open_Flow_Domain {
            @display("p=300,448");
        }
        ofs_6: Open_Flow_Domain {
            @display("p=339,440");
        }
        ofs_7: Open_Flow_Domain {
            @display("p=321,373");
        }
        ofs_8: Open_Flow_Domain {
            @display("p=309,429");
        }
        ofs_9: Open_Flow_Domain {
            @display("p=475,351");
        }
        ofs_10: Open_Flow_Domain {
            @display("p=546,304");
        }
        ofs_11: Open_Flow_Domain {
            @display("p=348,224");
        }
        ofs_12: Open_Flow_Domain {
            @display("p=220,208");
        }
        ofs_13: Open_Flow_Domain {
            @display("p=499,480");
        }
        ofs_14: Open_Flow_Domain {
            @display("p=403,235");
        }
        ofs_15: Open_Flow_Domain {
            @display("p=529,191");
        }
        ofs_16: Open_Flow_Domain {
            @display("p=603,184");
        }
        ofs_17: Open_Flow_Domain {
            @display("p=589,203");
        }
        ofs_18: Open_Flow_Domain {
            @display("p=571,219");
        }
        ofs_19: Open_Flow_Domain {
            @display("p=566,229");
        }
        ofs_20: Open_Flow_Domain {
            @display("p=434,155");
        }
        ofs_21: Open_Flow_Domain {
            @display("p=491,142");
        }
        ofs_22: Open_Flow_Domain {
            @display("p=508,164");
        }
        ofs_23: Open_Flow_Domain {
            @display("p=640,142");
        }
        ofs_24: Open_Flow_Domain {
            @display("p=10,267");
        }
        ofs_25: Open_Flow_Domain {
            @display("p=55,344");
        }
        ofs_26: Open_Flow_Domain {
            @display("p=5,0");
        }
        ofs_27: Open_Flow_Domain {
            @display("p=0,58");
        }
        ofs_28: Open_Flow_Domain {
            @display("p=0,240");
        }
        ofs_29: Open_Flow_Domain {
            @display("p=15,237");
        }
        ofs_30: Open_Flow_Domain {
            @display("p=18,252");
        }
        ofs_31: Open_Flow_Domain {
            @display("p=634,120");
        }
        ofs_32: Open_Flow_Domain {
            @display("p=2,251");
        }
        ofs_33: Open_Flow_Domain {
            @display("p=4,256");
        }
    connections allowunconnected:

        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 530km; } <--> ofs_2.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 530km; } <--> ofs_2.gateCPlane++;
        ofs_1.gateDPlane++ <--> DistanceChannel {  distance = 481km; } <--> ofs_4.gateDPlane++;
        ofs_1.gateCPlane++ <--> DistanceChannel {  distance = 481km; } <--> ofs_4.gateCPlane++;
        ofs_2.gateDPlane++ <--> DistanceChannel {  distance = 943km; } <--> ofs_7.gateDPlane++;
        ofs_2.gateCPlane++ <--> DistanceChannel {  distance = 943km; } <--> ofs_7.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 143km; } <--> ofs_4.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 143km; } <--> ofs_4.gateCPlane++;
        ofs_3.gateDPlane++ <--> DistanceChannel {  distance = 39km; } <--> ofs_25.gateDPlane++;
        ofs_3.gateCPlane++ <--> DistanceChannel {  distance = 39km; } <--> ofs_25.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 305km; } <--> ofs_6.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 305km; } <--> ofs_6.gateCPlane++;
        ofs_5.gateDPlane++ <--> DistanceChannel {  distance = 118km; } <--> ofs_8.gateDPlane++;
        ofs_5.gateCPlane++ <--> DistanceChannel {  distance = 118km; } <--> ofs_8.gateCPlane++;
        ofs_6.gateDPlane++ <--> DistanceChannel {  distance = 363km; } <--> ofs_7.gateDPlane++;
        ofs_6.gateCPlane++ <--> DistanceChannel {  distance = 363km; } <--> ofs_7.gateCPlane++;
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 293km; } <--> ofs_8.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 1159km; } <--> ofs_9.gateDPlane++;
        ofs_7.gateCPlane++ <--> DistanceChannel {  distance = 1159km; } <--> ofs_9.gateCPlane++;
        ofs_7.gateDPlane++ <--> DistanceChannel {  distance = 882km; } <--> ofs_14.gateDPlane++;
        ofs_7.gateCPlane++ <--> DistanceChannel {  distance = 882km; } <--> ofs_14.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 571km; } <--> ofs_10.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 571km; } <--> ofs_10.gateCPlane++;
        ofs_9.gateDPlane++ <--> DistanceChannel {  distance = 671km; } <--> ofs_13.gateDPlane++;
        ofs_9.gateCPlane++ <--> DistanceChannel {  distance = 671km; } <--> ofs_13.gateCPlane++;
        ofs_10.gateDPlane++ <--> DistanceChannel {  distance = 375km; } <--> ofs_19.gateDPlane++;
        ofs_10.gateCPlane++ <--> DistanceChannel {  distance = 375km; } <--> ofs_19.gateCPlane++;
        ofs_11.gateDPlane++ <--> DistanceChannel {  distance = 892km; } <--> ofs_12.gateDPlane++;
        ofs_11.gateCPlane++ <--> DistanceChannel {  distance = 892km; } <--> ofs_12.gateCPlane++;
        ofs_11.gateDPlane++ <--> DistanceChannel {  distance = 387km; } <--> ofs_14.gateDPlane++;
        ofs_11.gateCPlane++ <--> DistanceChannel {  distance = 387km; } <--> ofs_14.gateCPlane++;
        ofs_12.gateDPlane++ <--> DistanceChannel {  distance = 1525km; } <--> ofs_33.gateDPlane++;
        ofs_12.gateCPlane++ <--> DistanceChannel {  distance = 1525km; } <--> ofs_33.gateCPlane++;
        ofs_14.gateDPlane++ <--> DistanceChannel {  distance = 419km; } <--> ofs_20.gateDPlane++;
        ofs_14.gateCPlane++ <--> DistanceChannel {  distance = 419km; } <--> ofs_20.gateCPlane++;
        ofs_15.gateDPlane++ <--> DistanceChannel {  distance = 306km; } <--> ofs_19.gateDPlane++;
        ofs_15.gateCPlane++ <--> DistanceChannel {  distance = 306km; } <--> ofs_19.gateCPlane++;
        ofs_15.gateDPlane++ <--> DistanceChannel {  distance = 185km; } <--> ofs_22.gateDPlane++;
        ofs_15.gateCPlane++ <--> DistanceChannel {  distance = 185km; } <--> ofs_22.gateCPlane++;
        ofs_16.gateDPlane++ <--> DistanceChannel {  distance = 130km; } <--> ofs_17.gateDPlane++;
        ofs_16.gateCPlane++ <--> DistanceChannel {  distance = 130km; } <--> ofs_17.gateCPlane++;
        ofs_16.gateDPlane++ <--> DistanceChannel {  distance = 306km; } <--> ofs_23.gateDPlane++;
        ofs_16.gateCPlane++ <--> DistanceChannel {  distance = 306km; } <--> ofs_23.gateCPlane++;
        ofs_17.gateDPlane++ <--> DistanceChannel {  distance = 144km; } <--> ofs_18.gateDPlane++;
        ofs_17.gateCPlane++ <--> DistanceChannel {  distance = 144km; } <--> ofs_18.gateCPlane++;
        ofs_18.gateDPlane++ <--> DistanceChannel {  distance = 57km; } <--> ofs_19.gateDPlane++;
        ofs_18.gateCPlane++ <--> DistanceChannel {  distance = 57km; } <--> ofs_19.gateCPlane++;
        ofs_20.gateDPlane++ <--> DistanceChannel {  distance = 384km; } <--> ofs_21.gateDPlane++;
        ofs_20.gateCPlane++ <--> DistanceChannel {  distance = 384km; } <--> ofs_21.gateCPlane++;
        ofs_20.gateDPlane++ <--> DistanceChannel {  distance = 2789km; } <--> ofs_26.gateDPlane++;
        ofs_20.gateCPlane++ <--> DistanceChannel {  distance = 2789km; } <--> ofs_26.gateCPlane++;
        ofs_21.gateDPlane++ <--> DistanceChannel {  distance = 145km; } <--> ofs_22.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_22.gateDPlane++ <--> DistanceChannel {  distance = 884km; } <--> ofs_23.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_24.gateDPlane++ <--> DistanceChannel {  distance = 492km; } <--> ofs_25.gateDPlane++;
        ofs_24.gateCPlane++ <--> DistanceChannel {  distance = 492km; } <--> ofs_25.gateCPlane++;
        ofs_24.gateDPlane++ <--> DistanceChannel {  distance = 67km; } <--> ofs_33.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_26.gateDPlane++ <--> DistanceChannel {  distance = 233km; } <--> ofs_27.gateDPlane++;
        ofs_26.gateCPlane++ <--> DistanceChannel {  distance = 233km; } <--> ofs_27.gateCPlane++;
        ofs_27.gateDPlane++ <--> DistanceChannel {  distance = 788km; } <--> ofs_28.gateDPlane++;
        ofs_27.gateCPlane++ <--> DistanceChannel {  distance = 788km; } <--> ofs_28.gateCPlane++;
        ofs_28.gateDPlane++ <--> DistanceChannel {  distance = 107km; } <--> ofs_29.gateDPlane++;
        ofs_28.gateCPlane++ <--> DistanceChannel {  distance = 107km; } <--> ofs_29.gateCPlane++;
        ofs_28.gateDPlane++ <--> DistanceChannel {  distance = 54km; } <--> ofs_32.gateDPlane++;
        ofs_28.gateCPlane++ <--> DistanceChannel {  distance = 54km; } <--> ofs_32.gateCPlane++;
        ofs_29.gateDPlane++ <--> DistanceChannel {  distance = 72km; } <--> ofs_30.gateDPlane++;
        ofs_29.gateCPlane++ <--> DistanceChannel {  distance = 72km; } <--> ofs_30.gateCPlane++;
        ofs_30.gateDPlane++ <--> DistanceChannel {  distance = 4180km; } <--> ofs_31.gateDPlane++;
        ofs_30.gateCPlane++ <--> DistanceChannel {  distance = 4180km; } <--> ofs_31.gateCPlane++;
        ofs_31.gateDPlane++ <--> DistanceChannel {  distance = 4278km; } <--> ofs_33.gateDPlane++;
        // this edge is not part of the MST, skipping
        ofs_32.gateDPlane++ <--> DistanceChannel {  distance = 24km; } <--> ofs_33.gateDPlane++;
        // this edge is not part of the MST, skipping
        // placement 1, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 1);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 1);
        // placement 2, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 2);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 2);
        // placement 3, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 3);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 3);
        // placement 4, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 4);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 4);
        // placement 5, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 5);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 5);
        // placement 6, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 6);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 6);
        // placement 7, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 7);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 7);
        // placement 8, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_5.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_5.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 8);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 8);
        // placement 9, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 9);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 9);
        // placement 10, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_14.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_8.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 10);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 10);
        // placement 11, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 11);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 11);
        // placement 12, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_12.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_12.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 12);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 12);
        // placement 13, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 13);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 13);
        // placement 14, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_28.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 14);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 14);
        // placement 15, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 15);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 15);
        // placement 16, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 16);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 16);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 16);
        // placement 17, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_12.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 17);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 17);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 17);
        // placement 18, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 18);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 18);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 18);
        // placement 19, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 19);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 19);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 19);
        // placement 20, k = 2
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_32.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 2 && placementID == 20);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 2 && placementID == 20);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 2 && placementID == 20);
        // placement 21, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 21);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 21);
        // placement 22, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_1.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_1.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 22);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 22);
        // placement 23, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 23);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 23);
        // placement 24, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 24);
        ofs_26.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 24);
        // placement 25, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 25);
        ofs_27.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 25);
        // placement 26, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_14.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 26);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 26);
        // placement 27, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_14.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 27);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 27);
        // placement 28, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_14.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 28);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 28);
        // placement 29, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 29);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 29);
        // placement 30, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 30);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 30);
        // placement 31, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 31);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 31);
        // placement 32, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 32);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 32);
        // placement 33, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 33);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 33);
        // placement 34, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 34);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 34);
        // placement 35, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_21.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 35);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 35);
        // placement 36, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 36);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 36);
        // placement 37, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 37);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 37);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 37);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 37);
        // placement 38, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 38);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 38);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 38);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 38);
        // placement 39, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 39);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 39);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 39);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 39);
        // placement 40, k = 3
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_32.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 3 && placementID == 40);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 3 && placementID == 40);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 3 && placementID == 40);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 3 && placementID == 40);
        // placement 41, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 41);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 41);
        // placement 42, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 42);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 42);
        // placement 43, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_9.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_20.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 43);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 43);
        // placement 44, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 44);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 44);
        // placement 45, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_2.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_2.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_22.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 45);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 45);
        // placement 46, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 46);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 46);
        // placement 47, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 47);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 47);
        // placement 48, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_3.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 48);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 48);
        // placement 49, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_24.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 49);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 49);
        // placement 50, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_3.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 50);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 50);
        // placement 51, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 51);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 51);
        // placement 52, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 52);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 52);
        // placement 53, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_4.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 53);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 53);
        // placement 54, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_11.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_11.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 54);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 54);
        // placement 55, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_7.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_10.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 55);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 55);
        // placement 56, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_14.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_14.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 56);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 56);
        // placement 57, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_25.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_7.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_31.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 57);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 57);
        // placement 58, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_18.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 58);
        ofs_15.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 58);
        ofs_16.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 58);
        ofs_17.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 58);
        ofs_18.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 58);
        ofs_19.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 58);
        // placement 59, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_33.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 59);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 59);
        ofs_25.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 59);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 59);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 59);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 59);
        // placement 60, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_28.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 60);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 60);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 60);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 60);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 60);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 60);
        // placement 61, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_32.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 61);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 61);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 61);
        ofs_29.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 61);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 61);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 61);
        // placement 62, k = 5
        // hfSyncHost according to minimum avg distance to ctrl
        ofs_32.gateCPlane++ <--> backboneline <--> hf_synchronizer.ethg++ if (numControllers == 5 && placementID == 62);
        ofs_24.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++ if (numControllers == 5 && placementID == 62);
        ofs_28.gateCPlane++ <--> backboneline <--> open_flow_controller2.ethg++ if (numControllers == 5 && placementID == 62);
        ofs_30.gateCPlane++ <--> backboneline <--> open_flow_controller3.ethg++ if (numControllers == 5 && placementID == 62);
        ofs_32.gateCPlane++ <--> backboneline <--> open_flow_controller4.ethg++ if (numControllers == 5 && placementID == 62);
        ofs_33.gateCPlane++ <--> backboneline <--> open_flow_controller5.ethg++ if (numControllers == 5 && placementID == 62);
}
