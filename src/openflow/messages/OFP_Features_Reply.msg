
import openflow.messages.Open_Flow_Message;
import inet.linklayer.common.MacAddress;

// response  to an OFP_Features_Request message
class OFP_Features_Reply extends Open_Flow_Message
{
  	string datapath_id;		// Datapath unique ID. The lower 48-bits are for a MAC address,
    					   	// while the upper 16-bits are implementer-defined.
//	MACAddress address;
    uint32_t n_buffers;		// Max packets buffered at once.
    
    uint8_t n_tables; 		// Number of tables supported by datapath.
    
    //Features
    uint32_t capabilities; 	// Bitmap of support "ofp_capabilities".
    uint32_t reserved;
    
    //Port info
    uint32_t ports[]; 		//Port definitions. The number of ports is inferred from the
    						// length field in the header.
}