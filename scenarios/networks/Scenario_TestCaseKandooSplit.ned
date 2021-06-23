

package scenarios.networks;

import inet.common.misc.ThruputMeteringChannel;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.ethernet.EthernetSwitch;
import inet.node.inet.StandardHost;
import openflow.openflow.controller.Open_Flow_Controller;
import openflow.openflow.switch.Open_Flow_Switch;
import openflow.utility.OpenFlowGraphAnalyzer;
import openflow.utility.StaticSpanningTree;


network Scenario_TestCaseKandooSplit
{
    parameters:
        int numClients @display("bgb=768,465") = default(1);

        @display("bgb=925,638");
    types:
        channel ethernetline extends ThruputMeteringChannel
        {
            delay = 1us;
            datarate = 100Mbps;
            thruputDisplayFormat = "u";
        }

    submodules:
        spanningTree: StaticSpanningTree {
            @display("p=61,108");
        }
        openflowGraphAnalyzer: OpenFlowGraphAnalyzer {
            @display("p=61,39");
        }

        open_flow_controller_knroot: Open_Flow_Controller {
            @display("p=468,31");
        }

        clientG1[numClients]: StandardHost {
            @display("p=123,346");
        }
        clientG2[numClients]: StandardHost {
            @display("p=848,354");
        }
        configurator: Ipv4NetworkConfigurator {
            parameters:
                @display("p=61,172");
        }

        open_flow_switch1: Open_Flow_Switch {
            @display("p=278,345");
        }
        open_flow_switch2: Open_Flow_Switch {
            @display("p=406,289");
        }
        open_flow_switch3: Open_Flow_Switch {
            @display("p=548,289");
        }
        open_flow_switch4: Open_Flow_Switch {
            @display("p=698,353");
        }


        etherSwitch: EthernetSwitch {
            @display("p=468,133");
        }

        open_flow_controller1: Open_Flow_Controller {
            @display("p=348,134");
        }
        open_flow_controller2: Open_Flow_Controller {
            @display("p=622,128");
        }

    connections allowunconnected:
        for i=0..(numClients)-1 {
            clientG1[i].ethg++ <--> ethernetline <--> open_flow_switch1.gateDataPlane++;
        }

        for i=0..(numClients)-1 {
            clientG2[i].ethg++ <--> ethernetline <--> open_flow_switch4.gateDataPlane++;
        }

        open_flow_switch1.gateDataPlane++ <--> ethernetline <--> open_flow_switch2.gateDataPlane++;
        open_flow_switch2.gateDataPlane++ <--> ethernetline <--> open_flow_switch3.gateDataPlane++;
        open_flow_switch3.gateDataPlane++ <--> ethernetline <--> open_flow_switch4.gateDataPlane++;

        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch1.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch2.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch3.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch4.gateControlPlane++;

        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller1.ethg++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller2.ethg++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller_knroot.ethg++;


}
