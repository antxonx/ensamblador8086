    name "p5" ;nombre de programa
    include 'emu8086.inc' ;Incluimos libreria emu8086
    org  0x100 
    DEFINE_GET_STRING ;definimos la funcion get_string de emu8086
    jmp start ;brincamos las variables
    cadena db 5 dup(0) ;declaración de cadena final
    cadenaSize equ $-cadena
    numero dw 0x0000
    cadenaInicio dw 0x0000
    tmp db ?
start:
    mov dx, cadenaSize
    lea di, cadena
    mov cadenaInicio, di
    dec [cadenaInicio]
    call get_string
    mov bx, cadenaSize
    lea si, cadena + [bx]
    call convert
exit:
    int 0x20

convert:
    push si
    push di
    push ax
    push cx
    xor cx, cx
    lea di, numero
convert_start:
    dec si
    cmp si, cadenaInicio
    jz convert_finish
    cmp [si], 0x00
    jz convert_start
    mov al, [si]
convert_tohex:
    cmp cl, 0x01
    jz convert_second
    call charToHex
    mov cl, 0x01
    mov ch, al
    jmp convert_start
convert_second:
    call charToHex
    mov cl, 0x00
    rol al, 0x04
    add ch, al
    mov [di], ch
    inc di
    jmp convert_start
convert_finish:
    pop cx
    pop ax
    pop di
    pop si
    ret

charToHex:
    sub al, 0x30
    cmp al, 0x09
    jle charToHex_finish
    sub al, 0x07
    cmp al, 0x0f
    jle charToHex_finish
    sub al, 0x20
charToHex_finish:
    ret