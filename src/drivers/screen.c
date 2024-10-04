#include "drivers/screen.h"

void print_character(char character, int row, int col, char attribute){
    unsigned char* video_memory = (unsigned char*)DISPLAY_MEMORY_ADDRESS;

    if(attribute == 0)
        attribute = WHITE_ON_BLACK;

    int offset;
    if(col >= 0 && row >= 0){
        offset = get_screen_offset(row, col);
    }
    else
        offset = get_cursor();
    
    if(character == '\n'){
        offset = get_screen_offset(row + 1, 0);
    }
    else if(character == '\t'){
        offset += TAB;
    }
    else{
        video_memory[offset] = character;
        video_memory[offset + 1] = attribute;
    }

    offset += 2;
    offset = scroll(offset);
    set_cursor(offset);
}

/************************************************
 * @brief 
 *  Calculates the screen offset (character cell, i.e. two bytes)
 *  for the row and columns specified.
 *  IMPORTANT: The row and column indexes are 0-indexed.
 * 
 * @param row       The specified row
 * @param col       The specified column
 * @return          The calculated screen offset
************************************************/
int get_screen_offset(int row, int col){
    return (row * 2 * MAX_COLUMNS) + (col * 2);
}

int get_cursor(){

    write_port_byte(REG_SCREEN_CTRL, 14);
    int offset = read_port_byte (REG_SCREEN_DATA) << 8;
    write_port_byte(REG_SCREEN_CTRL, 15);
    offset += read_port_byte(REG_SCREEN_DATA);
    return offset * 2;
}

void set_cursor(int offset){
    offset /= 2;

    write_port_byte ( REG_SCREEN_CTRL , 14);
    offset = read_port_byte ( REG_SCREEN_DATA ) << 8;
    write_port_byte ( REG_SCREEN_CTRL , 15);
    offset += write_port_byte (REG_SCREEN_DATA, '|');

    return offset * 2;
}

int scroll(int offset){
    return 0;
}

void clear_screen(){
    int row = 0;
    int col = 0;

    for(row = 0; row < MAX_ROWS; row++)
        for(col = 0; col < MAX_COLUMNS; col ++)
            print_character(' ', col, row, WHITE_ON_BLACK);

    
    set_cursor(get_screen_offset(0, 0));
}