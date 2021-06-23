import openflow.messages.Open_Flow_Message;

cplusplus {{
    #include "openflow/openflow/protocol/openflow.h"
//    #include "openflow/messages/Open_Flow_Message_m.h"
//    #include "inet/linklayer/ethernet/EtherFrame_m.h"
    
    inline std::ostream& operator<<(std::ostream& os, ofp_action_output action)
    {
		os << "Port (hex): " << std::hex << action.port << endl;
		return os;
	}
}};

//struct ofp_action_header;
class ofp_action_output
{
    @existingClass;
    @opaque;
//    @toString(.str());
}


//struct ofp_action_output;
//class EthernetIIFrame;
//packet Open_Flow_Message;

//When the controller decides to send a packet out through the data plane, it uses the
//OFP PACKET OUT message.
packet OFP_Packet_Out extends Open_Flow_Message
{
	uint32_t buffer_id; // ID assigned by datapath (OFP_NO_BUFFER
                        //if none). 
	uint32_t in_port; // Packet�s input port or OFPP_CONTROLLER. 

	 ofp_action_output actions[]; // Action list. 
//	 EthernetIIFrame frame;
	 uint8_t data[];   // Packet data. The length is inferred
							//from the length field in the header.
							//(Only meaningful if buffer_id == -1.) 
}