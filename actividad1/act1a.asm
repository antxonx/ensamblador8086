    ; Evaluar si los años del archivo de entrada son bisiestos
    ;y generar salida por consola y
    org 0x100
    ; Inicio del programa
    mov ah, 0x3c                          ; crear archivo para resultados
    mov cx, 0x0                           ; sin atributos
    mov dx, offset fileoutput             ; cargamos el nombre del archivo
    int 0x21                              ; ejecutamos la interrupción
    jc error                              ; si CF = 1 ocurrió un error
    mov handleRes, ax                     ; guardamos el handle
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
    jmp exit                              ; sino vamos a la salida
eval:
    push cx                               ; respaldamos cx
    mov ax, bx                            ; movemos bx a ax para la division
    xor dx, dx                            ; limpiamos dx
    mov cx, bisiesto                      ; cargamos el 4
    div cx                                ; dividimos ax / cx
    pop cx                                ; recuperamos cx
    cmp dx, 0x0000                        ; verificamos si hay residuo o no
    je correct                            ; si hay lo mostramos
restart:
    xor bx, bx                            ; limpiamos bx
    xor ah, ah                            ; limpiamos ah
    mov dx, initial                       ; ponemos a dx en su valor inicial (1000)
    jmp condition                         ; brincamos al bucle principal
correct:
    push cx                               ; respaldamos cx
    push si                               ; respaldamos si
    lea si, result + 4                    ; posicionamos el puntero al final
    mov ax, bx                            ; ponemos el valor a convertir en ax
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
    mov dx, offset result                 ; cargamos la cadena a imprimir
    mov ah, 0x09                          ; usamos la opcon 0x09
    int 0x21                              ; de la interrupcion 0x21
    mov ax, 0x4202                        ; vamos al final del archivo
    mov bx, handleRes                     ; especificamos el handle del archivo
    mov dx, 0x0                           ; sin offset
    mov cx, 0x0                           ; sin offset
    int 0x21                              ; ejecutamos la interrupción
    jc error
    mov ah, 0x40                          ; opcion para escribir en archivo
    mov bx, handleRes                     ; pasamos el handle del archivo
    mov cx, filename - offset result - 1  ; tamano de cadena a imprimir (-1 para evitar "$")
    mov dx, offset result                 ; dirección de la cadena
    int 0x21                              ; ejecutamos la interrupcion
    jc error
    pop si                                ; recuperamos si
    pop cx                                ; recuperamos cx
    jmp restart                           ; volvemos a empezar con el siguiente dato
exit:
    mov ah, 0x3e                          ; cerrar el archivo
    mov bx, handleRes                     ; especificamos el handler
    int 0x21                              ; ejecutamos la interrupción
error:
    int 0x20                              ; salimos del programa
    divid equ 0x0a                        ; para dividir entre 10
    bisiesto equ 0x04                     ; para dividir los años
    initial equ 0x03e8                    ; valor inicial (1000)
    result db "aaaa", 0x0d, 0x0a, "$"     ; aqui se guarda el resultado con formato para imprimir
    filename db "bisiesto.txt", 0         ; nombre del archivo
    fileoutput db "bisiestoresult.txt", 0 ; nombre del archivo de salida
    handle dw ?                           ; handler
    handleRes dw ?                        ; handler para resultado
    filesize dw ?                         ; tamaño del archivo
    cont db ?                             ; contenido del archivo
