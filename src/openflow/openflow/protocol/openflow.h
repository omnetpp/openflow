

#ifndef OPENFLOW_H_
#define OPENFLOW_H_

#define OFP_VERSION   0x01
#define OFP_MAX_PORT_NAME_LEN 16
#define OFP_ETH_ALEN 6

#include "inet/linklayer/common/MacAddress.h"
#include "inet/networklayer/contract/ipv4/Ipv4Address.h"

using namespace inet;

struct oxm_basic_match {
    int OFB_IN_PORT;
    MacAddress OFB_ETH_DST;
    MacAddress OFB_ETH_SRC;
    int OFB_ETH_TYPE;
    Ipv4Address OFB_IPV4_DST;
    int OFB_ARP_OP; /* ARP opcode. */
    Ipv4Address OFB_ARP_SPA; /* ARP source IPv4 address. */
    Ipv4Address OFB_ARP_TPA; /* ARP target IPv4 address. */
    MacAddress OFB_ARP_SHA; /* ARP source hardware address. */
    MacAddress OFB_ARP_THA; /* ARP target hardware address. */
    uint32_t wildcards;
    int getPriority();
};

inline bool operator==(const oxm_basic_match &m1, const oxm_basic_match& m2) {
    return m2.OFB_IN_PORT == m1.OFB_IN_PORT
            && m2.OFB_ETH_DST == m1.OFB_ETH_DST
            && m2.OFB_ETH_SRC == m1.OFB_ETH_SRC
            && m2.OFB_ETH_TYPE == m1.OFB_ETH_TYPE
            && m2.OFB_ARP_OP == m1.OFB_ARP_OP
            && m2.OFB_ARP_SHA == m1.OFB_ARP_SHA
            && m2.OFB_ARP_SPA == m1.OFB_ARP_SPA
            && m2.OFB_ARP_THA == m1.OFB_ARP_THA
            && m2.OFB_ARP_TPA == m1.OFB_ARP_TPA;
}

struct oxm_tlv {
    uint16_t oxm_class; /* One of ofp_oxm_class */
    uint8_t oxm_field; /* One of oxm_ofb_match_fields */
    bool oxm_hasmask;
    uint8_t oxm_length;
    void *value;
};

/* Fields to match against flows */
struct ofp_match {
    uint16_t type; /* One of OFPMT_* */
    uint16_t length; /* Length of ofp_match (excluding padding) */
    /* Followed by:
    * -Exactly (length - 4) (possibly 0) bytes containing OXM TLVs,then
    * -Exactly ((length+7)/8*8-length)(between 0 and 7) bytes of
    * all-zerobytes
    * In summary, ofp_match is padded as needed, to make its overall size
    * a multiple of 8, to preserve alignement in structures using it.
    */
    uint8_t oxm_fields[4]; /* OXMs start here - Make compiler happy */
};
//ASSERT(sizeof(struct ofp_match) == 8);

/* The match type indicates the match structure (set of fields that compose the
* match) in use. The match type is placed in the type field at the beginning
* of all match structures. The "OpenFlow Extensible Match" type corresponds
* to OXM TLV format described below and must be supported by all OpenFlow
* switches. Extensions that define other match types may be published on the
* ONF wiki. Support for extensions is optional.
*/
enum ofp_match_type {
    OFPMT_STANDARD = 0, /* Deprecated. */
    OFPMT_OXM = 1, /* OpenFlow Extensible Match */
};

/* OXM Class IDs.
* The high order bit differentiate reserved classes from member classes.
* Classes 0x0000 to 0x7FFF are member classes, allocated by ONF.
* Classes 0x8000 to 0xFFFE are reserved classes, reserved for standardisation.
*/
enum ofp_oxm_class {
    OFPXMC_NXM_0 = 0x0000, /* Backward compatibility with NXM */
    OFPXMC_NXM_1 = 0x0001, /* Backward compatibility with NXM */
    OFPXMC_OPENFLOW_BASIC = 0x8000, /* Basic class for OpenFlow */
    OFPXMC_EXPERIMENTER = 0xFFFF, /* Experimenter class */
};

/* OXM Flow match field types for OpenFlow basic class. */
enum oxm_ofb_match_fields {
    OFPXMT_OFB_IN_PORT = 0, /* Switch input port. */
    OFPXMT_OFB_IN_PHY_PORT = 1, /* Switch physical input port. */
    OFPXMT_OFB_METADATA = 2, /* Metadata passed between tables. */
    OFPXMT_OFB_ETH_DST = 3, /* Ethernet destination address. */
    OFPXMT_OFB_ETH_SRC = 4, /* Ethernet source address. */
    OFPXMT_OFB_ETH_TYPE = 5, /* Ethernet frame type. */
    OFPXMT_OFB_VLAN_VID = 6, /* VLAN id. */
    OFPXMT_OFB_VLAN_PCP = 7, /* VLAN priority. */
    OFPXMT_OFB_IP_DSCP = 8, /* IP DSCP (6 bits in ToS field). */
    OFPXMT_OFB_IP_ECN = 9, /* IP ECN (2 bits in ToS field). */
    OFPXMT_OFB_IP_PROTO = 10, /* IP protocol. */
    OFPXMT_OFB_IPV4_SRC = 11, /* IPv4 source address. */
    OFPXMT_OFB_IPV4_DST = 12, /* IPv4 destination address. */
    OFPXMT_OFB_TCP_SRC = 13, /* TCP source port. */
    OFPXMT_OFB_TCP_DST = 14, /* TCP destination port. */
    OFPXMT_OFB_UDP_SRC = 15, /* UDP source port. */
    OFPXMT_OFB_UDP_DST = 16, /* UDP destination port. */
    OFPXMT_OFB_SCTP_SRC = 17, /* SCTP source port. */
    OFPXMT_OFB_SCTP_DST = 18, /* SCTP destination port. */
    OFPXMT_OFB_ICMPV4_TYPE = 19, /* ICMP type. */
    OFPXMT_OFB_ICMPV4_CODE = 20, /* ICMP code. */
    OFPXMT_OFB_ARP_OP = 21, /* ARP opcode. */
    OFPXMT_OFB_ARP_SPA = 22, /* ARP source IPv4 address. */
    OFPXMT_OFB_ARP_TPA = 23, /* ARP target IPv4 address. */
    OFPXMT_OFB_ARP_SHA = 24, /* ARP source hardware address. */
    OFPXMT_OFB_ARP_THA = 25, /* ARP target hardware address. */
    OFPXMT_OFB_IPV6_SRC = 26, /* IPv6 source address. */
    OFPXMT_OFB_IPV6_DST = 27, /* IPv6 destination address. */
    OFPXMT_OFB_IPV6_FLABEL = 28, /* IPv6 Flow Label */
    OFPXMT_OFB_ICMPV6_TYPE = 29, /* ICMPv6 type. */
    OFPXMT_OFB_ICMPV6_CODE = 30, /* ICMPv6 code. */
    OFPXMT_OFB_IPV6_ND_TARGET = 31, /* Target address for ND. */
    OFPXMT_OFB_IPV6_ND_SLL = 32, /* Source link-layer for ND. */
    OFPXMT_OFB_IPV6_ND_TLL = 33, /* Target link-layer for ND. */
    OFPXMT_OFB_MPLS_LABEL = 34, /* MPLS label. */
    OFPXMT_OFB_MPLS_TC = 35, /* MPLS TC. */
};

/* Flow wildcards. */
enum ofp_flow_wildcards {
    OFPFW_IN_PORT = 1 << 0, /* Switch input port. */
    OFPFW_DL_VLAN = 1 << 1, /* VLAN id. */
    OFPFW_DL_SRC = 1 << 2, /* Ethernet source address. */
    OFPFW_DL_DST = 1 << 3, /* Ethernet destination address. */
    OFPFW_DL_TYPE = 1 << 4, /* Ethernet frame type. */
    OFPFW_NW_PROTO = 1 << 5, /* IP protocol. */
    OFPFW_TP_SRC = 1 << 6, /* TCP/UDP source port. */
    OFPFW_TP_DST = 1 << 7, /* TCP/UDP destination port. */

    /* IP source address wildcard bit count.  0 is exact match, 1 ignores the
     * LSB, 2 ignores the 2 least-significant bits, ..., 32 and higher wildcard
     * the entire field.  This is the *opposite* of the usual convention where
     * e.g. /24 indicates that 8 bits (not 24 bits) are wildcarded. */
    OFPFW_NW_SRC_SHIFT = 8,
    OFPFW_NW_SRC_BITS = 6,
    OFPFW_NW_SRC_MASK = ((1 << OFPFW_NW_SRC_BITS) - 1) << OFPFW_NW_SRC_SHIFT,
    OFPFW_NW_SRC_ALL = 32 << OFPFW_NW_SRC_SHIFT,

    /* IP destination address wildcard bit count.  Same format as source. */
    OFPFW_NW_DST_SHIFT = 14,
    OFPFW_NW_DST_BITS = 6,
    OFPFW_NW_DST_MASK = ((1 << OFPFW_NW_DST_BITS) - 1) << OFPFW_NW_DST_SHIFT,
    OFPFW_NW_DST_ALL = 32 << OFPFW_NW_DST_SHIFT,

    OFPFW_DL_VLAN_PCP = 1 << 20, /* VLAN priority. */
    OFPFW_NW_TOS = 1 << 21, /* IP ToS (DSCP field, 6 bits). */

    /* Wildcard all fields. */
    OFPFW_ALL = ((1 << 22) - 1)
};

enum ofp_type {
    /* Immutable messages. */
    OFPT_HELLO, /* Symmetric message */
    OFPT_ERROR, /* Symmetric message */
    OFPT_ECHO_REQUEST, /* Symmetric message */
    OFPT_ECHO_REPLY, /* Symmetric message */
    OFPT_VENDOR, /* Symmetric message */

    /* Switch configuration messages. */
    OFPT_FEATURES_REQUEST, /* Controller/switch message */
    OFPT_FEATURES_REPLY, /* Controller/switch message */
    OFPT_GET_CONFIG_REQUEST, /* Controller/switch message */
    OFPT_GET_CONFIG_REPLY, /* Controller/switch message */
    OFPT_SET_CONFIG, /* Controller/switch message */

    /* Asynchronous messages. */
    OFPT_PACKET_IN, /* Async message */
    OFPT_FLOW_REMOVED, /* Async message */
    OFPT_PORT_STATUS, /* Async message */

    /* Controller command messages. */
    OFPT_PACKET_OUT, /* Controller/switch message */
    OFPT_FLOW_MOD, /* Controller/switch message */
    OFPT_PORT_MOD, /* Controller/switch message */
    /* Statistics messages. */
    OFPT_STATS_REQUEST, /* Controller/switch message */
    OFPT_STATS_REPLY, /* Controller/switch message */

    /* Barrier messages. */
    OFPT_BARRIER_REQUEST, /* Controller/switch message */
    OFPT_BARRIER_REPLY, /* Controller/switch message */

    /* Queue Configuration messages. */
    OFPT_QUEUE_GET_CONFIG_REQUEST, /* Controller/switch message */
    OFPT_QUEUE_GET_CONFIG_REPLY
/* Controller/switch message */

};

struct ofp_header {
    uint8_t version; /*OFP_VERSION. */
    uint8_t type; /*One of the OFPT_ constants. */
    uint16_t length; /*Length including this ofp_header. */
    uint32_t xid; /*Transaction id associated with this packet.
     Replies use the same id as was in the request
     to facilitate pairing. */
};

const uint32_t OFP_NO_BUFFER = 0xffffffff;

/* Packet received on port (datapath -> controller). */
struct ofp_packet_in {
    struct ofp_header header;
    uint32_t buffer_id; /* ID assigned by datapath. */
    uint16_t total_len; /* Full length of frame. */
    uint8_t reason; /* Reason packet is being sent (one of OFPR_*) */
    uint8_t table_id; /* ID of the table that was looked up */
    struct oxm_basic_match; /* Packet metadata. Variable size. */
    /* Followed by:
     * -Exactly2all-zeropaddingbytes,then
     * -AnEthernetframewhoselengthisinferredfromheader.length.
     * The padding bytes preceding the Ethernet frame ensure that the IP
     * header (if any) following the Ethernet header is 32-bit aligned.
     */
    uint8_t pad[2]; /* Align to 64 bit + 16 bit */
    uint8_t data[0]; /* Ethernet frame */
};

/* Why is this packet being sent to the controller? */
enum ofp_packet_in_reason {
    OFPR_NO_MATCH = 0, /* No matching flow. */
    OFPR_ACTION = 1, /* Action explicitly output to controller. */
    OFPR_INVALID_TTL = 2,
/* Packet has invalid TTL */
};

/* Send packet (controller -> datapath). */
struct ofp_action_header {
    uint16_t type; /* One of OFPAT_*. */
    uint16_t len; /* Length of action, including this
     header.  This is the length of action,
     including any padding to make it
     64-bit aligned. */
    uint8_t pad[4];
//protected:
//    virtual void doNothing();
};

struct ofp_packet_out {
    struct ofp_header header;
    uint32_t buffer_id; /* ID assigned by datapath (OFP_NO_BUFFER
     if none). */
    uint32_t in_port; /* Packet�s input port or OFPP_CONTROLLER. */
    uint16_t actions_len; /* Size of action array in bytes. */
    uint8_t pad[6];
    struct ofp_action_header actions[0]; /* Action list. */
    /* uint8_t data[0]; *//* Packet data. The length is inferred
     from the length field in the header.
     (Only meaningful if buffer_id == -1.) */
};



/* Action structure for OFPAT_OUTPUT, which sends packets out port.
 * When the port is the OFPP_CONTROLLER, max_len indicates the max
 * number of bytes to send. A max_len of zero means no bytes of the
 * packet should be sent. A max_len of OFPCML_NO_BUFFER means that
 * the packet is not buffered and the complete packet is to be sent to
 * the controller. */
class ofp_action_output: public ofp_action_header {
public:
//    uint16_t len; /* Length is 16. */
    uint32_t port; /* Output port. */
//    uint16_t max_len; /* Max length to send to controller. */
//    uint8_t pad[6]; /* Pad to 64 bits. */
//protected:
//    virtual void doNothing();
     std::string creationModule;
};

/* Flow setup and teardown (controller -> datapath). */

enum ofp_flow_mod_command {
    OFPFC_ADD = 0, /* New flow. */
    OFPFC_MODIFY = 1, /* Modify all matching flows. */
    OFPFC_MODIFY_STRICT = 2, /* Modify entry strictly matching wildcards and
     priority. */
    OFPFC_DELETE = 3, /* Delete all matching flows. */
    OFPFC_DELETE_STRICT = 4,
/* Delete entry strictly matching wildcards and
 priority. */
};



/* Description of a port */
struct ofp_port {
    uint32_t port_no;
    //uint8_t pad[4];
    uint8_t hw_addr[OFP_ETH_ALEN];
    //uint8_t pad2[2];                  /* Align to 64 bits. */
    char name[OFP_MAX_PORT_NAME_LEN]; /* Null-terminated */
    uint32_t config;        /* Bitmap of OFPPC_* flags. */
    uint32_t state;         /* Bitmap of OFPPS_* flags. */
    /* Bitmaps of OFPPF_* that describe features.  All bits zeroed if
    * unsupported or unavailable. */
    uint32_t curr;          /* Current features. */
    uint32_t advertised;    /* Features being advertised by the port. */
    uint32_t supported;     /* Features supported by the port. */
    uint32_t peer;          /* Features advertised by peer. */
    uint32_t curr_speed;    /* Current port bitrate in kbps. */
    uint32_t max_speed;     /* Max port bitrate in kbps */
};

enum ofp_port_config {
    OFPPC_PORT_DOWN    = 1 << 0,  /* Port is administratively down. */
    OFPPC_NO_RECV      = 1 << 2,  /* Drop all packets received by port. */
    OFPPC_NO_FWD       = 1 << 5,  /* Drop packets forwarded to port. */
    OFPPC_NO_PACKET_IN = 1 << 6   /* Do not send packet-in msgs for port. */
};

enum ofp_port_state {
    OFPPS_LINK_DOWN    = 1 << 0,  /* No physical link present. */
    OFPPS_BLOCKED      = 1 << 1,  /* Port is blocked */
    OFPPS_LIVE         = 1 << 2,  /* Live for Fast Failover Group. */
};


enum ofp_port_no {
    /* Maximum number of physical and logical switch ports. */
    OFPP_MAX        = 0xffffff00,
    /* Reserved OpenFlow Port (fake output "ports"). */
    OFPP_IN_PORT    = 0xfffffff8,  /* Send the packet out the input port.  This
    reserved port must be explicitly used
    in order to send back out of the input
    port. */
    OFPP_TABLE      = 0xfffffff9,  /* Submit the packet to the first flow table
    NB: This destination port can only be
    used in packet-out messages. */
    OFPP_NORMAL     = 0xfffffffa,  /* Process with normal L2/L3 switching. */
    OFPP_FLOOD      = 0xfffffffb,  /* All physical ports in VLAN, except input
    port and those blocked or link down. */
    OFPP_ALL        = 0xfffffffc,  /* All physical ports except input port. */
    OFPP_CONTROLLER = 0xfffffffd,  /* Send to controller. */
    OFPP_LOCAL      = 0xfffffffe,  /* Local openflow "port". */
    OFPP_ANY        = 0xffffffff   /* Wildcard port used only for flow mod
    (delete) and flow stats requests. Selects
    all flows regardless of output port
    (including flows with no output port). */
};

/* Features of ports available in a datapath. */
enum ofp_port_features {
    OFPPF_10MB_HD    = 1 << 0,  /* 10 Mb half-duplex rate support. */
    OFPPF_10MB_FD    = 1 << 1,  /* 10 Mb full-duplex rate support. */
    OFPPF_100MB_HD   = 1 << 2,  /* 100 Mb half-duplex rate support. */
    OFPPF_100MB_FD   = 1 << 3,  /* 100 Mb full-duplex rate support. */
    OFPPF_1GB_HD     = 1 << 4,  /* 1 Gb half-duplex rate support. */
    OFPPF_1GB_FD     = 1 << 5,  /* 1 Gb full-duplex rate support. */
    OFPPF_10GB_FD    = 1 << 6,  /* 10 Gb full-duplex rate support. */
    OFPPF_40GB_FD    = 1 << 7,  /* 40 Gb full-duplex rate support. */
    OFPPF_100GB_FD   = 1 << 8,  /* 100 Gb full-duplex rate support. */
    OFPPF_1TB_FD     = 1 << 9,  /* 1 Tb full-duplex rate support. */
    OFPPF_OTHER      = 1 << 10, /* Other rate, not in the list. */
    OFPPF_COPPER     = 1 << 11, /* Copper medium. */
    OFPPF_FIBER      = 1 << 12, /* Fiber medium. */
    OFPPF_AUTONEG    = 1 << 13, /* Auto-negotiation. */
    OFPPF_PAUSE      = 1 << 14, /* Pause. */
    OFPPF_PAUSE_ASYM = 1 << 15  /* Asymmetric pause. */
};

#endif /* OPENFLOW_H_ */
