.model small
.stack 100h
.data
.code
main:
    mov  ax, @data
    mov  ds, ax
    lea dx, "Hello world!$"
    int 21h
return:
    mov  ah, 4ch
    int 21h
end main
