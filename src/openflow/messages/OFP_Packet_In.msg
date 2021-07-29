import openflow.messages.Open_Flow_Message;



// When packets are received by the data plane and sent to the connected controller,
// the OFP_PACKET_IN messages are used. If the complete packet needs to be sent to the controller, because it can not be
// stored in the bufer, it is encapsulated in the packet-in message.
class OFP_Packet_In extends Open_Flow_Message
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