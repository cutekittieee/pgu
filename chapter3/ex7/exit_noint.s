#PURPOSE:  Simple program that never returns (it does not contain the interrupt call to the linux kernel)
#          The exit.s code was modified by removing the int instruction

#INPUT:    none

#OUTPUT:   Segmentation fault

#VARIABLES:
#          %eax holds the system call number
#          %ebx holds the return status
#
.section .data

.section .text
.globl _start
_start:
movl $1, %eax   # this is the linux kernel command
                # number (system call) for exiting
                # a program

movl $0, %ebx   # this is the status number we will
                # return to the operating system.
                # Change this around and it will
                # return different things to
                # echo $?
