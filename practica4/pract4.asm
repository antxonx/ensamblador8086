    name "p4"
    org 0x100
    jmp start
    base db 0x15
    exp db 0x02
    result dw 0x0000
start:
    mov al, [base]
    xor ah, ah
    mov [result], ax
    mov cl, [exp]
    dec cl
    cmp cl, 0x00
    je exit
    jl isone
pow:
    push w.[base]
    push [result]
    call mult8b
    add sp, 4
    push w.[base]
    push [result+1]
    mov [result], ax
    call mult8b
    add sp, 4
    add b.[result+1], al
    loop pow
    jmp exit
isone:
    mov [result], 0x0001
exit:
    int 0x20
mult8b:
    push bp
    push bx
    mov bp, sp
    mov al, b.[bp+6]
    mov bl, b.[bp+8]
    mul bl
    mov sp, bp
    pop bx
    pop bp
    ret