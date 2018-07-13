[ORG 0x7c00]
    jmp start

start: xor ax, ax
    mov ds, ax
    mov ss, ax  ; stack starts at 0
    mov sp, 0x9c00

    mov ax, 0xb800
    mov es, ax

    cli  ; no interrputions
    mov bx, 0x09  ; hardware interrupt #
    shl bx, 2  ; multiply by 4
    xor ax, ax
    mov gs, ax
    mov [gs:bx], word keyhandler
    mov [gs:bx+2], ds  ; segment
    sti

    jmp $  ; loop forever

keyhandler:
    in al, 0x60  ; get key data
    mov bl, al  ; save it
    mov byte [port60], al

    in al, 0x61  ; keyboard control
    mov ah, al
    ;or al, 0x80  ; disable bit 7, means we got the key and want another
    ;out 0x61, al
    ;xchg ah, al ; get original
    ;out 0x61, al  ; send that back

    mov al, 0x20  ; end of interrupt
    out 0x20, al

    and bl, 0x80  ; key released
    jnz done  ; don't repeat

    ; now print

    mov ax, 0xb800 ;; video text address
    mov es, ax ; es is our data pointer
    ;mov ax, [port60]
    mov bx, [printoffset] ; as new key pressed, printoffset is increased
    mov ah, 0x0C ; text fg color
    mov al, [port60]
    mov [es:bx], ax
    ; increment printoffset
    add bx, 2
    mov [printoffset], bx

done:
    iret

port60   db 0
printoffset dw 0

    times 510-($-$$) db 0
    dw 0xAA55
