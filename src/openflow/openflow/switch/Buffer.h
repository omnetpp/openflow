

#ifndef BUFFER_H_
#define BUFFER_H_

#include <deque>
#include <map>
#include "inet/common/packet/Packet.h"


using namespace std;
using namespace inet;

class Buffer {

public:
    Buffer();
    Buffer(int cap);
    ~Buffer();
    bool isfull();
    uint32_t storeMessage(Packet *msg);
    bool deleteMessage(Packet *msg);
    Packet *returnMessage(uint32_t buffer_id);
    uint32_t getCapacity();
    int size();


protected:
    std::map<uint32_t, Packet *> pending_msgs;
    uint32_t capacity;
    uint32_t next_buffer_id;
};




#endif /* BUFFER_H_ */
