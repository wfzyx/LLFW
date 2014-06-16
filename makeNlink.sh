#!/bin/bash
rm *.o
rm *.bin
rm *.img
nasm -f bin boot.asm -o boot.bin
gcc -ffreestanding -c main.c -o main.o
gcc -c video.c -o video.o
gcc -c ports.c -o ports.o
ld -e main -Ttext 0x1000 -o kernel.o main.o video.o ports.o
# ld -i -e main -Ttext 0x1000 -o kernel.o main.o video.o ports.o
objcopy -R .note -R .comment -S -O binary kernel.o kernel.bin
cat boot.bin kernel.bin >> bloader.img
rm *.o
rm *.bin