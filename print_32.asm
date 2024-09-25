bits 32

DISPLAY_MEMORY equ 0xB8000 ; the start address of the VGA buffer
WHITE equ 0x0F ; white on black console setup

print_32:
	pusha
	mov edx, DISPLAY_MEMORY
	
	print_32_loop:
		mov al, [ebx]	; character
		mov ah, WHITE	; display options
		
		cmp al, 0
		je print_32_done
		
		add ebx, 1
		add edx, 2	; this is one character cell in memory, one byte for char and one for display options
		
		jmp print_32_loop
		
print_32_done:
	popa
	ret