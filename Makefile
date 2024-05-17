.PHONY: build

OBJFILES := $(shell find ./build -type f -name "\*.o")
# /home/nam/opt/cross/bin Replace this with your cross compiler location (idrk how to use makefiles :[)

assembly:
	as boot.asm -o ./build/boot.o

source:
	g++ -c kernel.cpp -o ./build/kernel.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti

clean:
	rm -rf ./build
	rm -rf ./bin

	mkdir ./build
	mkdir ./bin

build:
	g++ -T linker.ld -o ./bin/os.bin -ffreestanding -O2 -nostdlib $(OBJFILES) -lgcc

run:
	$(MAKE) clean
	$(MAKE) assembly
	$(MAKE) source
	$(MAKE) build

	mkdir -p isodir/boot/grub
	cp bin/os.bin isodir/boot/os.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o bin/os.iso isodir

	qemu-system-i386 -cdrom bin/os.iso