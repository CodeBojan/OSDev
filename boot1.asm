org			0x7C00
bits		16

jmp _start

%include "print_hex.asm"

_start:
			print_hex hex, 0
			jmp $
hex: 		dw 0xFECA
times 510 - ($ - $$) db 0
dw			0xAA55