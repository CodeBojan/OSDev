org			0x7C00
bits		16

jmp _start

%include "print_hex.asm"
%include "load.asm"
%include "print.asm"

_start:
		reset:
			mov ah, 0
			mov dl, 0
			int 0x13
			jc reset
			
			mov ax, 0x1000
			mov es, ax
			xor bx, bx
			
			load_second_bootloader
			jmp 0x1000:0x0
			
			
hex: 		dw 0x1C00
error_message:      db `\r\nERROR has occured.\n\r`, 0
error_message1:      db `\r\nrandom shit.\n\r`, 0
error_message2:      db `\r\nmore random shit.\n\r`, 0
times 510 - ($ - $$) db 0
dw			0xAA55