# Makefile for building and running RISC-V assembly programs

AS = riscv64-linux-gnu-as
CC = riscv64-linux-gnu-gcc
QEMU = qemu-riscv64-static
BUILD_DIR = build

.DEFAULT_GOAL := all

all: hello

%: %.s
	$(AS) $< -o $(BUILD_DIR)/$@.o
	$(CC) -o $(BUILD_DIR)/$@ $(BUILD_DIR)/$@.o -static -nostdlib
	$(QEMU) $(BUILD_DIR)/$@

clean:
	rm -rf $(BUILD_DIR)
