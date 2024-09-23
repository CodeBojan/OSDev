@echo off
nasm -f bin -o boot1.bin boot1.asm

SET result=%ERRORLEVEL%

IF %result% EQU 0 (
    ECHO Build finished successfully
) ELSE (
    ECHO Build failed with error code %result%. See output for more info.
)
cd ..
bochs
cd build