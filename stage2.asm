org 0x0

bits 16

jmp _start

%include "print.asm"

_start:
		cli 
		push cs
		pop ds
		
		print std_out
		cli
		hlt
		

std_out: db `\r\nSomething is amiss\n\r`, 0
