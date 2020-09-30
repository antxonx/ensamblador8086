    name "p4"
    org 0x100
    jmp start
    data1 db 0x15
    data2 db 0x24
    result dw 0x0

start:
    push w.[data1]
    push w.[data2]
    call mult8b
    add sp, 4
    mov [result], ax
    int 0x20

mult8b:
    push bp
    push bx
    mov bp, sp
    mov bl, b.[bp+6]
    mov al, b.[bp+8]
    mul bl
    mov sp, bp
    pop bx
    pop bp
    ret