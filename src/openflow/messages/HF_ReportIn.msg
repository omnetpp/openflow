
import inet.common.INETDefs;
import inet.common.packet.chunk.Chunk;

cplusplus {{
    #include "openflow/openflow/controller/Switch_Info.h"    
    typedef std::list<Switch_Info *> SwitchInfoList;
}};

class SwitchInfoList
{
    @existingClass;
    @opaque;
//    @toString(.str());
}


// When packets are received by the data plane and sent to the connected controller,
// the OFP_PACKET_IN messages are used. If the complete packet needs to be sent to the controller, because it can not be
// stored in the bufer, it is encapsulated in the packet-in message.
class HF_ReportIn  extends inet::FieldsChunk {
    string controllerId;
    SwitchInfoList switchInfoList; 
}