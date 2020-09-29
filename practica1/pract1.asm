        name "pract1" ;nombre del programa

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
	mov bl, 1001_1111b            ;color de texto y fondo
	mov cx, msg2 - offset msg1    ;calcula el tamaño del mensaje 1. 
	mov dl, 7                     ;coordenadas x
	mov dh, 11                    ;coordenadas y
	push cs                       ;se guarda el contenido de cs en la pila
	pop es                        ;se copia ek valor que tetnia cs a es
	mov bp, offset msg1           ;inicio de msg1
	mov ah, 13h                   ;configuracion de intruccion
	int 10h                       ;ejecutar instruccion 10h para imporimir texto
	mov cx, msgend - offset msg2  ;calcula el tamaño del mensaje 2. 
	mov dl, 36                    ;coordenadas x
	mov dh, 13                    ;coordenadas y
	mov bp, offset msg2           ;inicio de mensaje 2
	mov ah, 13h                   ;configuracion de intruccion
	int 10h                       ;ejecutar instruccion 10h para imporimir texto
	jmp msgend                    ;saltamos a la etiqueta msgend

;Variables	
msg1    db "Hola, seminario de solución de problemas de traductores de lenguaje 1"
msg2    db "seccion D07"
;fin del programa
msgend:
        mov ah,0                  ;configuracion para instruccion 16h
        int 16h                   ;instruccion para leer entrada del teclado (u otros dispositivos)
        int 20h                   ;instruccion para finalizar programa
        
