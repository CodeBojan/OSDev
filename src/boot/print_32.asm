DISPLAY_MEMORY equ 0xB8000 	; the start address of the VGA buffer
WHITE equ 0x0F 				; white on black console setup

%macro print_32 1
	pusha
	mov edx, DISPLAY_MEMORY
	mov ebx, %1
	
	%%_print_32_loop:
		mov al, [ebx]	; character
		mov ah, WHITE	; display options
		
		cmp al, 0
		je %%_print_32_done
		
		mov [edx], ax
		
		add ebx, 1
		add edx, 2	; this is one character cell in memory, one byte for char and one for display options
		
		jmp %%_print_32_loop
		
%%_print_32_done:
	popa

%endmacro