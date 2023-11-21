org 0x7c00           
jmp main

data:
    string db "teste"
    resultado times 4 db 0

main:
; limpa registradores
    xor ax, ax     
    mov ds, ax
    mov es, ax

    mov si,string
    call strcmpvowel
    call halt



; FUNÇÃO PARA RECEBER STRING::::::::::::::::::::::::::::::::::::::::::
getchar:               
  mov ah, 0x00
  int 16h
  ret
  
delchar:                
  mov al, 0x08          
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08
  call putchar
  ret
  
endl:                  
  mov al, 0x0a
  call putchar
  mov al, 0x0d
  call putchar
  ret

scanf:                  
  xor cx, cx        
  .loop1:
    call getchar
    cmp al, 0x08
    je .backspace
    cmp al, 0x0d
    je .done
    
    stosb
    inc cl
    mov ah, 0xe
    mov bh, 0
    mov bl, 15       
    call putchar
    
    jmp .loop1
    .backspace:
      cmp cl, 0
      je .loop1
      dec di
      dec cl
      mov byte[di], 0
      call delchar
    jmp .loop1
  .done:
  mov al, 0
  stosb
  call endl
ret

;FUNÇÃO PARA PRINTAR STRING :::::::::::::::::::::::::::::::::::::::::
putchar:
  mov ah, 0xe
  int 10h
  ret

printf:                    
      .loop1:       
        lodsb	         
    cmp al, 0          
    je .fim		   
    call putchar      
    jmp .loop1         
    
      .fim:
ret

reverse:              ; mov si, string
  mov di, si
  xor cx, cx          ; zerar contador
  .loop1:             ; botar string na stack
    lodsb
    cmp al, 0
    je .endloop1
    inc cl
    push ax
    jmp .loop1
  .endloop1:
  .loop2:             ; remover string da stack        
    pop ax
    stosb
    loop .loop2
  ret

tostring:              ; mov ax, int / mov di, string
  push di
  .loop1:
    cmp ax, 0
    je .endloop1
    xor dx, dx
    mov bx, 10
    div bx            ; ax = 9999 -> ax = 999, dx = 9
    xchg ax, dx       ; swap ax, dx
    add ax, 48        ; 9 + '0' = '9'
    stosb
    xchg ax, dx
    jmp .loop1
  .endloop1:
  pop si
  cmp si, di
  jne .done
  mov al, 48
  stosb
  .done:
  mov al, 0
  stosb
  call reverse
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
          mov di, resultado
          call tostring
          mov si, resultado
          call printf

strcmp:                             ; compara duas lihas armazanadas em si e di
	.loop1:
		lodsb
		cmp byte[di], 0
		jne .continue
		cmp al, 0
		jne .done
		stc
		jmp .done
		
		.continue:
			cmp al, byte[di]
    			jne .done
			clc
    			inc di
    			jmp .loop1

		.done:
			ret
halt:
    jmp $                  

times 510-($-$$) db 0
dw 0xaa55
