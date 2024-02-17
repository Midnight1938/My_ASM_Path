bits 16
org 0x7c00 ;; BIOS loads the boot sector at 0x7c00

boot:
    mov ax, 0x2401
    int 0x15 ;; Enabling the A20 bit. The System bus of x86
    mov ax, 0x3 ;; ax is the register that holds the mode
    int 0x10 ;; set to VGA mode 3. Which is 80x25 text mode
    cli
    lgdt [gdt_pointer] ;; Load the GDT
    mov eax, cr0 ;; Load the control register 0
    or eax, 0x1 ;; Set the first bit of the control register 0
    mov cr0, eax ;; Load the control register 0
    jmp CODE_SEG:boot2 ;; Jump to the code segment. The CPU will now be in 32-bit mode

gdt_start:
    dq 0x0 ;; Null segment. dq means define quadword
gdt_code:
    dw 0xffff ;; Code segment limit
    dw 0x0 ;; Code segment base
    db 0x0 ;; Code segment base
    db 10011010b ;; 1st byte of access byte
    db 11001111b ;; 2nd byte of access byte
    db 0x0 ;; 3rd byte of access byte
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0 
gdt_end:

gdt_pointer:
    dw gdt_end - gdt_start - 1 ;; Limit of the GDT
    dd gdt_start ;; Base of the GDT

CODE_SEG equ gdt_code - gdt_start ;; Define the code segment
DATA_SEG equ gdt_data - gdt_start ;; Define the data segment

bits 32
boot2:
    mov ax, DATA_SEG ;; Load the data segment
    ;; remaining point to data segment as well
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esi, hellow
    mov ebx, 0xb8000 ;; Send to text buffer
.loop:
    lodsb
    or al, al
    jz halt
    or eax,0x0200 ;; text colour to blue. 0 black, 1 blue, 15 white
    mov word [ebx], ax
    add ebx, 2
    jmp .loop

halt:
    cli
    hlt

hellow: db "Hello World! I am 32 Bit", 0

times 510 - ($-$$) db 0 ;; pad remainder of boot sector with 0s
dw 0xaa55 ;; mark the sector as bootable