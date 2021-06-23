

import inet.common.INETDefs;
import inet.common.packet.chunk.Chunk;

// When packets are received by the data plane and sent to the connected controller,
// the OFP_PACKET_IN messages are used. If the complete packet needs to be sent to the controller, because it can not be
// stored in the bufer, it is encapsulated in the packet-in message.
class LLDP  extends inet::FieldsChunk  {
    chunkLength = inet::B(21); // 3 TLV: TLV 6B+ variable length, at least 3*7
    int portID;
    string chassisID;
    double ttl;
}