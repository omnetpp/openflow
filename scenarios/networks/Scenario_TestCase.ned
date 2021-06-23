

package scenarios.networks;

import inet.common.misc.ThruputMeteringChannel;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.ethernet.EthernetSwitch;
import inet.node.inet.StandardHost;
import openflow.hyperflow.Hyper_Flow_Synchronizer;
import openflow.openflow.controller.Open_Flow_Controller;
import openflow.openflow.switch.Open_Flow_Switch;
import openflow.utility.ControllerInvolvementFilter;
import openflow.utility.StaticSpanningTree;


network Scenario_TestCase
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

        controllerInvolvementFilter: ControllerInvolvementFilter {
            @display("p=59,39");
        }

        hf_synchronizer: Hyper_Flow_Synchronizer if numControllers >=2 {
            @display("p=366,39");
        }

        clientG1[numClients]: StandardHost {
            @display("p=61,262");
        }
        clientG2[numClients]: StandardHost {
            @display("p=61,385");
        }
        clientG3[numClients]: StandardHost {
            @display("p=61,490");
        }
        clientG4[numClients]: StandardHost {
            @display("p=650,262");
        }
        clientG5[numClients]: StandardHost {
            @display("p=650,399");
        }
        clientG6[numClients]: StandardHost {
            @display("p=650,490");
        }

        configurator: Ipv4NetworkConfigurator {
            parameters:
                @display("p=61,175");
        }

        open_flow_switch1: Open_Flow_Switch {
            @display("p=206,306");
        }
        open_flow_switch2: Open_Flow_Switch {
            @display("p=206,366");
        }
        open_flow_switch3: Open_Flow_Switch {
            @display("p=212,457");
        }
        open_flow_switch4: Open_Flow_Switch {
            @display("p=366,306");
        }
        open_flow_switch5: Open_Flow_Switch {
            @display("p=366,366");
        }
        open_flow_switch6: Open_Flow_Switch {
            @display("p=366,457");
        }
        open_flow_switch7: Open_Flow_Switch {
            @display("p=497,306");
        }
        open_flow_switch8: Open_Flow_Switch {
            @display("p=497,366");
        }
        open_flow_switch9: Open_Flow_Switch {
            @display("p=497,457");
        }

        etherSwitch: EthernetSwitch {
            @display("p=366,141");
        }

        open_flow_controller1: Open_Flow_Controller if numControllers >=1 {
            @display("p=246,142");
        }
        open_flow_controller2: Open_Flow_Controller if numControllers >=2 {
            @display("p=246,50");
        }
        open_flow_controller3: Open_Flow_Controller if numControllers >=3 {
            @display("p=497,50");
        }
        open_flow_controller4: Open_Flow_Controller if numControllers >=4 {
            @display("p=497,142");
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
            clientG4[i].ethg++ <--> ethernetline <--> open_flow_switch7.gateDataPlane++;
        }

        for i=0..(numClients)-1 {
            clientG5[i].ethg++ <--> ethernetline <--> open_flow_switch8.gateDataPlane++;
        }

        for i=0..(numClients)-1 {
            clientG6[i].ethg++ <--> ethernetline <--> open_flow_switch9.gateDataPlane++;
        }

        open_flow_switch1.gateDataPlane++ <--> ethernetline <--> open_flow_switch4.gateDataPlane++;
        open_flow_switch1.gateDataPlane++ <--> ethernetline <--> open_flow_switch5.gateDataPlane++;
        open_flow_switch1.gateDataPlane++ <--> ethernetline <--> open_flow_switch6.gateDataPlane++;

        open_flow_switch2.gateDataPlane++ <--> ethernetline <--> open_flow_switch4.gateDataPlane++;
        open_flow_switch2.gateDataPlane++ <--> ethernetline <--> open_flow_switch5.gateDataPlane++;
        open_flow_switch2.gateDataPlane++ <--> ethernetline <--> open_flow_switch6.gateDataPlane++;

        open_flow_switch3.gateDataPlane++ <--> ethernetline <--> open_flow_switch4.gateDataPlane++;
        open_flow_switch3.gateDataPlane++ <--> ethernetline <--> open_flow_switch5.gateDataPlane++;
        open_flow_switch3.gateDataPlane++ <--> ethernetline <--> open_flow_switch6.gateDataPlane++;

        open_flow_switch7.gateDataPlane++ <--> ethernetline <--> open_flow_switch4.gateDataPlane++;
        open_flow_switch7.gateDataPlane++ <--> ethernetline <--> open_flow_switch5.gateDataPlane++;
        open_flow_switch7.gateDataPlane++ <--> ethernetline <--> open_flow_switch6.gateDataPlane++;

        open_flow_switch8.gateDataPlane++ <--> ethernetline <--> open_flow_switch4.gateDataPlane++;
        open_flow_switch8.gateDataPlane++ <--> ethernetline <--> open_flow_switch5.gateDataPlane++;
        open_flow_switch8.gateDataPlane++ <--> ethernetline <--> open_flow_switch6.gateDataPlane++;

        open_flow_switch9.gateDataPlane++ <--> ethernetline <--> open_flow_switch4.gateDataPlane++;
        open_flow_switch9.gateDataPlane++ <--> ethernetline <--> open_flow_switch5.gateDataPlane++;
        open_flow_switch9.gateDataPlane++ <--> ethernetline <--> open_flow_switch6.gateDataPlane++;


        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch1.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch2.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch3.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch4.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch5.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch6.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch7.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch8.gateControlPlane++;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_switch9.gateControlPlane++;

        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller1.ethg++ if numControllers >=1;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller2.ethg++ if numControllers >=2;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller3.ethg++ if numControllers >=3;
        etherSwitch.ethg++ <--> ethernetline <--> open_flow_controller4.ethg++ if numControllers >=4;
        etherSwitch.ethg++ <--> ethernetline <--> hf_synchronizer.ethg++ if numControllers >=2;


}
