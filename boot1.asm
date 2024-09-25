org			0x7C00
bits		16

jmp _start

%include "print_hex.asm"
%include "print.asm"
;%include "load.asm" 		; since load.asm uses print.asm, it needs to go below print.asm.
							; macro vs routine: macro can be written in a file that is included, but if not used, it is not present in the bin file.
							; Routines are always present, but are present only once.
hex: 		dw 0x1C00
;load_execution_error_message:      	db `\r\nLoad execution error has ocurred.\n\r`, 0
;load_completion_error_message:      db `\r\nNot enough sectors loaded.\n\r`, 0
real_mode_message:			db `\r\nStarted 16-bit Real Mode\n\r`, 0

;BOOT_DRIVE: db 0

_start:
		print real_mode_message
		;mov [BOOT_DRIVE], dl
		
		; This was used to reset the floppy controller, but it doesn't look like it's needed?
		;reset: 
		;	mov ah, 0
		;	mov dl, 0
		;	int 0x13
		;	jc reset
		
		;mov bp, 0x8000
		;mov sp, bp
		
		;mov bx, 0x9000
		;mov dh, 5
		;mov dl, [BOOT_DRIVE]
		
		;call load_disk			; loading some bytes after the end of the bootloader for demonstration purposes
		;print_hex_address 0x9000, 4
		;print_hex_address 0x9000 + 512, 4
		
		mov bp, 0x9000		; ?
		mov sp, bp
		
		call switch_to_pm
			
	switch_to_pm:
		
		cli 					; clear the 16 bit interrupts, because if the CPU works in 32-bit mode, 7
								; and uses 16 bit interrupts, bad things can happen
		lgdt [gdt_descriptor]	; load the GDT
		
		mov eax, cr0 			; set the special CPU control register for the protected mode switch_to_pm
		or eax, 0x1
		mov cr0, eax
		jmp CODE_SEGMENT:init_pm
bits 32
%include "print_32.asm" ; has to be below the 16 bit code, because of 'bits 16' directive
		
	init_pm:
		mov ax, DATA_SEGMENT	; old segments are meaningless, so now the segment registers need to point at the new data segment in GDT
		mov ds, ax
		mov fs, ax
		mov ss, ax
		mov gs, ax
		mov es, ax
	
		mov ebp, 0x90000
		mov esp, ebp
		 
		print_32 protected_mode_message
		jmp $


protected_mode_message:		db `\r\nLanded in 32-bit Protected mode\n\r`, 0
; GDT in basic flat model -  has one code and one data segment
; GDT works as follows: if I want to use fs, ds, cs and other segment registers
; with this 'protected' mode, I have to initialize them with segment selectors,
; a data structure of 2 bytes that tells the CPU which descriptor (a GDT entry)
; it wants to use. The access to the GDT is implemented by default, no developer modification is needed.
; When I use a register that is configured, it immediately uses it through the GDT.
; The current configuration of the GDT bypasses it, two segments that are basically referencing the same segment (whole RAM)
; because the GDT is necessary for Protected Mode
gdt_start :
	gdt_null : 		; the mandatory null descriptor
		dd 0x0 	; ’ dd ’ means define double word ( i.e. 4 bytes )
		dd 0x0
	gdt_code : 		; the code segment descriptor
		; base =0 x0 , limit =0 xfffff ,
		; 1 st flags : ( present )1 ( privilege )00 ( descriptor type )1 -> 1001 b
		; type flags : ( code )1 ( conforming )0 ( readable )1 ( accessed )0 -> 1010 b
		; 2 nd flags : ( granularity )1 (32 - bit default )1 (64 - bit seg )0 ( AVL )0 -> 1100 b
		dw 0xffff 		; Limit ( bits 0 -15)
		dw 0x0 		; Base ( bits 0 -15)
		db 0x0 		; Base ( bits 16 -23)
		db 10011010b 	; 1 st flags , type flags
		db 11001111b 	; 2 nd flags , Limit ( bits 16 -19)
		db 0x0 		; Base ( bits 24 -31)
	gdt_data : 		; the data segment descriptor
		; Same as code segment except for the type flags :
		; type flags : ( code )0 ( expand down )0 ( writable )1 ( accessed )0 -> 0010 b
		dw 0xffff 		; Limit ( bits 0 -15)
		dw 0x0 		; Base ( bits 0 -15)
		db 0x0 		; Base ( bits 16 -23)
		db 10010010b 	; 1 st flags , type flags
		db 11001111b 	; 2 nd flags , Limit ( bits 16 -19)
		db 0x0 		; Base ( bits 24 -31)
	gdt_end : 	
				; The reason for putting a label at the end of the
				; GDT is so we can have the assembler calculate
				; the size of the GDT for the GDT decriptor ( below )
				; GDT descriptior
	gdt_descriptor :
		dw gdt_end - gdt_start - 1 ; Size of our GDT , always lesser by one of its the true size
dd gdt_start 	
		; Start address of our GDT
		; Define some handy constants for the GDT segment descriptor offsets , which
		; are what segment registers must contain when in protected mode. For example ,
		; when we set DS = 0 x10 in PM , the CPU knows that we mean it to use the
		; segment described at offset 0 x10 ( i.e. 16 bytes ) in our GDT , which in our
		; case is the DATA segment (0 x0 -> NULL ; 0 x08 -> CODE ; 0 x10 -> DATA )
CODE_SEGMENT equ gdt_code - gdt_start
DATA_SEGMENT equ gdt_data - gdt_start
times 510 - ($ - $$) db 0
dw			0xAA55