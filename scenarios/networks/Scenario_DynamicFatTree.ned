

package scenarios.networks;

import inet.common.misc.ThruputMeteringChannel;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import openflow.nodes.DynamicFatTree;
import openflow.openflow.controller.Open_Flow_Controller;
import openflow.utility.OpenFlowGraphAnalyzer;
import openflow.utility.StaticSpanningTree;
import inet.node.ethernet.Eth40G;

network Scenario_DynamicFatTree
{
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
            @display("p=458,190");
        }

        openFlowGraphAnalyzer: OpenFlowGraphAnalyzer {
            @display("p=458,270");
        }

        configurator: Ipv4NetworkConfigurator {
            parameters:
                @display("p=198,190");
        }

        open_flow_controller1: Open_Flow_Controller {
            @display("p=322,190");
        }

        fat_tree: DynamicFatTree {
            @display("p=322,367;is=vl");
        }

    connections allowunconnected:

        fat_tree.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++;
}
