

package openflow.nodes;

import inet.common.misc.ThruputMeteringChannel;
import inet.node.ethernet.EthernetSwitch;
import inet.node.inet.StandardHost;
import openflow.openflow.switch.Open_Flow_Switch;


//
// OpenFlow domain consisting of an OpenFlow switch and several hosts, but NO controller.
//
module Fat_Tree
{
    parameters:
        @display("bgb=2277,571;i=misc/cloud;is=vs;bgl=2");
        int iNumber = default(4);

    gates:
        inout gateCPlane[] @labels(ControlPlane-conn);

    types:
        channel ethernetline extends ThruputMeteringChannel
        {
            delay = 1us;
            datarate = 100Mbps;
            thruputDisplayFormat = "u";
        }
    submodules:

        coreLayerSwitches[iNumber]: Open_Flow_Switch {
            @display("p=306,55,row,90");
        }

        aggLayerSwitches[iNumber*2]: Open_Flow_Switch {
            @display("p=306,200,row,90");
        }

        edgeLayerSwitches[iNumber*2]: Open_Flow_Switch {
            @display("p=306,306,row,90");
        }

        etherSwitch: EthernetSwitch {
            @display("p=79,200");
        }

        client[iNumber*2*2]: StandardHost {
            @display("p=306,434,row,90");
        }

    connections allowunconnected:

        //core to agg

        for i=0..(iNumber*2)-1 {
            coreLayerSwitches[0].gateDataPlane++ <--> ethernetline <--> aggLayerSwitches[i].gateDataPlane++ if i%2==0;
            coreLayerSwitches[1].gateDataPlane++ <--> ethernetline <--> aggLayerSwitches[i].gateDataPlane++ if i%2==0;
        }

        for i=0..(iNumber*2)-1 {
            coreLayerSwitches[2].gateDataPlane++ <--> ethernetline <--> aggLayerSwitches[i].gateDataPlane++ if i%2==1;
            coreLayerSwitches[3].gateDataPlane++ <--> ethernetline <--> aggLayerSwitches[i].gateDataPlane++ if i%2==1;
        }

        //agg to edge
        for i=0..(iNumber*2)-1 {
            aggLayerSwitches[i].gateDataPlane++ <--> ethernetline <--> edgeLayerSwitches[i].gateDataPlane++ if i%2==0;
            aggLayerSwitches[i].gateDataPlane++ <--> ethernetline <--> edgeLayerSwitches[i+1].gateDataPlane++ if i%2==0;
            aggLayerSwitches[i+1].gateDataPlane++ <--> ethernetline <--> edgeLayerSwitches[i].gateDataPlane++ if i%2==0;
            aggLayerSwitches[i+1].gateDataPlane++ <--> ethernetline <--> edgeLayerSwitches[i+1].gateDataPlane++ if i%2==0;
        }

        //edge to host
        for i=0..(iNumber*2)-1 {
            edgeLayerSwitches[i].gateDataPlane++ <--> ethernetline <--> client[i*2].ethg++;
            edgeLayerSwitches[i].gateDataPlane++ <--> ethernetline <--> client[(i*2)+1].ethg++;
        }

        //cplane
        for i=0..(iNumber)-1 {
            coreLayerSwitches[i].gateControlPlane++ <--> ethernetline <--> etherSwitch.ethg++;
        }
        for i=0..(iNumber*2)-1 {
            aggLayerSwitches[i].gateControlPlane++ <--> ethernetline <--> etherSwitch.ethg++;
        }
        for i=0..(iNumber*2)-1 {
            edgeLayerSwitches[i].gateControlPlane++ <--> ethernetline <--> etherSwitch.ethg++;
        }

        for i=0..sizeof(gateCPlane)-1 {
            gateCPlane[i] <--> etherSwitch.ethg++;
        }

}

