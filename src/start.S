    # size of each hart's stack is 1024 bytes
    .equ STACK_SIZE, 1024

    .text
    .global _start
_start:
    # Set all bytes in the BSS section to zero.
    la      a0, _bss_start
    la      a1, _bss_end
    bgeu    a0, a1, 2f
1:
    sw      zero, (a0)
    addi    a0, a0, 4
    bltu    a0, a1, 1b
2:
    la      sp, stacks + STACK_SIZE	# set the initial stack pointer
                                    # to the end of the stack space
    j       start_kernel            # hart 0 jump to c

park:
    wfi
    j       park

    # In the standard RISC-V calling convention, the stack pointer sp
    # is always 16-byte aligned.
    .balign 16
stacks:
    .skip   STACK_SIZE  # allocate space for all the harts stacks

.end    # End of file
