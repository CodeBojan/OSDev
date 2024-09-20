bits 16
%macro print_hex_value 2

	mov cx, %2
	cmp cx, 0
	je print_hex_value_termination
	
	push dx
	push bx
	push ax
	push cx
	
	mov bx, %1
	
	mov ah, 0x0E
	mov al, '0'
	INT 0x10
	mov al, 'x'
	INT 0x10
	print_hex_value_loop:
		cmp cx, 0
		je print_hex_value_end
		
		push bx
		mov dx, bx
		shr dx, 12
		
		cmp dl, 10
		jge print_hex_value_alpha
		
		mov al, '0'
		add al, dl
		jmp print_hex_value_loop_end
		
	print_hex_value_alpha:
		sub dl, 10
		mov al, 'A'
		add al, dl
		
		
	print_hex_value_loop_end:
		INT 0x10
		pop bx
		mov dx, bx
		shl dx, 4
		mov bx, dx
		dec cx
		jmp print_hex_value_loop
	
print_hex_value_end:
	pop cx
	pop ax
	pop bx
	pop dx
print_hex_value_termination:

%endmacro	


%macro print_hex_address 2

	mov cx, %2
	cmp cx, 0
	je print_hex_address_termination
	
	push dx
	push ax
	push bx
	push cx
	
	mov bx, %1
	
	mov ah, 0x0E
	
	mov al, '0'
	INT 0x10
	mov al, 'x'
	INT 0x10
	print_hex_address_loop:
		
		cmp cx, 0
		je print_hex_address_end
		
		push bx
		
		mov dx, [bx]
		shr dx, 12
		
		cmp dl, 10
		jge print_hex_address_alpha
		
		mov al, '0'
		add al, dl
		jmp print_hex_address_loop_end
		
	print_hex_address_alpha:
		sub dl, 10
		mov al, 'A'
		add al, dl
		
		
	print_hex_address_loop_end:
		INT 0x10
		pop bx
		mov dx, [bx]
		shl dx, 4
		mov [bx], dx
		dec cx
		jmp print_hex_address_loop
	
print_hex_address_end:
	pop cx
	pop bx
	pop ax
	pop dx
print_hex_address_termination:

%endmacro