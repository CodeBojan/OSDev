/************************************************
 * @brief 
 *  This file contains all the operations
 *  pertaining to the port I/O.
 * 
************************************************/


/************************************************
 * @brief 
 *  Reads a byte from the specified port. 
 *  "=a" ( result ) means : put AL register in the variable RESULT when finished.
 *  "d" ( port ) means : load EDX with the specified port.
 * 
 * @param port      The specified port 
 * @return          The read byte
************************************************/
unsigned char read_port_byte(unsigned short port){
    unsigned char result ;
    __asm__ ("in %%dx , %% al" : "=a" ( result ) : "d" ( port ));
    return result;
}

/************************************************
 * @brief 
 *  Writes a byte to the specified port.
 *  "a" ( data ) means : load EAX with data.
 *  "d" ( port ) means : load EDX with port
 * 
 * @param port      The specified port
 * @param byte      The byte to be written
************************************************/
void write_port_byte(unsigned short port, unsigned char byte){
    __asm__ (" out %%al , %% dx" : :"a" ( byte ), "d" ( port ));
}

/************************************************
 * @brief 
 *  Reads a word from the specified port.
 * 
 * @param port      The specified port
 * @return          The read word
************************************************/
unsigned read_port_word(unsigned short port){
    unsigned short result ;
    __asm__ ("in %%dx , %% ax" : "=a" ( result ) : "d" ( port ));
    return result;
}

/************************************************
 * @brief 
 *  Writes a word to the specified port
 * 
 * @param port      The specified port
 * @param word      The word to be written
************************************************/
void write_port_word(unsigned short port, unsigned short word){
    __asm__ (" out %%ax , %% dx" : :"a" ( word ), "d" ( port ));
}