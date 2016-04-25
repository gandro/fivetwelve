fivetwelve
==========

An attempt in writing a game that fits into the x86 Master Boot Record. Not a
game yet.

Requirements:

  - NASM version 2.x
  - GNU binutils supporting i386
  - QEMU or a x86 machine with a BIOS supporting 8x8 fonts

Getting started
---------------

To run the game using `qemu-system-i386`, simply execute:

    make run

The Makefile not only generates the `fivetwelve.img` MBR image, but also an ELF
file containing the debug symbols.

Debugging
---------

When disassembling with `objdump`, make sure to use the `-mi8086` flag for
proper decoding:

    objdump -mi8086 -d fivetwelve.elf

You can use `gdb` in conjunction with QEMU to step though the running binary:

    qemu-system-i386 -drive file=fivetwelve.img,format=raw -S -s &
    gdb -ex 'target remote localhost:1234' \
        -ex 'set architecture i8086' \
        -ex 'break *0x7c00' \
        -ex 'continue' \
        fivetwelve.elf

