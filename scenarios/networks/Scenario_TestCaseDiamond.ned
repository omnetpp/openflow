

package scenarios.networks;

import inet.common.misc.ThruputMeteringChannel;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.StandardHost;
import openflow.hyperflow.Hyper_Flow_Synchronizer;
import openflow.openflow.controller.Open_Flow_Controller;
import openflow.openflow.switch.Open_Flow_Switch;
import openflow.utility.OpenFlowGraphAnalyzer;
import openflow.utility.StaticSpanningTree;


network Scenario_TestCaseDiamond
{
    parameters:
        int numClients @display("bgb=768,465") = default(1);
        int numControllers @display("bgb=768,465") = default(1);

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

        hf_synchronizer: Hyper_Flow_Synchronizer if numControllers >=2 {
            @display("p=366,39");
        }

        clientG1[numClients]: StandardHost {
            @display("p=77,354");
        }
        clientG2[numClients]: StandardHost {
            @display("p=296,588");
        }
        clientG3[numClients]: StandardHost {
            @display("p=453,575");
        }

        clientG4[numClients]: StandardHost {
            @display("p=760,393");
        }
        clientG5[numClients]: StandardHost {
            @display("p=515,249");
        }
        clientG6[numClients]: StandardHost {
            @display("p=212,255");
        }

        configurator: IPv4NetworkConfigurator {
            parameters:
                @display("p=61,172");
        }

        open_flow_switch1: Open_Flow_Switch {
            @display("p=203,360");
        }
        open_flow_switch2: Open_Flow_Switch {
            @display("p=296,489");
        }
        open_flow_switch3: Open_Flow_Switch {
            @display("p=453,483");
        }
        open_flow_switch4: Open_Flow_Switch {
            @display("p=594,386");
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

        open_flow_controller1: Open_Flow_Controller if numControllers >=1 {
            @display("p=246,142");
        }
        open_flow_controller2: Open_Flow_Controller if numControllers >=2 {
            @display("p=520,136");
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

        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller1.ethg++ if numControllers >=1;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller2.ethg++ if numControllers >=2;
        etherSwitch.ethg++ <--> ethernetline <--> hf_synchronizer.ethg++ if numControllers >=2;


}
