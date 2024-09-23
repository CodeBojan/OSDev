bits 16

%macro load_second_bootloader 0
	%%_read:
		mov ah, 0x02
		mov al, 1
		mov ch, 1
		mov cl, 2
		mov dh, 0
		mov dl, 0
		int 0x13
		jc %%_read
%endmacro