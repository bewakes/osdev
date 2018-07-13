    mov ax, 0x07c0  ; bios loads our boot-loader to address 0x07C0
    mov ds, ax  ; setting segment register value to the address
    mov si, msg
ch_loop:
    lodsb
    or al, al
    jz hang
    mov ah, 0x0E
    int 0x10
    jmp ch_loop
hang:
    cli
    hlt
msg     db 'Hello world', 13, 10, 0
    times 510-($-$$) db 0
    db 0x55
    db 0xAA
