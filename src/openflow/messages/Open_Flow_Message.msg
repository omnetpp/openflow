
cplusplus {{
    #include "openflow/openflow/protocol/openflow.h"
}};

//class ofp_header extends void;
class ofp_header
{
    @existingClass;
    @opaque;
//    @toString(.str());
}

// base class for all OpenFlow protocol messages; only contains the OpenFlow header
packet Open_Flow_Message
{
    ofp_header header;
    
}