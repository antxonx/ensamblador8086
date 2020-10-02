    name "p4"                                                     ; TODO: comentarios
    org 0x100                                                     ; Iniciar el 0x100
    jmp start                                                     ; Saltamos al codigo
    base db 0x00                                                  ; Aquí se debe colocar el valor base
    exp db 0x00                                                   ; Aquí se debe colocar el exponente
    result dw 0x0000                                              ; Aquí se va a guardar el resultado
    msg1 db "Antxony", 0x0d, 0x0a                                 ; Mensaje 1
    msg1Size equ $ - msg1                                         ; Tamano del mensaje 1
    msg2 db "el numero base se debe guardar en: base", 0x0d, 0x0a ; Mensaje 2
    msg2Size equ $ - msg2                                         ; Tamano del mensaje 2
    msg3 db "el exponenete se debe guardar en: exp", 0x0d, 0x0a   ; Mensaje 3
    msg3Size equ $ - msg3                                         ; Tamano del mensaje 3
    msg4 db "el resultado se guardara en: result", 0x0d, 0x0a     ; Mensaje 4
    msg4Size equ $ - msg4                                         ; Tamano del mensaje 4
start:                                                            ; Inicio del programa
    push offset msg1                                              ; Segundo parametro para print, origen de la cadena
    push msg1Size                                                 ; Primer parametro para print, tamano de la cadena
    call print                                                    ; Llamamos a la funcion print
    add sp, 4                                                     ; Restauramos la pila, sumando 4 bytes ya que hicimos push a 4 para los parametros
    push offset msg2                                              ; Segundo parametro para print, origen de la cadena
    push msg2Size                                                 ; Primer parametro para print, tamano de la cadena
    call print                                                    ; Llamamos a la funcion print
    add sp, 4                                                     ; Restauramos la pila, sumando 4 bytes ya que hicimos push a 4 para los parametros
    push offset msg3                                              ; Segundo parametro para print, origen de la cadena
    push msg3Size                                                 ; Primer parametro para print, tamano de la cadena
    call print                                                    ; Llamamos a la funcion print
    add sp, 4                                                     ; Restauramos la pila, sumando 4 bytes ya que hicimos push a 4 para los parametros
    push offset msg4                                              ; Segundo parametro para print, origen de la cadena
    push msg4Size                                                 ; Primer parametro para print, tamano de la cadena
    call print                                                    ; Llamamos a la funcion print
    add sp, 4                                                     ; Restauramos la pila, sumando 4 bytes ya que hicimos push a 4 para los parametros
    mov ah, 0                                                     ; Opción para esperar entrada del teclado
    int 0x16                                                      ; Interrupción para esperar entradadel teclado (Se deben escribir los valores en memoria antes de continuar)
    mov al, [base]                                                ; Pasamos el valor de base al registro al
    xor ah, ah                                                    ; Limpiamos ah
    mov [result], ax                                              ; Pasamos ax a result, ya que desde ahí operaremos, de momento, ax = base
    mov cl, [exp]                                                 ; Pasamos a cl el exp, ya que servirá como tope para el bucle
    xor ch, ch                                                    ; Limpiamos ch ya que loop utiliza el registro cx completo
    dec cl                                                        ; cl-- = exp--
    cmp cl, 0x00                                                  ; comparamos cl con 0, el registro de banderas nos dira si cl es igual, menor o mayor que 0
    je exit                                                       ; Si cl == 0, entonces brincamos a exit ya que el valor de exp era 1, por lo tanto base elevado a 1 es igual base
    jl isone                                                      ; Si cl < 0 (cl = -1), es decir que el valor inicial de exp era 0, cualquier numero elevado a 0 es igual a 1, asi que brincamos a isone
pow:                                                              ; Si ninguna de esas condiciones se cumple comenzamos el bucle para elevar el numero a la potencia exp
    push w.[base]                                                 ; Pasamos el segundo argumento a mult8b que es el valor de base, [] para tomar el valor, w. para agararlo como 16 bits, (Solo nos impota la parte baja de 8 bits, la parte alta es basura)
    push [result]                                                 ; Pasamos el primer argumento que es lo que llevamos de resultado, si es la primera [result] == [base], pero solo usaremos la parte baja de 8 bits
    call mult8b                                                   ; Llamamos a la funcion mult8b, el resultado estara en AX con 16 bits
    add sp, 4                                                     ; Limpiamos la pila sumando los 16 bits de los argumentos
    push w.[base]                                                 ; Pasamos el segundo argumento a mult8b que es el valor de base, de nuevo
    push [result+1]                                               ; Pasamos el primer argumento para mult8b, que ahora es la parte alta de [result]
    mov [result], ax                                              ; Ya que pasamos el argumento, pasamos el resultado de la multiplicacion anterior a [result]
    call mult8b                                                   ; LLamamos a la funcion mult8b, el resultado estara en AX con 16 bits
    add sp, 4                                                     ; Limpiamos la pila de nuevo
    add b.[result+1], al                                          ; Ahora sumamos la parte base del resultado con la parte alta del resultado que ya teniamos guardado
    loop pow                                                      ; si cx > 0, brincamos a pow, sino continuamos
    jmp exit                                                      ; brincamos a la salida
isone:                                                            ; Si exp era 0, entonces el resultado es 1
    mov [result], 0x0001                                          ; Escribimos result = 1
exit:                                                             ; Salida
    int 0x20                                                      ; Interrupcion 0x20 para regresar el control al sistema operativo
                                                                  ; subrutinas
mult8b:                                                           ; Multiplicar 8bits
    push bp                                                       ; Respaldamos bp en la pila
    push bx                                                       ; Respaldamos bx en la pila
    mov bp, sp                                                    ; Pasamos la direccion actual de la pila a bp
    mov al, b.[bp+6]                                              ; Pasamos en AL nuestro segundo argumento
                                                                  ; [bp+0] es bx que respaldamos, [bp+2] es bp que respaldamos, [bp+4] es IP que se respaldo automaticamente al llamar a la funcion, [bp+6] ya es nuestro primer argumento (se suma de 2 porque son 16 bits)
    mov bl, b.[bp+8]                                              ; Pasamos en BL nuestro primer argumento
                                                                  ; Lo mismo de antes, [bp+8] ya es nuestro segundo argumento
    mul bl                                                        ; Esto es igual a (AX = AL * BL) el valor se guarda en AX, en 16 bits
    pop bx                                                        ; Recuperamos bx de la pila
    pop bp                                                        ; Recuperamos bp de la pila
    ret                                                           ; Finalizamos la funcion (Se recupera el valor de IP desde la pila)
print:                                                            ; Funcion para imprimir
    push bp                                                       ; Respaldamos bp en la pila
    push ax                                                       ; Respaldamos ax en la pila
    push bx                                                       ; Respaldamos bx en la pila
    push cx                                                       ; Respaldamos cx en la pila
    mov bp, sp                                                    ; Pasamos la direccion actual de la pila a bp
    mov ah, 0x03                                                  ; Opcion 0x03 de la interrupcion para recuperar la posicion actual del cursor en la consola, se guarda en DH y DL, asi que ya no necesitamos especificarlos despues para imprimir
    int 0x10                                                      ; Ejecutamos la interrupcion
    mov al, 0x01                                                  ; Opcion para darle color al texto
    mov bh, 0x00                                                  ; Pagina 0
    mov bl, 0x0f                                                  ; Color de fondo negro, texto blanco
    mov cx, [bp+10]                                               ; Pasamos a CX el primer argumento de la funcion, que es el tamano de la cadena
                                                                  ; [bp+0] es el respaldo de CX, [bp+2] es el respaldo de BX, [bp+4] es el respaldo de AX, [bp+6] es el respaldo de BP, [bp+8] es el respaldo de IP, [bp+10] es nuestro argumento
    mov bp, [bp+12]                                               ; Pasamos a BP el segundo argumento, reescribiendo BP y ya no apunta a la pila
                                                                  ; [bp+0] es el respaldo de CX, [bp+2] es el respaldo de BX, [bp+4] es el respaldo de AX, [bp+6] es el respaldo de BP, [bp+8] es el respaldo de IP, [bp+10] es el primer argumento, [bp+12] es nuestro segundo argumento
    mov ah, 0x13                                                  ; Opcion para imprimir en pantalla
    int 0x10                                                      ; Ejecutamos interrupcion 0x10
    pop cx                                                        ; Recuperamos cx de la pila
    pop bx                                                        ; Recuperamos bx de la pila
    pop ax                                                        ; Recuperamos ax de la pila
    pop bp                                                        ; Recuperamos bp de la pila
    ret                                                           ; finalizamos la funcion (Se recupera el valor de IP desde la pila)