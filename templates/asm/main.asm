.model small
.stack 100h
.data
	last_symbol   db ?
	n             dw ?
    current_value dw 0
	i             dw 0
	j             dw 0
    k             dw 0
	arraySize     dw 0
	matrix        db 1000 dup(0)
    from_i_to_k db 0
    from_k_to_j db 0
    from_i_to_j db 0
.code

calc_array_index proc C near
arg  curI: word, curJ: word
    mov  ax, curI
    mul  n
    add  ax, curJ
    ret
endp calc_array_index

write_carryover proc C near
    uses ax, dx
    mov  dl, 0Ah            	;'\n' start
    mov  ah, 02h
    int  21h

    mov  dl, 0Dh
    mov  ah, 02h
    int  21h                	; '\n' end
    ret
write_carryover endp

remove_symbol proc C near
    mov  ah, 02h
    mov  dl, 8
    int  21h
    mov  dl, 32
    int  21h
    mov  dl, 8
    int  21h
    ret
remove_symbol endp

read_number proc C near
    uses bx, cx, dx
    mov  bx, 0
    mov  cx, 0

	read_cycle:         
        mov  ax, 0

        mov  ah, 08h            	; read char symbol
        int  21h

        cmp  al, 32
        je   space_clicked

        cmp  al, 8              	; backspace key clicked check
        je   backspace_clicked

        cmp  al, 27             	; esc key clicked check
        je   esc_clicked

        cmp  al, 13             	; enter key clicked check
        je   return_read_number

    ; compare on correct symbol entering
        cmp  al, '0'
        jb   read_cycle
        cmp  al, '9'
        ja   read_cycle

        cmp  al, '0'            	; case then we have a prefix of '0'
        ja   logic

        cmp  cx, 0
        je   logic

        cmp  bx, 0
        jnz  logic

        jmp  read_cycle

	logic:              
        mov  last_symbol, al    	; save last symbol because working with ax(al changes)

        mov  ax, bx             	; overflow check

        mov  dx, 10
        mul  dx
        jc   read_cycle         	; 1st check

        mov  dx, 0
        mov  dl, last_symbol
        sub  dl, '0'

        add  ax, dx

        jc   read_cycle         	; 2nd check

        mov  bx, ax             	; if we have no overflow add digit to number

        inc  cx                 	; add 1 to length of number
        jmp  symbol_write       	; writing symbol

	backspace_clicked:  
        cmp  cx, 0              	; check on empty string
        je   read_cycle

        mov  dx, 0
        mov  ax, bx
        mov  bx, 10
        div  bx
        mov  bx, ax

        call remove_symbol      	; remove last symbol

        dec  cx                 	; decrease length of number

        jmp  read_cycle         	; start new iteration

	esc_clicked:        
        cmp  cx, 0              	; check on empty string
        je   read_cycle

	delete_cycle:       
        call remove_symbol
        loop delete_cycle
        mov  bx, 0
        jmp  read_cycle         	; start new iteration

	symbol_write:       
        mov  dl, last_symbol
        mov  ah, 02h
        int  21h

        jmp  read_cycle
    space_clicked:
        mov dl, ' '
        mov ah, 02h
        int 21h
        jmp go

	return_read_number: 
        call write_carryover
        go:
        mov  ax, bx             	; move result to ax
        ret
read_number endp

print_number proc C near
    arg  number: word
    uses ax, bx, cx, dx
    mov  ax, number
    mov  cx, 0

	fill_stack:         
        mov  dx, 0              	; divide on 10
        mov  bx, 10
        div  bx

        push dx                 	; save digit in stack
        inc  cx

        cmp  ax, 0              	; check if ax equal zero
        je   write_cycle
        jmp  fill_stack

	write_cycle:        
        cmp  cx, 0
        je   return_print_number

        pop  dx
        add  dx, '0'
        mov  ah, 02h
        int  21h

        dec  cx
        jmp  write_cycle

	return_print_number:
	    ret
print_number endp

calc_from_i_to_k proc C near
    arg curI: word, curJ: word;
    uses ax;
    mov ax, 0
    call calc_array_index C, curI, curJ
    mov si, ax
    mov ax, 0
    mov al, matrix[si]
    mov from_i_to_k, al
    ret
calc_from_i_to_k endp

calc_from_k_to_j proc C near
    arg curI: word, curJ: word;
    uses ax;
    mov ax, 0
    call calc_array_index C, curI, curJ
    mov si, ax
    mov ax, 0
    mov al, matrix[si]
    mov from_k_to_j, al
    ret
calc_from_k_to_j endp

calc_from_i_to_j proc C near
    arg curI: word, curJ: word;
    uses ax;
    mov ax, 0
    call calc_array_index C, curI, curJ
    mov si, ax
    mov ax, 0
    mov al, matrix[si]
    mov from_i_to_j, al
    ret
calc_from_i_to_j endp

main:               
    mov  ax, @data          	; initialize data segment
    mov  ds, ax

    call read_number
    mov  n, ax

    mov  ax, n
    mul  n
    mov  arraySize, ax
    
    matrix_i:           
        mov ax, 0 ; clear j
        mov j, ax
        matrix_j:
            call read_number
            mov current_value, ax
            call calc_array_index C, i, j
            mov si, ax
            mov ax, current_value
            mov matrix[si], al
            inc j
            mov ax, j
            cmp ax, n
        jne matrix_j
        inc i
        mov ax, i
        cmp ax, n
    jne matrix_i

    middle_vertex_k:
        mov ax, 0
        mov i, ax
        first_vertex_i:
            mov ax, 0
            mov j, ax
            second_vertex_j:
                ; i and j vertex compare

                call calc_from_i_to_k C, i, k
                call calc_from_k_to_j C, k, j
                call calc_from_i_to_j C, i, j

jmp skip
    transfer:
    jmp middle_vertex_k
skip:
                mov ax, 0
                mov al, from_i_to_k
                add al, from_k_to_j
                cmp al, from_i_to_j
                ja continue

                mov bx, ax
                call calc_array_index C, i, j
                mov si, ax
                mov matrix[si], bl

                continue:
                inc j
                mov ax, j
                cmp ax, n
            jne second_vertex_j
            inc i
            mov ax, i
            cmp ax, n
        jne first_vertex_i
        inc k
        mov ax, k
        cmp ax, n
    jne transfer

    mov ax, 0
    mov i, ax

    answer_i:           
        mov ax, 0 ; clear j
        mov j, ax
        answer_j:
            call calc_array_index C, i, j
            mov si, ax
            mov ax, 0
            mov al, matrix[si]
            call print_number C, ax
            mov dl, ' '
            mov ah, 02h
            int 21h

            inc j
            mov ax, j
            cmp ax, n
        jne answer_j
        call write_carryover

        inc i
        mov ax, i
        cmp ax, n
    jne answer_i
    
return:             
    mov  ah, 4ch            	; exit interrupt
    int 21h
end main