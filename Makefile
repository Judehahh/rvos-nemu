ifneq ($(shell which riscv64-unknown-elf-gcc 2>/dev/null),)
	CROSS_COMPILE := riscv64-unknown-elf-
else
	CROSS_COMPILE := riscv64-elf-
endif

CFLAGS = -nostdlib -fno-builtin -march=rv32im_zicsr -mabi=ilp32 -g -Wall

CC = ${CROSS_COMPILE}gcc
OBJCOPY = ${CROSS_COMPILE}objcopy
OBJDUMP = ${CROSS_COMPILE}objdump

SRCS_ASM = $(shell find src/ -name "*.S")

SRCS_C = $(shell find src/ -name "*.c")

OBJS = $(SRCS_ASM:.S=.o)
OBJS += $(SRCS_C:.c=.o)

.DEFAULT_GOAL := all
all: os.elf

# start.o must be the first in dependency!
os.elf: ${OBJS}
	${CC} ${CFLAGS} -Ttext=0x80000000 -o os.elf $^
	${OBJCOPY} -O binary os.elf os.bin

%.o : %.c
	${CC} ${CFLAGS} -c -o $@ $<

%.o : %.S
	${CC} ${CFLAGS} -c -o $@ $<

run: all
	@echo "------------------------"
	@echo "Running RVOS on nemu-zig"
	@echo "------------------------"
	make -C ${NEMU_HOME} run ISA=riscv32 IMG=${PWD}/os.bin

.PHONY : debug
debug: all
	@echo "-------------------------"
	@echo "Debuging RVOS on nemu-zig"
	@echo "-------------------------"
	make -C ${NEMU_HOME} debug ISA=riscv32 IMG=${PWD}/os.bin

.PHONY : code
code: all
	@${OBJDUMP} -S os.elf | less

.PHONY : clean
clean:
	rm -rf src/*.o *.bin *.elf
