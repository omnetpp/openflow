

package scenarios.networks;

import inet.common.misc.ThruputMeteringChannel;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.StandardHost;
import openflow.openflow.controller.Open_Flow_Controller;
import openflow.openflow.switch.Open_Flow_Switch;
import openflow.utility.OpenFlowGraphAnalyzer;
import openflow.utility.StaticSpanningTree;


network Scenario_TestCaseKandooDiamond
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


        clientG1[numClients]: StandardHost {
            @display("p=78,369");
        }
        clientG2[numClients]: StandardHost {
            @display("p=212,542");
        }
        clientG3[numClients]: StandardHost {
            @display("p=525,542");
        }

        clientG4[numClients]: StandardHost {
            @display("p=676,369");
        }
        clientG5[numClients]: StandardHost {
            @display("p=525,246");
        }
        clientG6[numClients]: StandardHost {
            @display("p=204,255");
        }

        configurator: IPv4NetworkConfigurator {
            parameters:
                @display("p=61,172");
        }

        open_flow_switch1: Open_Flow_Switch {
            @display("p=204,368");
        }
        open_flow_switch2: Open_Flow_Switch {
            @display("p=296,489");
        }
        open_flow_switch3: Open_Flow_Switch {
            @display("p=453,483");
        }
        open_flow_switch4: Open_Flow_Switch {
            @display("p=547,368");
        }
        open_flow_switch5: Open_Flow_Switch {
            @display("p=453,304");
        }
        open_flow_switch6: Open_Flow_Switch {
            @display("p=296,304");
        }


        etherSwitch: EtherSwitch {
            @display("p=366,141");
        }

        open_flow_controller1: Open_Flow_Controller {
            @display("p=212,142");
        }
        open_flow_controller2: Open_Flow_Controller {
            @display("p=525,142");
        }

        open_flow_controller_knroot: Open_Flow_Controller {
            @display("p=366,39");
        }

    connections allowunconnected:
        for i=0..(numClients)-1 {
            clientG1[i].ethg++ <--> ethernetline <--> open_flow_switch1.gateDataPlane++;
        }

        for i=0..(numClients)-1 {
            clientG2[i].ethg++ <--> ethernetline <--> open_flow_switch2.gateDataPlane++;
        }

        for i=0..(numClients)-1 {
            clientG3[i].ethg++ <--> ethernetline <--> open_flow_switch3.gateDataPlane++;
        }

        for i=0..(numClients)-1 {
            clientG4[i].ethg++ <--> ethernetline <--> open_flow_switch4.gateDataPlane++;
        }

        for i=0..(numClients)-1 {
            clientG5[i].ethg++ <--> ethernetline <--> open_flow_switch5.gateDataPlane++;
        }

        for i=0..(numClients)-1 {
            clientG6[i].ethg++ <--> ethernetline <--> open_flow_switch6.gateDataPlane++;
        }

        open_flow_switch1.gateDataPlane++ <--> ethernetline <--> open_flow_switch2.gateDataPlane++;
        open_flow_switch2.gateDataPlane++ <--> ethernetline <--> open_flow_switch3.gateDataPlane++;
        open_flow_switch3.gateDataPlane++ <--> ethernetline <--> open_flow_switch4.gateDataPlane++;
        open_flow_switch4.gateDataPlane++ <--> ethernetline <--> open_flow_switch5.gateDataPlane++;
        open_flow_switch5.gateDataPlane++ <--> ethernetline <--> open_flow_switch6.gateDataPlane++;
        open_flow_switch6.gateDataPlane++ <--> ethernetline <--> open_flow_switch1.gateDataPlane++;

        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch1.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch2.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch3.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch4.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch5.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch6.gateControlPlane++;

        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller1.ethg++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller2.ethg++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller_knroot.ethg++;


}
