#!/bin/bash
nasm -f bin mbr.asm -o mbr.bin
dd if=mbr.bin of=hd.img conv=notrunc