frmt : db "%d", 0x0a, 0x00
global fib
extern printf
;Funcion para secuancia de fibonacci
fib:
	push rbp
	mov rbp, rsp
	mov rcx, rdi           ;Argumento, cantidad de elementos en la serie
	mov rax, 0x01          ;rax = 1
	xor rbx, rbx           ;rbx = 0
fib_start:                 ;Inicio del loop
	mov rdx, rax           ;rdx = rax
	add rax, rbx           ;rax = rax + rbx
	mov rbx, rdx           ;rbx = rdx
	push rax               ;respaldamos los datos
	push rbx	           ; ||
	mov rsi, rbx           ;Numero que vamos a imprimir, rsi = rbx
	mov rax, 0x00          ;Es entero, rax = 0
	mov rdi, frmt          ;Formato de impresion, rdi = "%d\n"
	push rcx               ;respaldamos rcx
	call printf wrt ..plt  ;imprimir el numero
	pop rcx                ;recuperamos de la pila
	pop rbx                ;||
	pop rax                ;||
	loop fib_start         ;mientras rcx > 0
	mov rsp, rbp
	pop rbp
	ret