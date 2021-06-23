

package scenarios.networks;

import inet.common.misc.ThruputMeteringChannel;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.node.ethernet.EtherSwitch;
import openflow.hyperflow.Hyper_Flow_Synchronizer;
import openflow.nodes.DynamicFatTree;
import openflow.openflow.controller.Open_Flow_Controller;
import openflow.utility.OpenFlowGraphAnalyzer;
import openflow.utility.StaticSpanningTree;


network Scenario_DynamicFatTree_HF
{
    parameters:
        int numControllers = default(1);
        @display("bgb=842,642;");


    types:
        channel backboneline extends ThruputMeteringChannel
        {
            delay = 1us;
            datarate = 40Gbps;
            thruputDisplayFormat = "u";
        }
    submodules:

        spanningTree: StaticSpanningTree {
            @display("p=503,345");
        }

        openFlowGraphAnalyzer: OpenFlowGraphAnalyzer {
            @display("p=637,345");
        }


        configurator: IPv4NetworkConfigurator {
            parameters:
                @display("p=198,345");
        }

        open_flow_controller1: Open_Flow_Controller if numControllers >=1 {
            @display("p=184,226");
        }

        open_flow_controller2: Open_Flow_Controller if numControllers >=2 {
            @display("p=172,110");
        }

        open_flow_controller3: Open_Flow_Controller if numControllers >=3 {
            @display("p=271,39");
        }


        open_flow_controller4: Open_Flow_Controller if numControllers >=4 {
            @display("p=503,110");
        }

        open_flow_controller5: Open_Flow_Controller if numControllers >=5 {
            @display("p=503,226");
        }

        hf_synchronizer: Hyper_Flow_Synchronizer {
            @display("p=447,39");
        }

        fat_tree: DynamicFatTree {
            @display("p=358,344;is=vl");
        }

        etherSwitch: EtherSwitch {
            @display("p=358,141");
        }


    connections allowunconnected:

        etherSwitch.ethg++ <--> backboneline <--> open_flow_controller1.ethg++ if numControllers >=1;
        etherSwitch.ethg++ <--> backboneline <--> open_flow_controller2.ethg++ if numControllers >=2;
        etherSwitch.ethg++ <--> backboneline <--> open_flow_controller3.ethg++ if numControllers >=3;
        etherSwitch.ethg++ <--> backboneline <--> open_flow_controller4.ethg++ if numControllers >=4;
        etherSwitch.ethg++ <--> backboneline <--> open_flow_controller5.ethg++ if numControllers >=5;

        etherSwitch.ethg++ <--> backboneline <--> hf_synchronizer.ethg++;

        fat_tree.gateCPlane++ <--> backboneline <--> etherSwitch.ethg++;
}
