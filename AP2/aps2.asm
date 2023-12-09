; diretivas para o assembler

org 0x7C00
bits 16

jmp start

; Dados

hello db "hello world", 0x0D, 0x0A, 0
msg   db "escreva algo: ", 0
fim   db "fim do programa",0x0D,0xA, 0
buffer db 255 ; buffer para armazenar a string do teclado

; inicio do programa

start:

    xor ax, ax     
    mov ds, ax
    mov es, ax

    call configurando_ivt
    call get_keyboard_input
    mov ax, 0x0000 ; segmento onde o buffer está localizado
    mov ds, ax
    mov si, buffer ; offset do buffer
    call print_string ; chama a função que imprime a string

    jmp end 

configurando_ivt:
    push ds
    xor ax, ax
    mov ds, ax ;; por garantia, pode ds != 0

    mov di, 0x100
    mov word[di], print_string
    mov word[di+2], 0

    pop ds ;; devolver o ds antigo

    mov ax, hello
    push ax
    ;;call print_string
    int 0x40
    add sp, 2

    mov ax, msg

    push ax
    ;;call print_string
    int 0x40
    add sp, 2

end:
    mov ax, fim
    push ax
    ;;call print_string
    int 0x40
    add sp, 2
    jmp $ ; halt

; Funções

get_keyboard_input:
    pusha
.loop:
    mov ah, 0x00
    int 0x16
    ;; apartir daqui o char vai ta no al
    cmp al, 0x0D
    je .done
    mov ah, 0x0E
    int 0x10
    jmp .loop
.done:
    popa
    iret

print_string:
    push bp ; salvar o valor de bp
    mov bp, sp
    ;; bp+0 -> bp antigo
    ;; bp+2 -> offset de retorno print_string
    ;; bp+4 -> segmento de retorno print_string
    ;; bp+6 -> flags print_string
    ;; bp+8 -> primeiro parametro
    mov ax, [bp+8]
    mov si, ax

.loop:
    ;; carrega do si um byte em ax
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .loop
.done:
    pop bp ;; devolver o valor antigo de bp
    iret  ;; n parametros * 2 (modo real)

print_number:
    pusha
    mov bx, 10
    mov cx, 0
.loop1:
    mov dx, 0
    div bx
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
    popa
    ret

; Assinatura do boot sector

    times 510-($-$$) db 0
    dw 0xAA55
