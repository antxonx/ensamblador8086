    name "p5" ;nombre de programa
    include 'emu8086.inc' ;Incluimos libreria emu8086
    org  0x100 
    DEFINE_GET_STRING ;definimos la funcion get_string de emu8086
    jmp start ;brincamos las variables
    cadena db 5 dup(0) ;declaración de cadena final
    cadenaSize equ $-cadena ;tamaño de la cadena de salida
    numero dw 0x0000 ;número de salida
    cadenaInicio dw 0x0000 ;dirección de inicio de la cadena
start:
    mov dx, cadenaSize ;pasamos el tamaño de la cadena de entrada
    lea di, cadena ;cargamos la dreccion de memeoria de la cadena de entrada
    mov cadenaInicio, di ;guardamos esa direccion
    dec [cadenaInicio] ;le restamos un byte
    call get_string ;llamamos a la funcion para leer la cadena
    mov bx, cadenaSize ;bx = cadenaSize
    lea si, cadena + [bx] ;cargamos a si la direccion del ultimo caracter de la cadena
    call convert ;llamamos a convert
exit:
    int 0x20 ;finalizamos el programa

convert:
    push si ;respaldamos si
    push di ;respaldamos di
    push ax ;respaldamos ax
    push cx ;respaldamos cx
    xor cx, cx ;limpiamos cx
    lea di, numero ;cargamos la direccion del numero final en di
convert_start:
    dec si ;si--
    cmp si, cadenaInicio ;comparamos si con la direccion de la cadena
    jz convert_finish ;si si == cadenaInicio brincamos a convert_finish
    cmp [si], 0x00 ;comparamos el valor de [si] con 0x00
    jz convert_start ;si [si] == 0x00 brincamos a convert_start para seguir leyendo
    mov al, [si] ;guardamos el valor de [si] en al
convert_tohex:
    cmp cl, 0x01 ;comparamos cl con 0x01
    jz convert_second ;si cl == 0x01 brincamos a convert_second
    call charToHex ;al = (int)al
    mov cl, 0x01 ;cl = 0x01
    mov ch, al ;ch = al
    jmp convert_start ;brincamos a convert_start para leer otro caracter
convert_second:
    call charToHex ;llamamos a charToHex (al debe ser el caracter a convertir)
    mov cl, 0x00 ;cl = 0x00
    rol al, 0x04 ;rotamos 4 bits a la izquierda
    add ch, al ;ch = ch + al
convert_write:
    mov [di], ch ;[di] = ch
    inc di ;di++
    cmp cl, 0x01 ;comparamos cl con 0x01
    jz convert_exit ;si no hay mas numeros brincamos a convert_exit
    jmp convert_start ;brincamos a convert_start
convert_finish:
    cmp cl, 0x01 ;comparamos cl con 0x01
    jz convert_write ;si cl == 0x01 brincamos a convert_write
convert_exit:
    pop cx ;recuperamos cx
    pop ax ;recuperamos ax
    pop di ;recuperamos di
    pop si ;recuperamos si
    ret ;volvemos al codigo principal

charToHex:
    sub al, 0x30 ;al = al - 0x30
    cmp al, 0x09 ;comparamos al con 0x09
    jle charToHex_finish ;si es menor o igual ya terminamos
    sub al, 0x07 ;al = al - 0x07
    cmp al, 0x0f ;comparamos al con 0x0f
    jle charToHex_finish ;si es menor o igual ya terminamos
    sub al, 0x20 ;al = al - 0x20
charToHex_finish:
    ret ;vovlemos al codigo principal