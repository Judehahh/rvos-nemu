include ../common.mk

SRCS_ASM = \
	start.S \

SRCS_C = \
	kernel.c \
	uart.c \

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
	rm -rf *.o *.bin *.elf
