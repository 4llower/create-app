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
main:

return:
    mov  ah, 4ch            	; exit interrupt
    int 21h
end main
