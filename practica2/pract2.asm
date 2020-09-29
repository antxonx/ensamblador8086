        name "pract2" ;nombre del programa

; este programa imprime dos mensajes en la pantalla
; escribiendo directamente en la memoria de video.
; en la memoria vga: el primer byte es el caracter ascii,
; el siguiente byte son los atributos del caracter.
; los atributos del caracter es un valor de 8 bits,
; los 4 bits altos ponen el color del fondo
; y los 4 bits bajos ponen el color de la letra.

; hex    bin        color
; 
; 0      0000      black
; 1      0001      blue
; 2      0010      green
; 3      0011      cyan
; 4      0100      red
; 5      0101      magenta
; 6      0110      brown
; 7      0111      light gray
; 8      1000      dark gray
; 9      1001      light blue
; a      1010      light green
; b      1011      light cyan
; c      1100      light red
; d      1101      light magenta
; e      1110      yellow
; f      1111      white
 


org 100h
;inicio del programa
	mov al, 1                     ;cursor
	mov bh, 0                     ;paleta de colores
	mov bl, 1101_0000b            ;color de texto y fondo
	mov cx, msg2 - offset msg1    ;calcula el tamaño del mensaje 1. 
	mov dl, 3                     ;coordenadas x
	mov dh, 2                     ;coordenadas y
	push cs                       ;se guarda el contenido de cs en la pila
	pop es                        ;se copia el valor que tetnia cs a es
	mov bp, offset msg1           ;inicio de msg1
	mov ah, 13h                   ;configuracion de intruccion
	int 10h                       ;ejecutar instruccion 10h para imporimir texto
	mov cx, msg3 - offset msg2    ;calcula el tamaño del mensaje 2. 
	mov dl, 32                    ;coordenadas x
	mov dh, 4                     ;coordenadas y
	mov bp, offset msg2           ;inicio de mensaje 2
	mov ah, 13h                   ;configuracion de intruccion
	int 10h                       ;ejecutar instruccion 10h para imporimir texto
	mov bl, 1011_0100b            ;Fondo cyan, letras rojas
	mov cx, msgend - offset msg3  ;calcular el tamaño del mensaje 3
	mov dl, 21                    ;coordenadas x
	mov dh, 7                     ;coordenadas y
	mov bp, offset msg3           ;inicio del mensaje 3
	mov ah, 13h                   ;configuracion de intruccion
	int 10h                       ;ejecutar instruccion 10h para imporimir texto    
	jmp msgend                    ;saltamos a la etiqueta msgend

;Variables	
msg1    db "Hola, soy un mensaje para la practica de traductores de lenguaje"
msg2    db "safiro"
msg3    db "Xxxxxxx Xxxx, Xxxxxxxxx xx Xxxxx"
;fin del programa
msgend:
        mov ah,0                  ;configuracion para instruccion 16h
        int 16h                   ;instruccion para leer entrada del teclado (u otros dispositivos)
        mov dx, 0xcccc            ;bits mas significativos de codigo de estudiante
	    mov cx, 0x1111            ;bits menos significativos de codigo de estudiante
	    mov bx, 0x21d9            ;bits mas significativosa de NRC de la materia
	    mov ax, 0x1d91            ;bits menos significativos de NRC de la materia
        int 20h                   ;instruccion para finalizar programa
        
