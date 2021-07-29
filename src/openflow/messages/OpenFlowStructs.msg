//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
//

cplusplus {{
    #include "openflow/openflow/protocol/openflow.h"
    inline std::ostream& operator<<(std::ostream& os, oxm_basic_match match)
    {
    	os << "OFB_ETH_TYPE: " << std::hex << match.OFB_ETH_TYPE << ", OFB_ETH_SRC: " << match.OFB_ETH_SRC;
    	os << ", OFB_ETH_DST: " << match.OFB_ETH_DST << ", OFB_IN_PORT: " << match.OFB_IN_PORT << endl; 
		os << ", OFB_ARP_OP: " << match.OFB_ARP_OP << ", OFB_ARP_SHA: " << match.OFB_ARP_SHA;
		os << ", OFB_ARP_THA: " << match.OFB_ARP_THA << ", OFB_ARP_SPA: " << match.OFB_ARP_SPA;
		os << ", OFB_ARP_TPA: " << match.OFB_ARP_TPA << endl;
		return os;
	}
	inline std::ostream& operator<<(std::ostream& os, ofp_action_output action)
    {
		os << "Port (hex): " << std::hex << action.port << endl;
		return os;
	}
}};

class ofp_action_output
{
    @existingClass;
    @opaque;
//    @toString(.str());
}

class oxm_basic_match
{
    @existingClass;
    @opaque;
 //   @toString(.str());
}
  
class ofp_header
{
    @existingClass;
    @opaque;
//    @toString(.str());
}
  