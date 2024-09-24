bits 16

%macro load_kernel 0
	%%_read:
		mov ah, 0x02
		mov al, 1
		mov ch, 1
		mov cl, 2
		mov dh, 0
		mov dl, 0
		
		mov bx, 0xA0000
		mov es, bx
		mov bx, 0x1234 ; the data will be read at 0xA1234 - 0xA000:0x1234 = 0xA000 * 16 + 0x1234 = 0xA00000 + 0x1234 = 0xA1234
		
		int 0x13
		jc %%_read
%endmacro

load_disk:

	push dx
	mov ah, 0x02
	mov al, dh
	mov ch, 0x00
	mov dh, 0x00
	mov dl, [BOOT_DRIVE]
	mov cl, 0x02
	
	int 0x13
	jc load_execution_error
	
	pop dx
	cmp al, dh
	jne load_error
	ret
	
load_execution_error:   ; do NOT use these labels outside of load_disk routine!
	print error_message
	ret
	
load_error:
	print error_message1
	ret
	
