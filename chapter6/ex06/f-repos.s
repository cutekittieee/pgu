.include "record-def.s"
.include "linux.s"

#PURPOSE:  This function uses the lseek system call
#          to reposition the file offset to the beginning of the actual record.
#
#INPUT:    The file descriptor to be repositioned.
#
#OUTPUT:   This function returns the value returned by the lseek system call.

#STACK LOCAL VARIABLES
.equ ST_FILEDES, 8
.section .text
.globl f_repos
.type f_repos, @function
f_repos:
pushl %ebp
movl  %esp, %ebp

movl  ST_FILEDES(%ebp), %ebx
movl  $-RECORD_SIZE, %ecx
movl  $1, %edx
movl  $SYS_LSEEK, %eax
int   $LINUX_SYSCALL

#NOTE - %eax has the return value, which we will
#       give back to our calling program

movl  %ebp, %esp
popl  %ebp
ret
