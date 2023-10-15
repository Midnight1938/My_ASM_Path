.global _start

_start:
# STDOUT file descriptor output is 1
    # write(1, "Hello There!\n", 13)
    addi a7, zero, 64 # sys_write code 64
    addi a0, zero, 1  # File descriptor 1
    la a1, hellowrld  # load address of hellowrld into a1
    addi a2, zero, 13 # length of string
    ecall

    addi a0, zero, 13 # Push out error 13
    addi a7, zero, 93 # always load syscall codes into a7
    ecall # Exit cleanly

hellowrld:
    .ascii "Hello There!\n"
