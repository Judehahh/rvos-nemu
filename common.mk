ifneq ($(shell which riscv64-unknown-elf-gcc 2>/dev/null),)
	CROSS_COMPILE := riscv64-unknown-elf-
else
	CROSS_COMPILE := riscv64-elf-
endif

CFLAGS = -nostdlib -fno-builtin -march=rv32im_zicsr -mabi=ilp32 -g -Wall

CC = ${CROSS_COMPILE}gcc
OBJCOPY = ${CROSS_COMPILE}objcopy
OBJDUMP = ${CROSS_COMPILE}objdump
