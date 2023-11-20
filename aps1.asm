org 0x7c00           
jmp main

data:
    string times 100 db 0
    resultado times 4 db 0

main:
; limpa registradores
    xor ax, ax     
    mov ds, ax
    mov es, ax

    mov di,string
      call scanf
    mov si,string
      call strcmp
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
strcmp:               
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

      .vogal:             
          inc bl; bl = número de vezes que vogais aparece
              
          cmp al, 0
          jne .loop1
          jmp .result
      .result:  
      xor al,al
      mov bl,al
      call putchar

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
