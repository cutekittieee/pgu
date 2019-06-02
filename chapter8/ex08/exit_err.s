.include "linux.s"

#PURPOSE:   This routine calls the SYS_EXIT system call,
#           to demonstrate the use of LD_PRELOAD.
#
#NOTES:     This code is used to build a shared library.
#
#PARAMETER: The only parameter is the exit status.

.section .data
exit_text:
.ascii "exit was called.\n\0"

.section .text

#Position of the parameter
.equ ST_STATUS, 4

.globl exit
.type exit, @function
exit:
#Write a message to STDERR
movl $SYS_WRITE, %eax
movl $STDERR, %ebx
movl $exit_text, %ecx
movl $18, %edx
int  $LINUX_SYSCALL

#Invoke the exit system call
movl $SYS_EXIT, %eax
movl ST_STATUS(%esp), %ebx
int  $LINUX_SYSCALL
ret
