.PHONY: build

MAKEFLAGS += --no-print-directory
BUILDDIR = build
OBJFILES := $(shell find $(BUILDDIR) -name '*.o')

assembly:
	nasm -f elf32 src/boot.asm -o build/boot.o

source:
	g++ -c src/kernel.cpp -o ./build/kernel.o -O2 -Wall -m32 -Isrc

clean:
	@rm -rf ./build

	@mkdir ./build
	@mkdir ./build/bin

build:
	ld -T linker.ld -o ./build/bin/os.bin -static $(OBJFILES) -melf_i386

run:
	@$(MAKE) clean
	@$(MAKE) assembly
	@$(MAKE) source
	@$(MAKE) build

	@mkdir -p ./build/isodir/boot/grub
	@cp ./build/bin/os.bin ./build/isodir/boot/os.bin
	@cp grub.cfg ./build/isodir/boot/grub/grub.cfg
	grub-mkrescue -o ./build/bin/os.iso ./build/isodir

	qemu-system-i386 -cdrom ./build/bin/os.iso -serial file:serial.log