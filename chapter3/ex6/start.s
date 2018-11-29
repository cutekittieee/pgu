#PURPOSE:  Simple program that exits and returns a
#          status code back to the Linux kernel
#

#INPUT:    none
#

#OUTPUT:   returns a status code. This can be viewed
#          by typing
#
#          echo $?
#
#          after running the program
#

#VARIABLES:
#          %eax holds the system call number
#          %ebx holds the return status
#
.section .data

.section .text
.globl _start
_start:
movl _start, %eax     # the data at the memory address of _start (the actual instruction) is loaded into eax (use a debugger to see what happens, this is direct addressing)
movl $_start, %eax    # the memory address of _start (the address of the first instruction after the symbol) is loaded into eax (use a debugger to see what happens, this is immediate addressing)
movl $1, %eax         # this is the linux kernel command
                      # number (system call) for exiting
                      # a program

movl $0, %ebx         # this is the status number we will
                      # return to the operating system.
                      # Change this around and it will
                      # return different things to
                      # echo $?

int $0x80             # this wakes up the kernel to run
                      # the exit command

