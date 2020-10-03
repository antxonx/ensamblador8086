    org 0x100
    ; Inicio del programa
    mov ax, 0x3d00                        ; abrir archivo en modo lectura
    mov dx, offset filename               ; cargamos el nombre del archivo
    int 0x21                              ; ejecutamos la interrupción
    jc error                              ; si CF = 1 ocurrió un error
    mov handle, ax                        ; guardamos el handle
    mov ax, 0x4202                        ; vamos al final del archivo
    mov bx, handle                        ; especificamos el handle del archivo
    mov dx, 0x0                           ; sin offset
    mov cx, 0x0                           ; sin offset
    int 0x21                              ; ejecutamos la interrupción
    jc error                              ; si CF = 1 ocurrió un error
    mov filesize, ax                      ; la posición del puntero la guardamos como tamaño
    mov ax, 0x4200                        ; vamos al inicio del archivo
    mov bx, handle                        ; especificamos el handle
    mov dx, 0x0                           ; sin offset
    mov cx, 0x0                           ; sin offset
    int 0x21                              ; ejecutamos la interrupción
    jc error                              ; si CF = 1 ocurrió un error
    mov ah, 0x3f                          ; leer archivo
    mov bx, handle                        ; especificamos el handle
    mov cx, filesize                      ; especificamos el tamaño del archivo
    mov dx, offset cont                   ; Especificamos la dirección de memoria donde guardará el contenido
    int 0x21                              ; ejecutamos la interrupción
    mov ah, 0x3e                          ; cerrar el archivo
    mov bx, handle                        ; especificamos el handler
    int 0x21                              ; ejecutamos la interrupción
    lea si, cont                          ; iniciamos el puntero para recorrer arreglo
    mov cx, filesize                      ; iniciamos cx al tamano del archivo
    xor bx, bx                            ; limpiamos bx para usarlo para evaluar las fechas
    mov dx, initial                       ; iniciamos dx en 1000
    xor ax, ax                            ; limpamos ax
readBytes:
    mov al, [si]                          ; leemos letra por letra
    push dx                               ; respaldamos el valor de dx
    sub al, 0x30                          ; restamos 0x30 al caracter para conseguir el numero
    cmp al, 0x0a                          ; comparamos al con 0x0a
    jnbe condition                        ; si es mayor entonces no es un numero
    mul dx                                ; multiplicamos ax por dx (ax * 1000 | ax * 100 | ax * 10 | ax * 1)
    add bx, ax                            ; sumamos el resultado de la multiplicacion a bx
    pop ax                                ; sacamos el valor que tenia dx
    push cx                               ; respaldamos cx
    mov cx, divid                         ; pasamos 0x0a a cx
    xor dx, dx                            ; limpiamos dx para evitar errores en la division
    div cx                                ; dividimos ax / 10
    mov dx, ax                            ; ponemos el resultado en dx
    pop cx                                ; recuperamos cx
    cmp dx, 0x00                          ; si dx es 0 evaluamos lo que obtuvimos en bx
    je eval
condition:
    inc si                                ; aumentamos el punto del texto
    loop readBytes                        ; si cx > 0 volvemos a readBytes, c--
    jmp exit

eval:
    push cx
    mov [A], bx
    mov ax, [A]
    mov bx, 19
    xor dx, dx
    div bx
    mov [aa], dx

    mov ax, [A]
    mov bx, 4
    xor dx, dx
    div bx
    mov [b], dx

    mov ax, [A]
    mov bx, 7
    xor dx, dx
    div bx
    mov [c], dx

    mov ax, [A]
    mov bx, 100
    xor dx, dx
    div bx
    mov [k], ax

    mov ax, [k]
    mov bx, 8
    mul bx
    add ax, 13
    mov bx, 25
    xor dx, dx
    div bx
    mov [p], ax

    mov ax, [k]
    mov bx, 4
    xor dx, dx
    div bx
    mov [q], ax

    mov ax, 15
    sub ax, [p]
    add ax, [k]
    sub ax, q
    mov bx, 30
    xor dx, dx
    div bx
    mov [M], dx

    mov ax, 4
    add ax, [k]
    sub ax, [q]
    mov bx, 7
    xor dx, dx
    div bx
    mov [N], dx

    mov ax, 19
    mul [aa]
    add ax, [M]
    mov bx, 30
    xor dx, dx
    div bx
    mov [d], dx

    mov ax, 2
    mul [b]
    mov cx, ax
    mov ax, 4
    mul [c]
    add cx, ax
    mov ax, 6
    mul [d]
    add ax, cx
    add ax, [N]
    mov bx, 7
    xor dx, dx
    div bx
    mov [e], dx
    pop cx

    mov ax, [e]
    add ax, [d]
    cmp ax, 10
    jnb abril
    jmp marzo
marzo:
    push cx
    push si
    add ax, 22
    mov [day], ax
    mov cx, abrilDate - offset marzoDate
    mov si, offset marzoDate
    mov di, offset month
    rep movsb
    pop si
    pop cx
    jmp output
abril:
    push cx
    push si
    sub ax, 9
    mov [day], ax
    mov cx, month - offset abrilDate
    mov si, offset abrilDate
    mov di, offset month
    rep movsb
    pop si
    pop cx
    jmp output
output:
    push cx
    push si                               ; respaldamos si
    lea si, year + 4                    ; posicionamos el puntero al final
    mov ax, [A]                            ; ponemos el valor a convertir en ax
    mov bx, divid                         ; cargarmos 0x0a a bx para divir
convert:
    xor dx, dx                            ; limpiamos dx para la division
    div bx                                ; Dividimos entre 10
    add dl, 0x30                          ; le sumamos 0x30 para imprimir
    cmp dl, '9'                           ; verificamos que no sea hexadecimal
    jbe store                             ; si no es lo guardamos
    add dl, 'A'-'0'-10                    ; si es lo ajustamos
store:
    dec si                                ; una posicion atras
    mov [si], dl                          ; guardamos el digito
    and ax, ax                            ; verificamos si no hay mas que hacer
    jnz convert                           ; seguimos convierto a ascii

    pop si
    pop cx
    jmp output2

output2:
    push cx
    push si                               ; respaldamos si
    lea si, dayOut + 2                    ; posicionamos el puntero al final
    mov ax, [day]                            ; ponemos el valor a convertir en ax
    mov bx, divid                         ; cargarmos 0x0a a bx para divir
convert2:
    xor dx, dx                            ; limpiamos dx para la division
    div bx                                ; Dividimos entre 10
    add dl, 0x30                          ; le sumamos 0x30 para imprimir
    cmp dl, '9'                           ; verificamos que no sea hexadecimal
    jbe store2                             ; si no es lo guardamos
    add dl, 'A'-'0'-10                    ; si es lo ajustamos
store2:
    dec si                                ; una posicion atras
    mov [si], dl                          ; guardamos el digito
    and ax, ax                            ; verificamos si no hay mas que hacer
    jnz convert2                           ; seguimos convierto a ascii

    mov dx, offset year                 ; cargamos la cadena a imprimir
        mov ah, 0x09                          ; usamos la opcon 0x09
        int 0x21                              ; de la interrupcion 0x21
        mov dx, offset month                 ; cargamos la cadena a imprimir
        mov ah, 0x09                          ; usamos la opcon 0x09
        int 0x21                              ; de la interrupcion 0x21
                             ; de la interrupcion 0x21
    mov dx, offset dayOut                 ; cargamos la cadena a imprimir
    mov ah, 0x09                          ; usamos la opcon 0x09
    int 0x21                              ; de la interrupcion 0x21
    pop si
    pop cx

    jmp restart
restart:
    xor bx, bx                            ; limpiamos bx
    xor ah, ah                            ; limpiamos ah
    mov dx, initial                       ; ponemos a dx en su valor inicial (1000)
    jmp condition                         ; brincamos al bucle principal

exit:
    int 0x20
error:
   int 0x20
   divid equ 0x0a                        ; para dividir entre 10
   initial equ 0x03e8                    ; valor inicial (1000)
   A dw 0x0000
   aa dw 0x0000
   b dw 0x0000
   c dw 0x0000
   k dw 0x0000
   p dw 0x0000
   q dw 0x0000
   M dw 0x0000
   N dw 0x0000
   d dw 0x0000
   e dw 0x0000
   day dw 0x0000
   dayOut db "00", 0x0d, 0x0a, "$"
   year db "aaaa", 0, "$"
   marzoDate db "/3/", 0, "$"
   abrilDate db "/4/", 0, "$"
   month db "aaa", 0, "$"
   filename db "semanaSanta.txt", 0
   fileoutput db "semanaSantaOut.txt", 0
   filesize dw 0x0000                    ; tamaño del archivo
   handle dw 0x0000
   cont db 0x0