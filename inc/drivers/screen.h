#define DISPLAY_MEMORY_ADDRESS 0xB8000          /* Same as DISPLAY_MEMORY in print_32.asm */
#define MAX_ROWS 25
#define MAX_COLUMNS 80
#define TAB         8                           /* The amount of whitespaces that make up a tab */

#define WHITE_ON_BLACK 0x0F

# define REG_SCREEN_CTRL 0x3D4                  /* Screen registers */
# define REG_SCREEN_DATA 0x3D5

void clear_screen();