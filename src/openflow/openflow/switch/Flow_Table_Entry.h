

#ifndef FLOW_TABLE_ENTRY_H_
#define FLOW_TABLE_ENTRY_H_

#include "openflow/openflow/protocol/openflow.h"
#include "openflow/messages/OFP_Flow_Mod_m.h"

using namespace __gnu_cxx;



struct flow_table_counters {

};

struct flow_table_flags {

};

struct flow_table_cookie {

};


struct ltmatch{
    bool operator() (const oxm_basic_match m1, const oxm_basic_match m2) const{
        if(m1.OFB_IN_PORT == m2.OFB_IN_PORT){
            return false;
        }else if(m1.OFB_ETH_TYPE == m2.OFB_ETH_TYPE){
            return false;
        }else if(m1.OFB_ETH_SRC == m2.OFB_ETH_SRC){
            return false;
        }else if(m1.OFB_ETH_DST == m2.OFB_ETH_DST){
            return false;
        }else if (m1.wildcards != m2.wildcards){
            return false;
        }else{
            return true;
        }
    }
};


class Flow_Table_Entry {
    public:
        Flow_Table_Entry();
        Flow_Table_Entry(const OFP_Flow_Mod *flowModMsg);

        flow_table_cookie getCookie() const;
        flow_table_counters getCounters() const;
        flow_table_flags getFlags() const;
        double getHardTimeout() const;
        double getIdleTimeout() const;
        SimTime getExpiresAt() const;
        ofp_action_output getInstructions() const;
        oxm_basic_match getMatch() const;
        int getPriority() const;

        void setCookie(flow_table_cookie cookie);
        void setCounters(flow_table_counters counters);
        void setFlags(flow_table_flags flags);
        void setHardTimeout(double hardTimeout);
        void setIdleTimeout(double idleTimeout);
        void setExpiresAt(SimTime expiresAt);
        void setInstructions(ofp_action_output instructions[1]);
        void setMatch(oxm_basic_match match);
        void setPriority(int priority);

    protected:
        oxm_basic_match match;
        flow_table_counters counters;
        ofp_action_output instructions[1];
        flow_table_cookie cookie;
        flow_table_flags flags;
        int priority;
        double idleTimeout;
        double hardTimeout;
        SimTime expiresAt;
};

#endif /* FLOW_TABLE_H_ */
