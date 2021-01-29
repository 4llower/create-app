.model small
.stack 100h
.data
    message db "Hello world!$"
.code
main:
    mov  ax, @data
    mov  ds, ax
    mov ah, 09h
    lea dx, message
    int 21h
return:
    mov  ah, 4ch
    int 21h
end main
