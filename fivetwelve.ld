/* MBR linker script, to generate a valid ELF binary for debugging */
OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i8086)
ENTRY(_start)

SECTIONS
{
    . = 0x7c00;
    .text : {
        *(.text)
    }
    .data : {
        *(.data)
    }
    .signature : AT(0x7dfe)
    {
        SHORT(0xaa55);
    }
}
