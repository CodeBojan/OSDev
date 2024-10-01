bits 16

%macro load_kernel 0
	print kernel_loading_message
	mov bx, KERNEL_OFFSET
	mov dh, 15
	mov dl, [BOOT_DRIVE]
	call load_disk
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
	print load_execution_error_message
	ret
	
load_error:
	print load_completion_error_message
	ret