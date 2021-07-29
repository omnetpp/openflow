
import inet.common.INETDefs;
import inet.common.packet.chunk.Chunk;
import openflow.messages.OpenFlowStructs; 

// base class for all OpenFlow protocol messages; only contains the OpenFlow header
class Open_Flow_Message extends inet::FieldsChunk 
{
    ofp_header header;
}