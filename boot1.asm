org			0x7C00
bits		16

jmp _start

%include "print_hex.asm"

_start:
			xor ax, ax
			mov ds, ax
			mov es, ax
			INT 0x12
			mov bx, ax
			xor ax, ax
			print_hex_address hex, 4
			print_hex_value bx, 4
			
			jmp $
			; 175 - >>
hex: 		dw 0xFECA
times 510 - ($ - $$) db 0
dw			0xAA55