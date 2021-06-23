

package scenarios.networks;

import inet.common.misc.ThruputMeteringChannel;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import openflow.nodes.DistanceChannel;
import openflow.nodes.Open_Flow_Domain;
import openflow.openflow.controller.Open_Flow_Controller;
import openflow.utility.OpenFlowGraphAnalyzer;
import openflow.utility.StaticSpanningTree;


network Scenario_USA
{
    @display("bgb=842,642;bgi=maps/usa");



    types:
        channel backboneline extends ThruputMeteringChannel
        {
            delay = 1us;
            datarate = 40Gbps;
            thruputDisplayFormat = "u";
        }
    submodules:
        configurator: IPv4NetworkConfigurator {
            parameters:
                @display("p=449,598");
        }

        spanningTree: StaticSpanningTree {
            @display("p=349,598");
        }

        openFlowGraphAnalyzer: OpenFlowGraphAnalyzer {
            @display("p=218,598");
        }

        open_flow_controller1: Open_Flow_Controller {
            @display("p=403,39");
        }


        //		0
        ofs_Vancouver: Open_Flow_Domain {
            @display("p=108,10");
        }
        //		1
        ofs_Seattle: Open_Flow_Domain {
            @display("p=78,49");
        }

        //		2
        ofs_Portland: Open_Flow_Domain {
            @display("p=69,88");
        }

        //		3
        ofs_Sunnyvale: Open_Flow_Domain {
            @display("p=39,254");
        }

        //		4
        ofs_LosAngeles: Open_Flow_Domain {
            @display("p=66,287");
        }

        //		5
        ofs_Missoula: Open_Flow_Domain {
            @display("p=187,88");
        }

        //		6
        ofs_SaltLakeCity: Open_Flow_Domain {
            @display("p=168,207");
        }

        //		7
        ofs_Phoenix: Open_Flow_Domain {
            @display("p=150,314");
        }

        //		8
        ofs_Denver: Open_Flow_Domain {
            @display("p=250,234");
        }

        //		9
        ofs_Albuqerque: Open_Flow_Domain {
            @display("p=230,293");
        }

        //		10
        ofs_ElPaso: Open_Flow_Domain {
            @display("p=257,363");
        }

        //		11
        ofs_Minneapolis: Open_Flow_Domain {
            @display("p=415,135");
        }

        //		12
        ofs_KansasCity: Open_Flow_Domain {
            @display("p=396,246");
        }

        //		13
        ofs_Dallas: Open_Flow_Domain {
            @display("p=376,347");
        }

        //		14
        ofs_Houston: Open_Flow_Domain {
            @display("p=415,404");
        }

        //		15
        ofs_Chicago: Open_Flow_Domain {
            @display("p=483,184");
        }

        //		16
        ofs_Indianapolis: Open_Flow_Domain {
            @display("p=522,223");
        }

        //		17
        ofs_Louisville: Open_Flow_Domain {
            @display("p=528,254");
        }

        //		18
        ofs_Nashville: Open_Flow_Domain {
            @display("p=504,301");
        }
        //		19
        ofs_Memphis: Open_Flow_Domain {
            @display("p=465,314");
        }
        //		20
        ofs_Jackson: Open_Flow_Domain {
            @display("p=465,363");
        }

        //		21
        ofs_BatonRouge: Open_Flow_Domain {
            @display("p=468,390");
        }

        //		22
        ofs_Cleveland: Open_Flow_Domain {
            @display("p=576,174");
        }

        //		23
        ofs_Pittsburgh: Open_Flow_Domain {
            @display("p=600,196");
        }
        //		24
        ofs_Atlanta: Open_Flow_Domain {
            @display("p=549,332");
        }
        //		25
        ofs_Jacksonville: Open_Flow_Domain {
            @display("p=600,378");
        }
        //		26
        ofs_Buffalo: Open_Flow_Domain {
            @display("p=607,156");
        }
        //		27
        ofs_Ashburn: Open_Flow_Domain {
            @display("p=623,207");
        }
        //		28
        ofs_Raleigh: Open_Flow_Domain {
            @display("p=632,275");
        }

        //		29
        ofs_WashingtonDC: Open_Flow_Domain {
            @display("p=655,215");
        }

        //		30
        ofs_Miami: Open_Flow_Domain {
            @display("p=632,443");
        }
        //		31
        ofs_Philadelphia: Open_Flow_Domain {
            @display("p=655,196");
        }
        //		32
        ofs_NewYork: Open_Flow_Domain {
            @display("p=681,174");
        }
        //		33
        //ofs_Bridgeport: OpenFlow_Domain {
              //@display("p=706,162");
        //}

        //		33
        ofs_Boston: Open_Flow_Domain {
            @display("p=720,135");
        }


    connections allowunconnected:
        ofs_LosAngeles.gateDPlane++ <--> DistanceChannel {  distance = 575km; } <--> ofs_Phoenix.gateDPlane++;
        ofs_Phoenix.gateDPlane++ <--> DistanceChannel {  distance = 557km; } <--> ofs_ElPaso.gateDPlane++;
        ofs_ElPaso.gateDPlane++ <--> DistanceChannel {  distance = 369km; } <--> ofs_Albuqerque.gateDPlane++;
        ofs_ElPaso.gateDPlane++ <--> DistanceChannel {  distance = 1087km; } <--> ofs_Houston.gateDPlane++;
        ofs_Albuqerque.gateDPlane++ <--> DistanceChannel {  distance = 537km; } <--> ofs_Denver.gateDPlane++;
        ofs_Denver.gateDPlane++ <--> DistanceChannel {  distance = 898km; } <--> ofs_KansasCity.gateDPlane++;
        ofs_Missoula.gateDPlane++ <--> DistanceChannel {  distance = 1617km; } <--> ofs_Minneapolis.gateDPlane++;
        ofs_Minneapolis.gateDPlane++ <--> DistanceChannel {  distance = 572km; } <--> ofs_Chicago.gateDPlane++;
        ofs_Houston.gateDPlane++ <--> DistanceChannel {  distance = 362km; } <--> ofs_Dallas.gateDPlane++;
        ofs_Dallas.gateDPlane++ <--> DistanceChannel {  distance = 729km; } <--> ofs_KansasCity.gateDPlane++;
        ofs_KansasCity.gateDPlane++ <--> DistanceChannel {  distance = 662km; } <--> ofs_Chicago.gateDPlane++;
        ofs_Chicago.gateDPlane++ <--> DistanceChannel {  distance = 263km; } <--> ofs_Indianapolis.gateDPlane++;
        ofs_Houston.gateDPlane++ <--> DistanceChannel {  distance = 413km; } <--> ofs_BatonRouge.gateDPlane++;
        ofs_BatonRouge.gateDPlane++ <--> DistanceChannel {  distance = 913km; } <--> ofs_Jacksonville.gateDPlane++;
        ofs_Jacksonville.gateDPlane++ <--> DistanceChannel {  distance = 525km; } <--> ofs_Miami.gateDPlane++;
        ofs_Jacksonville.gateDPlane++ <--> DistanceChannel {  distance = 458km; } <--> ofs_Atlanta.gateDPlane++;
        ofs_Atlanta.gateDPlane++ <--> DistanceChannel {  distance = 346km; } <--> ofs_Nashville.gateDPlane++;
        ofs_Atlanta.gateDPlane++ <--> DistanceChannel {  distance = 572km; } <--> ofs_Raleigh.gateDPlane++;
        ofs_Houston.gateDPlane++ <--> DistanceChannel {  distance = 569km; } <--> ofs_Jackson.gateDPlane++;
        ofs_Jackson.gateDPlane++ <--> DistanceChannel {  distance = 316km; } <--> ofs_Memphis.gateDPlane++;
        ofs_Memphis.gateDPlane++ <--> DistanceChannel {  distance = 306km; } <--> ofs_Nashville.gateDPlane++;
        ofs_Nashville.gateDPlane++ <--> DistanceChannel {  distance = 249km; } <--> ofs_Louisville.gateDPlane++;
        ofs_Louisville.gateDPlane++ <--> DistanceChannel {  distance = 172km; } <--> ofs_Indianapolis.gateDPlane++;
        ofs_Raleigh.gateDPlane++ <--> DistanceChannel {  distance = 375km; } <--> ofs_WashingtonDC.gateDPlane++;
        ofs_WashingtonDC.gateDPlane++ <--> DistanceChannel {  distance = 55km; } <--> ofs_Ashburn.gateDPlane++;
        ofs_WashingtonDC.gateDPlane++ <--> DistanceChannel {  distance = 199km; } <--> ofs_Philadelphia.gateDPlane++;
        ofs_Philadelphia.gateDPlane++ <--> DistanceChannel {  distance = 130km; } <--> ofs_NewYork.gateDPlane++;
        ofs_Chicago.gateDPlane++ <--> DistanceChannel {  distance = 497km; } <--> ofs_Cleveland.gateDPlane++;
        ofs_Cleveland.gateDPlane++ <--> DistanceChannel {  distance = 279km; } <--> ofs_Buffalo.gateDPlane++;
        ofs_Buffalo.gateDPlane++ <--> DistanceChannel {  distance = 644km; } <--> ofs_Boston.gateDPlane++;
        ofs_Cleveland.gateDPlane++ <--> DistanceChannel {  distance = 185km; } <--> ofs_Pittsburgh.gateDPlane++;
        ofs_Pittsburgh.gateDPlane++ <--> DistanceChannel {  distance = 360km; } <--> ofs_Ashburn.gateDPlane++;
        ofs_NewYork.gateDPlane++ <--> DistanceChannel {  distance = 306km; } <--> ofs_Boston.gateDPlane++;
        ofs_Portland.gateDPlane++ <--> DistanceChannel {  distance = 907km; } <--> ofs_Sunnyvale.gateDPlane++;
        ofs_Sunnyvale.gateDPlane++ <--> DistanceChannel {  distance = 503km; } <--> ofs_LosAngeles.gateDPlane++;
        ofs_Sunnyvale.gateDPlane++ <--> DistanceChannel {  distance = 955km; } <--> ofs_SaltLakeCity.gateDPlane++;
        ofs_Denver.gateDPlane++ <--> DistanceChannel {  distance = 598km; } <--> ofs_SaltLakeCity.gateDPlane++;
        ofs_LosAngeles.gateDPlane++ <--> DistanceChannel {  distance = 934km; } <--> ofs_SaltLakeCity.gateDPlane++;
        ofs_Vancouver.gateDPlane++ <--> DistanceChannel {  distance = 194km; } <--> ofs_Seattle.gateDPlane++;
        ofs_Seattle.gateDPlane++ <--> DistanceChannel {  distance = 635km; } <--> ofs_Missoula.gateDPlane++;
        ofs_Seattle.gateDPlane++ <--> DistanceChannel {  distance = 233km; } <--> ofs_Portland.gateDPlane++;
        ofs_Seattle.gateDPlane++ <--> DistanceChannel {  distance = 1128km; } <--> ofs_SaltLakeCity.gateDPlane++;


        ofs_LosAngeles.gateCPlane++ <--> DistanceChannel {  distance = 575km; } <--> ofs_Phoenix.gateCPlane++;
        //ofs_Phoenix.gateCPlane++ <--> DistanceChannel {  distance = 557km; } <--> ofs_ElPaso.gateCPlane++;
        //ofs_ElPaso.gateCPlane++ <--> DistanceChannel {  distance = 369km; } <--> ofs_Albuqerque.gateCPlane++;
        ofs_ElPaso.gateCPlane++ <--> DistanceChannel {  distance = 1087km; } <--> ofs_Houston.gateCPlane++;
        ofs_Albuqerque.gateCPlane++ <--> DistanceChannel {  distance = 537km; } <--> ofs_Denver.gateCPlane++;
        ofs_Denver.gateCPlane++ <--> DistanceChannel {  distance = 898km; } <--> ofs_KansasCity.gateCPlane++;
        ofs_Missoula.gateCPlane++ <--> DistanceChannel {  distance = 1617km; } <--> ofs_Minneapolis.gateCPlane++;
        ofs_Minneapolis.gateCPlane++ <--> DistanceChannel {  distance = 572km; } <--> ofs_Chicago.gateCPlane++;
        ofs_Houston.gateCPlane++ <--> DistanceChannel {  distance = 362km; } <--> ofs_Dallas.gateCPlane++;
        ofs_Dallas.gateCPlane++ <--> DistanceChannel {  distance = 729km; } <--> ofs_KansasCity.gateCPlane++;
        ofs_KansasCity.gateCPlane++ <--> DistanceChannel {  distance = 662km; } <--> ofs_Chicago.gateCPlane++;
        ofs_Chicago.gateCPlane++ <--> DistanceChannel {  distance = 263km; } <--> ofs_Indianapolis.gateCPlane++;
        ofs_Houston.gateCPlane++ <--> DistanceChannel {  distance = 413km; } <--> ofs_BatonRouge.gateCPlane++;
        ofs_BatonRouge.gateCPlane++ <--> DistanceChannel {  distance = 913km; } <--> ofs_Jacksonville.gateCPlane++;
        ofs_Jacksonville.gateCPlane++ <--> DistanceChannel {  distance = 525km; } <--> ofs_Miami.gateCPlane++;
        //ofs_Jacksonville.gateCPlane++ <--> DistanceChannel {  distance = 458km; } <--> ofs_Atlanta.gateCPlane++;
        ofs_Atlanta.gateCPlane++ <--> DistanceChannel {  distance = 346km; } <--> ofs_Nashville.gateCPlane++;
        ofs_Atlanta.gateCPlane++ <--> DistanceChannel {  distance = 572km; } <--> ofs_Raleigh.gateCPlane++;
        ofs_Houston.gateCPlane++ <--> DistanceChannel {  distance = 569km; } <--> ofs_Jackson.gateCPlane++;
        //ofs_Jackson.gateCPlane++ <--> DistanceChannel {  distance = 316km; } <--> ofs_Memphis.gateCPlane++;
        ofs_Memphis.gateCPlane++ <--> DistanceChannel {  distance = 306km; } <--> ofs_Nashville.gateCPlane++;
        ofs_Nashville.gateCPlane++ <--> DistanceChannel {  distance = 249km; } <--> ofs_Louisville.gateCPlane++;
        ofs_Louisville.gateCPlane++ <--> DistanceChannel {  distance = 172km; } <--> ofs_Indianapolis.gateCPlane++;
        //ofs_Raleigh.gateCPlane++ <--> DistanceChannel {  distance = 375km; } <--> ofs_WashingtonDC.gateCPlane++;
        ofs_WashingtonDC.gateCPlane++ <--> DistanceChannel {  distance = 55km; } <--> ofs_Ashburn.gateCPlane++;
        ofs_WashingtonDC.gateCPlane++ <--> DistanceChannel {  distance = 199km; } <--> ofs_Philadelphia.gateCPlane++;
        ofs_Philadelphia.gateCPlane++ <--> DistanceChannel {  distance = 130km; } <--> ofs_NewYork.gateCPlane++;
        ofs_Chicago.gateCPlane++ <--> DistanceChannel {  distance = 497km; } <--> ofs_Cleveland.gateCPlane++;
        ofs_Cleveland.gateCPlane++ <--> DistanceChannel {  distance = 279km; } <--> ofs_Buffalo.gateCPlane++;
        ofs_Buffalo.gateCPlane++ <--> DistanceChannel {  distance = 644km; } <--> ofs_Boston.gateCPlane++;
        ofs_Cleveland.gateCPlane++ <--> DistanceChannel {  distance = 185km; } <--> ofs_Pittsburgh.gateCPlane++;
        ofs_Pittsburgh.gateCPlane++ <--> DistanceChannel {  distance = 360km; } <--> ofs_Ashburn.gateCPlane++;
        //ofs_NewYork.gate++ <--> DistanceChannel {  distance = 84km; } <--> ofs_Bridgeport.gate++;
        //ofs_Bridgeport.gate++ <--> DistanceChannel {  distance = 222km; } <--> ofs_Boston.gate++;
        //ofs_NewYork.gateCPlane++ <--> DistanceChannel {  distance = 306km; } <--> ofs_Boston.gateCPlane++;
        //ofs_Portland.gateCPlane++ <--> DistanceChannel {  distance = 907km; } <--> ofs_Sunnyvale.gateCPlane++;
        //ofs_Sunnyvale.gateCPlane++ <--> DistanceChannel {  distance = 503km; } <--> ofs_LosAngeles.gateCPlane++;
        ofs_Sunnyvale.gateCPlane++ <--> DistanceChannel {  distance = 955km; } <--> ofs_SaltLakeCity.gateCPlane++;
        ofs_Denver.gateCPlane++ <--> DistanceChannel {  distance = 598km; } <--> ofs_SaltLakeCity.gateCPlane++;
        ofs_LosAngeles.gateCPlane++ <--> DistanceChannel {  distance = 934km; } <--> ofs_SaltLakeCity.gateCPlane++;
        ofs_Vancouver.gateCPlane++ <--> DistanceChannel {  distance = 194km; } <--> ofs_Seattle.gateCPlane++;
        ofs_Seattle.gateCPlane++ <--> DistanceChannel {  distance = 635km; } <--> ofs_Missoula.gateCPlane++;
        ofs_Seattle.gateCPlane++ <--> DistanceChannel {  distance = 233km; } <--> ofs_Portland.gateCPlane++;
        //ofs_Seattle.gateCPlane++ <--> DistanceChannel {  distance = 1128km; } <--> ofs_SaltLakeCity.gateCPlane++;



		//numC 1
        ofs_KansasCity.gateCPlane++ <--> backboneline <--> open_flow_controller1.ethg++;


}
