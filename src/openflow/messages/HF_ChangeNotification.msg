


import inet.common.INETDefs;
import inet.common.packet.chunk.Chunk;

cplusplus {{
    #include "openflow/hyperflow/HyperFlowStructs.h"   
}};

class DataChannelEntry
{
    @existingClass;
    @opaque;
//    @toString(.str());
}

// When packets are received by the data plane and sent to the connected controller,
// the OFP_PACKET_IN messages are used. If the complete packet needs to be sent to the controller, because it can not be
// stored in the bufer, it is encapsulated in the packet-in message.
class HF_ChangeNotification extends inet::FieldsChunk {
    DataChannelEntry entry;
}