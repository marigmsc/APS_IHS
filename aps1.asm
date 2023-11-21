org 0x7c00           
jmp main

data:
    string db "aeiouAEIOU"
    msg db "Numero de vogais na string: "
    resultado times 4 db 0

main:

    xor ax, ax     
    mov ds, ax
    mov es, ax

    mov si, string
    call strcmpvowel
    call halt


print_string:
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .loop
.done:
    ret

print_number:
    mov bx, 10
    mov cx, 0
.loop1:
    mov dx, 0
    div bx
    ; resposta vai ta no ax, resto no dx
    add dx, 48
    push dx
    inc cx
    cmp ax, 0
    jne .loop1
.loop2:
    pop ax
    mov ah, 0x0E
    int 0x10
    loop .loop2
.done:
    ret


strcmpvowel:               
      xor bl,bl
        
      .loop1:
          lodsb          
       
          cmp al, 65 ; 'A'
          je .equal
          cmp al,69 ;'E'
          je .equal
          cmp al,73 ;'I'
          je .equal
          cmp al,79 ;'O'
          je .equal
          cmp al,85 ;'U'
          je .equal
          cmp al,97 ;'a'
          je .equal
          cmp al,101 ;'e'
          je .equal
          cmp al,105 ;'i'
          je .equal
          cmp al,111 ;'o'
          je .equal
          cmp al,117 ;'u'
          je .equal
             
          cmp al, 0        
          je .result   
          jmp .loop1        

      .equal:             
          inc bl; bl = número de vezes que vogais aparece
              
          cmp al, 0
          jne .loop1
          jmp .result

      .result:  
          mov ax, bx

          mov si, msg
          call print_string

          sub bx, 9
          xor ax, ax
          mov ax, bx
          call print_number

          ; mov di, resultado
          ; call tostring
          ; mov si, resultado
          ; call printf


halt:
    jmp $                  

times 510-($-$$) db 0
dw 0xaa55
