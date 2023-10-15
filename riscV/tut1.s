.global _start

.section .text
_start:

    # print "hewwo"
    li a7, 64 # writer
    li a0, 1
    la a1, hewwo
    li a2, 6 # length of string
    ecall # ends the block

    j shutdown

shutdown:
    li a0, 30 # load immediate 2 into a0
    li a7, 93
    ecall

.section .data
hewwo: .ascii "hewwo\n"