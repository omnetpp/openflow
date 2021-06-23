import openflow.messages.Open_Flow_Message;

cplusplus {{
    #include "openflow/openflow/protocol/openflow.h"
//    #include "openflow/messages/Open_Flow_Message_m.h"
   #include "inet/linklayer/ethernet/EtherFrame_m.h"
    
    
    inline std::ostream& operator<<(std::ostream& os, oxm_basic_match match)
    {
    	os << "OFB_ETH_TYPE: " << std::hex << match.OFB_ETH_TYPE << ", OFB_ETH_SRC: " << match.OFB_ETH_SRC;
    	os << ", OFB_ETH_DST: " << match.OFB_ETH_DST << ", OFB_IN_PORT: " << match.OFB_IN_PORT << endl; 
		os << ", OFB_ARP_OP: " << match.OFB_ARP_OP << ", OFB_ARP_SHA: " << match.OFB_ARP_SHA;
		os << ", OFB_ARP_THA: " << match.OFB_ARP_THA << ", OFB_ARP_SPA: " << match.OFB_ARP_SPA;
		os << ", OFB_ARP_TPA: " << match.OFB_ARP_TPA << endl;
		return os;
	}
}};

class oxm_basic_match
{
    @existingClass;
    @opaque;
 //   @toString(.str());
}



//struct ofp_header;
//class EthernetIIFrame;
//struct oxm_basic_match;
//struct oxm_tlv;
//packet Open_Flow_Message;

// When packets are received by the data plane and sent to the connected controller,
// the OFP_PACKET_IN messages are used. If the complete packet needs to be sent to the controller, because it can not be
// stored in the bufer, it is encapsulated in the packet-in message.
packet OFP_Packet_In extends Open_Flow_Message
{
    uint32_t buffer_id;     // ID assigned by datapath. 
    uint16_t total_len;     // Full length of frame. 
    uint8_t reason;         // Reason packet is being sent (one of OFPR_*) 
//    EthernetIIFrame frame;
    oxm_basic_match match;
//   	oxm_tlv tlv[];
//    uint8_t data[0];        // Ethernet frame, halfway through 32-bit word,
                            // so the IP header is 32-bit aligned.  The
                            // amount of data is inferred from the length
                            // field in the header.  Because of padding,
                            // offsetof(struct ofp_packet_in, data) ==
                            // sizeof(struct ofp_packet_in) - 2. 
    
}