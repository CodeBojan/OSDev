#include "drivers/screen.h"

void start(){
    char* video_memory = (char*)0xB8000;
    *video_memory = 'X';

    clear_screen();
}