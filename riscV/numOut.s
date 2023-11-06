.section .text
.globl _start

_start:
    # Load immediate values into registers
    li t0, 4       # t0 register now holds the value 4
    li t1, 5       # t1 register now holds the value 5

    # Perform the addition
    add t2, t0, t1 # t2 register now holds the result of t0 + t1 (9)

    #! Convert the integer result to a string to print it
    # This is a simple conversion for a single-digit number
    addi t2, t2, '0' # Convert the integer 9 to the ASCII character '9'

    # Prepare the buffer on the stack
    addi sp, sp, -2   # Allocate 2 bytes on the stack
    sb t2, 0(sp)      # Store byte of t2 on stack 0
    li t3, 10         # Load the newline character for smooth end
    sb t3, 1(sp)      # Store it in the stack

    # Prepare the arguments for the write system call
    li a7, 64         # The system call for write in RISC-V Linux
    li a0, 1          # File descriptor 1 is stdout
    mv a1, sp         # Start of the buffer on the stack
    li a2, 2          # Length of the buffer, 2 bytes for the character and the newline

    ecall             # Make the system call to write to stdout

    # Deallocate the buffer from the stack
    addi sp, sp, 2    # Move the stack pointer back to 0

    # Exit the program
    li a7, 93         # The system call for exit in RISC-V Linux
    li a0, 0          # Exit status code
    ecall             # Make the system call to exit
