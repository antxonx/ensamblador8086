    org 0x100
    jmp start
    base db 0x1b
    exp db 0x03
    result dw 0x0000
start:
    mov al, [base]
    xor ah, ah
    mov [result], ax

    mov cl, [exp]
    xor ch, ch
    dec cl
    cmp cl, 0x00
    je exit
    jl isone
pow:
    mov al, byte ptr [result]
    mov bl, [base]
    mul bl
    mov dx, ax
    mov al, byte ptr [result+1]
    mov bl, [base]
    mov [result], dx
    mul bl
    add byte ptr [result+1], al
    mov ax, [result]
    loop pow
    jmp exit
isone:
    mov [result], 0x0001
exit:
    int 0x20