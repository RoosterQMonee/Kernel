.PHONY: build

BUILDDIR = build
OBJFILES := $(shell find $(BUILDDIR) -name '*.o')

assembly:
	nasm -f elf32 src/boot.asm -o build/boot.o

source:
	g++ -c src/kernel.cpp -o ./build/kernel.o -O2 -Wall -m32

clean:
	rm -rf ./build
	rm -rf ./bin

	mkdir ./build
	mkdir ./bin

build:
	ld -T linker.ld -o bin/os.bin -static -nostdlib $(OBJFILES) -melf_i386

run:
	$(MAKE) clean
	$(MAKE) assembly
	$(MAKE) source
	$(MAKE) build

	mkdir -p isodir/boot/grub
	cp bin/os.bin isodir/boot/os.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o bin/os.iso isodir

	qemu-system-i386 -cdrom bin/os.iso -serial file:serial.log