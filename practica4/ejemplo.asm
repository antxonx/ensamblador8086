    name "p4"   ; 
    
;   Este programa realiza la multiplicación de tres datos
;   cada dato es de 8 bits la multiplicación se realiza 
;   usando solo registros de 8 bits.
    
    org  100h	; 

    mov ax, 1003h  
    mov bx, 0        
    int 10h

    mov dx, 0705h     
    mov bl, 10011111b 
    mov cx, msg1_size  
    mov al, 01b       
    mov bp, msg1
    mov ah, 13h       
    int 10h  
    
    mov dx, 0905h          
    mov bl, 10011111b 
    mov cx, msg2_size        
    mov bp, msg2
    mov ah, 13h       
    int 10h           
         
    mov dx, 0B05h            
    mov bl, 11111001b 
    mov cx, msg3_size       
    mov bp, msg3
    mov ah, 13h       
    int 10h           

    mov dx, 0C05h             
    mov bl, 11111001b 
    mov cx, msg4_size        
    mov bp, msg4
    mov ah, 13h       
    int 10h           

    mov dx, 0D05h            
    mov bl, 11111001b 
    mov cx, msg5_size       
    mov bp, msg5
    mov ah, 13h       
    int 10h           
 
    mov dx, 0E05h            
    mov bl, 11111001b 
    mov cx, msg6_size        
    mov bp, msg6
    mov ah, 13h       
    int 10h           

    mov ah, 0          
    int 0x16
   
    mov ax,0
    mov bx,0
    mov al,[Dato1]
    mov [D1],al
    mov al,[Dato2]
    mov [D2],al
    call mult
    mov ax,[P0]
    mov [Prod],ax
    mov [D1],al
    mov al,[Dato3]
    mov [D2],al
    call mult
    mov al,b.[Prod+1]
    mov [D1],al
    mov ax,[P0]
    mov [Prod],ax
    call mult
    mov ax,[P0]
    add b.[Prod+1],al

    int 20h
    
Dato1   db 0
Dato2   db 0
Dato3   db 0
Prod    dw 0
D1      db 0  ;Variables internas
D2      db 0
P0      dw 0  
    
msg1:   db "Seccion D07"
msg2:   db "Introduce tus datos en la memoria:"
msg3:   db "Dato1 variable de entrada de 8 bits"
msg4:   db "Dato2 variable de entrada de 8 bits"
msg5:   db "Dato3 variable entrada de 8 bits"
msg6:   db "Prod variable de salida de 16 bits"
msg_tail:
msg1_size = msg2 - msg1
msg2_size = msg3 - msg2
msg3_size = msg4 - msg3
msg4_size = msg5 - msg4
msg5_size = msg6 - msg5
msg6_size = msg_tail - msg6

mult:   
    push ax
    push bx
    mov al,[D1]
    mov bl,[D2]
    mul bl
    mov [P0],ax
    pop bx
    pop ax
    ret                  