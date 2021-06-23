
#ifndef KANDOOSTRUCTS_H_
#define KANDOOSTRUCTS_H_


struct KandooEntry{
    std::string srcController;
    std::string trgController;
    std::string trgApp;
    std::string srcApp;
    std::string trgSwitch;
    std::string srcSwitch;
    omnetpp::cObject * payload = nullptr;
    int type = -1; //0 inform, 1 request, 2 reply
};



#endif /* OF_CONTROLLER_H_ */
