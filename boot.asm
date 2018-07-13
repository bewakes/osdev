[ORG 0x7c00] ; tell assembler to start address from 0x7c00
    xor ax, ax
    mov ds, ax  ; setting segment register value to the address
    mov si, msg
    mov ax, 0xb800  ; text video memory, where we put strings to be printed
    mov gs, ax
    mov bx, 0
ch_loop:
    lodsb
    or al, al
    jz hang
    mov ah, 0x0E
    mov [gs:bx], ax
    add bx, 2
    jmp ch_loop
hang:
    cli
    hlt
msg     db 'Hello world', 0
    times 510-($-$$) db 0
    db 0x55
    db 0xAA
