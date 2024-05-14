.PHONY: build

OBJFILES := $(shell find ./build -type f -name "\*.o"

# /home/nam/opt/cross/bin"

assembly:
	nasm -felf32 boot.asm -o ./build/boot.o

source:
	/home/nam/opt/cross/bin/i686-elf-g++ -c kernel.cpp -o ./build/kernel.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti

clean:
	rm -rf ./build
	rm -rf ./bin

	mkdir ./build
	mkdir ./bin

build:
	/home/nam/opt/cross/bin/i686-elf-g++ -T linker.ld -o ./bin/os.bin -ffreestanding -O2 -nostdlib $(OBJFILES) -lgcc

run:
	$(MAKE) clean
	$(MAKE) assembly
	$(MAKE) source
	$(MAKE) build
	
	if grub-file --is-x86-multiboot os.bin; then
		echo "Binary is Multiboot"
	else
		echo "Binary is not Multiboot"
	fi

	mkdir -p isodir/boot/grub
	cp myos.bin isodir/boot/os.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o os.iso isodir