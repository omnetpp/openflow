
import inet.common.INETDefs;
import inet.common.packet.chunk.Chunk;

cplusplus {{
    #include "openflow/openflow/protocol/openflow.h"
}};

class ofp_header
{
    @existingClass;
    @opaque;
//    @toString(.str());
}

// base class for all OpenFlow protocol messages; only contains the OpenFlow header
class Open_Flow_Message extends inet::FieldsChunk 
{
    ofp_header header;
}