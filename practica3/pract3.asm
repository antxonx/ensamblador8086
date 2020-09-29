  
    name "pract3"   ;name
    
;   Antxony
    
;   Este programa realiza la suma de cinco datos
;   almacenados en las direcciones de memoria que van
;   de 0x0350 hasta 0x0354
;   El resultado se guardara tanto en elregistro AX como en las direcciones
;   0x0355 y 0x0356
    
    org 0x0100 

    mov ax,0x1003  
    mov bx,0x00        
    int 0x10

    mov dx,0x0105             
    mov bl,0x9F 
    mov cx,msg1_size  
    mov al,0x01       
    mov bp,offset msg1
    mov ah,0x13       
    int 0x10  
    
    mov dx,0x0305            
    mov bl,0x9F 
    mov cx,msg2_size  
    mov al,0x01       
    mov bp,offset msg2
    mov ah,0x13       
    int 0x10           
         
    mov dx,0x0505             
    mov bl,0x9F 
    mov cx,msg3_size  
    mov al,0x01       
    mov bp,offset msg3
    mov ah,0x13       
    int 0x10
    
    mov dx,0x0705             
    mov bl,0x9F 
    mov cx,msg4_size  
    mov al,0x01       
    mov bp,offset msg4
    mov ah,0x13       
    int 0x10
    
    mov dx,0x0905             
    mov bl,0x9F 
    mov cx,msg5_size  
    mov al,0x01       
    mov bp,offset msg5
    mov ah,0x13       
    int 0x10
    
    mov dx,0x0B05             
    mov bl,0x9F 
    mov cx,msg6_size  
    mov al,0x01       
    mov bp,offset msg6
    mov ah,0x13       
    int 0x10
    
    mov dx,0x0D05             
    mov bl,0x9F 
    mov cx,msg7_size  
    mov al,0x01       
    mov bp,offset msg7
    mov ah,0x13       
    int 0x10
    
    mov dx,0x0F05             
    mov bl,0x9F 
    mov cx,msg8_size  
    mov al,0x01       
    mov bp,offset msg8
    mov ah,0x13       
    int 0x10                      

    mov ah,0x00          
    int 0x16
    
    mov ax,0x00
    mov al,[0x350]
    add al,[0x351]
    adc ah,0x00
    add al,[0x352]
    adc ah,0x00
    add al,[0x353]
    adc ah,0x00
    add al,[0x354]
    adc ah,0x00
    mov [0x0355],ah
    mov [0x0356],al 
    
    mov dx,0x1101             
    mov bl,0x9F 
    mov cx,msg9_size  
    mov al,0x01       
    mov bp,offset msg9
    mov ah,0x13       
    int 0x10
    
    mov ah, [0x0355]
    mov al, [0x0356]      

    int 0x20  
    
    msg1 db "Seccion D07"
    msg2 db "Xxxxxxx Xxxx, Xxxxxxxxx xx Xxxxx : 000000000"
    msg3 db "Introduce tus datos en la memoria:" 
    msg4 db "Dato1 de 8 bits en direccion 0x0350" 
    msg5 db "Dato2 de 8 bits en direccion 0x0351"
    msg6 db "Dato3 de 8 bits en direccion 0x0352"
    msg7 db "Dato4 de 8 bits en direccion 0x0353"
    msg8 db "Dato5 de 8 bits en direccion 0x0354"
    msg9 db "El resultado se almacena en las direcciones 0x0355 y 0x0356, tambien en el registro AX"

msg_tail:
    msg1_size = msg2 - msg1
    msg2_size = msg3 - msg2
    msg3_size = msg4 - msg3
    msg4_size = msg5 - msg4                  
    msg5_size = msg6 - msg5
    msg6_size = msg7 - msg6
    msg7_size = msg8 - msg7
    msg8_size = msg9 - msg8
    msg9_size = msg_tail - msg9