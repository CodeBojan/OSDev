bits 16

%macro print 1
	push ax
	push bx
	mov bx, %1
	mov ah, 0x0E
	
	%%_print_bios_loop:
		cmp byte[bx], 0
		je %%_print_bios_end
		
		mov al, byte[bx]
		INT 0x10
		
		inc bx
		jmp %%_print_bios_loop
	
%%_print_bios_end:
	pop bx
	pop ax
	
%endmacro