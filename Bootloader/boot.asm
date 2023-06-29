    bits 16

    mov ax, 0x07C0
    mov ds, ax
    mov ax, 0x7E0               ; 07E0h = (07C00h+200h)/10h, beginning of stack segment.
    mov ss, ax
    mov sp, 0x2000              ; 8K of stack space
    
    call clearscreen
    
    push 0x0000
    call movecursor
    add sp, 2
    
    push msg
    call print
    add sp, 2
    
    cli
    hlt
    
clearscreen:
    push bp
    mov bp, sp
    pusha

    mov ah, 0x07                ; tells BIOS to scroll down
    mov al, 0x00                ; clear window
    mov bh, 0x07                ; BnW screen
    mov cx, 0x00                ; screen top left corner is (0x0)
    mov dh, 0x18                ; 18h is 24 char rows
    mov dl, 0x4f                ; 4f is 79 char cols
    int 0x10                    ; calls video interrupt
    
    popa
    mov sp, bp
    pop bp
    ret
    
movecursor:    
    push bp
    mov bp, sp                 
    pusha
    mov dx, [bp+4]              ; get arg from stack. |bp| =2, |arg| =2
    mov ah, 0x02                ; Set cursor pos
    mov bh, 0x00                ; page number 0, not using double buff so dont care
    int 0x10                    ; call video interrupt

    popa
    mov sp, bp
    pop bp
    ret
    
print:
    push bp
    mov bp, sp
    pusha
    mov si, [bp+4]              ; grab pointer to data
    mov bh, 0x00                ; page number 0, ya know
    mov bl, 0x00                ; foreground color is irrelevant in text mode
    mov ah, 0x0E                ; print char to TTY
.char:
    mov al, [si]                ; get current char from position
    add si, 1                   ; increment till null char
    or al, 0 
    je .return                  ; ent of the string is done
    int 0x10                    ; print char if not done
    jmp .char                   ; continue loop
.return:
    popa
    mov sp, bp
    pop bp
    ret
    
    
msg:    db "Hakunamata! A USB Bootloader. In assembly no less!", 0
        times 510-($-$$) db 0
        dw 0xAA55
