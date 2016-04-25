OBJCOPY = objcopy
LD      = ld
NASM    = nasm
QEMU    = qemu-system-i386

fivetwelve.img: fivetwelve.elf
	$(OBJCOPY) -O binary $< $@

fivetwelve.elf: fivetwelve.o
	$(LD) $< -T fivetwelve.ld -o $@

fivetwelve.o: fivetwelve.asm
	$(NASM) $< -f elf32 -g -o $@

.PHONY: clean
clean:
	$(RM) fivetwelve.o fivetwelve.elf fivetwelve.img

.PHONY: run
run: fivetwelve.img
	$(QEMU) -drive file=fivetwelve.img,format=raw
