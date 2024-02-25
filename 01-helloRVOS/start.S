    # size of each hart's stack is 1024 bytes
    .equ STACK_SIZE, 1024

    .global _start

    .text
_start:
    la      sp, stacks + STACK_SIZE	# set the initial stack pointer
                                    # to the end of the stack space
    j       start_kernel            # hart 0 jump to c

park:
    wfi
    j	park

    # In the standard RISC-V calling convention, the stack pointer sp
    # is always 16-byte aligned.
    .balign 16
stacks:
    .skip   STACK_SIZE  # allocate space for all the harts stacks

.end    # End of file
