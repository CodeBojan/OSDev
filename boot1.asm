org			0x7C00
bits		16

jmp _start

%include "print_hex.asm"
%include "print.asm"
%include "load.asm" ; since load.asm uses print.asm, it needs to go below print.asm.

_start:
		mov [BOOT_DRIVE], dl
		
		; This was used to reset the floppy controller, but it doesn't look like it's needed?
		;reset: 
		;	mov ah, 0
		;	mov dl, 0
		;	int 0x13
		;	jc reset
		
		mov bp, 0x8000
		mov sp, bp
		
		mov bx, 0x9000
		mov dh, 5
		mov dl, [BOOT_DRIVE]
		
		call load_disk
		
		print_hex_address 0x9000, 4
		print_hex_address 0x9000 + 512, 4
		
		jmp $
			
			
hex: 		dw 0x1C00
error_message:      db `\r\nERROR has occured.\n\r`, 0
error_message1:      db `\r\nrandom shit.\n\r`, 0
error_message2:      db `\r\nmore random shit.\n\r`, 0
BOOT_DRIVE: db 0
times 510 - ($ - $$) db 0
dw			0xAA55

times 256 dw 0xDADA
times 256 dw 0xFECA