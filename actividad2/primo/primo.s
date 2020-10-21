;---------- data
section .data
frmt: db "%d, ", 0x00
frmtS db "%s", 0x00
br db 0x0a, 0x00
;---------- /data
;---------- bss
section .bss
eval resq 1
highLimit resq 1
;---------- /bss
;---------- text
section .text
global primo
extern printf
;---------- primo
primo:
    push rbp
	mov rbp, rsp
    mov rcx, rdi
    mov [rel highLimit], rsi
;---------- recorrido
primo_recorrido:
    cmp rcx, 0x01
    jz primo_recorrido_back
    mov [rel eval], rcx 
    push rcx
;---------- evaluar
    mov rcx, 0x02
primo_evaluar:
    xor rdx, rdx
    mov rax, [rel eval]
    div rcx
    cmp rdx, 0
    jz primo_recorrido_back_bef
    inc rcx
    cmp rcx, [rel eval]
    jnge primo_evaluar
    mov rdi, frmt
    mov rsi, [rel eval]
    mov rax, 0x00
    push rcx
	call printf wrt ..plt  
    pop rcx
;---------- /evaluar
primo_recorrido_back_bef:
    pop rcx
primo_recorrido_back:
    inc rcx
    cmp rcx, [rel highLimit]
    jng primo_recorrido
;---------- /recorrido
primo_salir:
    mov rdi, frmtS
    mov rsi, br
    mov rax, 0x00
	call printf wrt ..plt
    mov rsp, rbp
	pop rbp
	ret
;---------- /primo
;---------- /text