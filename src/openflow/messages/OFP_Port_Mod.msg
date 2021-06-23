import openflow.messages.Open_Flow_Message;
cplusplus {{
    #include "openflow/openflow/protocol/openflow.h"
 //   #include "openflow/messages/Open_Flow_Message_m.h"    
    
}};

//struct ofp_action_header;
//packet Open_Flow_Message;


packet OFP_Port_Mod extends Open_Flow_Message
{
	uint32_t port_no;
	//uint8_t pad[4];
	uint8_t hw_addr[6]; 
	//uint8_t pad2[2];        //Pad to 64 bits.
	uint32_t config;          //Bitmap of OFPPC_* flags.
	uint32_t mask;            //Bitmap of OFPPC_* flags to be changed.
	uint32_t advertise;       //Bitmap of OFPPF_*.  Zero all bits to prevent any action taking place.
	//uint8_t pad3[4];        //Pad to 64 bits
}