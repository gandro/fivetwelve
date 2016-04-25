bits 16                             ; tip: use -mi8086 for objdump disassembly
global _start                       ; we use a linker script for debug ELFs

_start:
    xor ax, ax                      ; clear AX

    ; set stack to 0000:9c00
    mov ss, ax                      ; stack segment
    mov sp, 0x9c00                  ; stack pointer

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

    mov ax, 0x0a18                  ; upwards green ant
    mov di, 0x1000
    stosw

.init:
    mov cx, 4000                   ; loop over all 80x50 pixels
.next:

    mov si, cx
    add si, si                      ; we want [es:2*si]
    lodsw                           ; pixel is now in AX

    jz .update                      ; skip nonpixels



.update:
    loop .next

    ; end of loop
    mov bx, [0x046c]                 ; number of IRQ0 timer ticks since boot
    add bx, 10

.delay:
    cmp [0x046c], bx
    jne .delay

    jmp .init

halt:
    hlt                             ; halt
