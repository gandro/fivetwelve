bits 16                             ; tip: use -mi8086 for objdump disassembly

section .text                       ; we use a linker script for debug ELFs
global _start

_start:
    xor ax, ax                      ; clear AX

    ; set stack to 0000:9c00
    mov ss, ax                      ; stack segment
    mov sp, 0x9c00                  ; stack pointer - TODO why this value?

    ; use data segment 0x0000
    mov ds, ax                      ; set to zero

    ; load video memory address for stos{,b,w,d}
    mov ah, 0xb8                    ; AL is still zero
    mov es, ax                      ; ES=0xB800 address of video segment

    ; set up graphic mode and clear screen
    mov ax, 0x03                    ; AH=0x00 set graphic mode
                                    ; AL=0x03 text mode, 80x25, 16 colors
    int 0x10

    ; set up character font for 80x50
    mov ax, 0x1112                  ; AH=0x11 character generation
                                    ; AL=0x12 load 8x8 character font
    mov bl, 0x00                    ; character set 0
    int 0x10

    ; set up text mode cursor
    mov ah, 0x01                    ; AH=0x01 (text mode cursor shape)
    mov ch, 0x10                    ; cursor invisible if bits 6-5 = 01
    int 0x10

    ;mov ax, 0x0a18                  ; upwards green ant
    ;mov di, 0x1000
    ;stosw

init_screen:         
    mov cx, 80 * 50
    mov ax, 0x0400                  ; fill screen with red fg, black bg
    xor di, di
    rep stosw

init_ants:
    mov cx, [ants.len]
    mov bx, ants
.iterate:
    call random
    xor dx, dx
    div word [init_ants.max]        ; shorter than immediate in register
    mov [bx], dx
    add bx, 2
    loop .iterate

clear_screen:
    mov cx, 80 * 50
    mov di, 0
    mov si, 0
.iterate:
    es lodsw
    mov al, 0                      ; clear character
    stosw
    loop .iterate

draw_ants:
    mov cx, [ants.len]
    mov bx, ants
.iterate:
    mov ax, [bx]
    mov di, ax
    shr di, 2
    shl di, 1                       ; di = flat position, times 2

    and ax, 0x3                     ; ax = state

    ; update orientation
    mov ah, [es:di + 1]             ; copy color from screen

    ; update position
    

    ; flip color and store it on old position

    xor ah, 0xA0                    ; flip color
    add al, 0x18                    ; new state to character
    stosw



    add bx, 2                       ; next ant
    loop .iterate

    jmp halt



random:                             ; stores the result in ax
    push dx
    xor dx, dx
    mov word ax, 17364
    mul word [random.seed]
    div word [random.modulus]
    mov [random.seed], dx
    mov ax, dx
    pop dx
    ret


halt:
    cli
    hlt                             ; halt

section .bss
ants.max equ 128
ants:
    resw ants.max           ; position << 2 | state

section .data
ants.len:
    dw 8
init_ants.max:
    dw ((80 * 50) << 2) | 0x3
random.seed: 
    dw 23
random.modulus:
    dw 65521
