@echo off
nasm -f bin -o boot1.bin boot1.asm
cd ..
bochs
cd build