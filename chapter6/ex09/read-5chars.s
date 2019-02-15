.include "linux.s"

#PURPOSE:  This function reads up to 5 characters from the keyboard.
#
#INPUT:    A buffer to store the characters. (will be terminated with an extra zero byte at the end of the buffer)
#          The second parameter is the length of the buffer. (Minimum 6 characters with the zero included)
#
#OUTPUT:   This function returns 0 on successful execution or
#                                -1 on error.

#STACK LOCAL VARIABLES
.equ ST_READ_BUFFER, 12
.equ ST_READ_BUFLEN, 8
.section .text
.globl read_5chars
.type read_5chars, @function
read_5chars:
pushl %ebp
movl  %esp, %ebp

#Total number of bytes read
movl  $0, %edi

#If the buffer length is less than 6 characters, we exit.
#We assume that the buffer can store at least 6=5+1 (1 for zero) characters.
movl  ST_READ_BUFLEN(%ebp), %edx
cmpl  $6, %edx
jl    exit_err

read_loop:
movl  $STDIN, %ebx
movl  ST_READ_BUFFER(%ebp), %ecx
movl  $5, %edx
movl  $SYS_READ, %eax
addl  %edi, %ecx
subl  %edi, %edx
cmpl  $0, %edx
jle   finish_read
pushl %edi
int   $LINUX_SYSCALL
popl  %edi
cmpl  $0, %eax
je    finish_read
cmpl  $0, %eax
jl    exit_err
addl  %eax, %edi
jmp   read_loop

finish_read:
movl  ST_READ_BUFFER(%ebp), %ecx
movl  ST_READ_BUFLEN(%ebp), %edx

#The input is terminated by a zero
addl  %edi, %ecx
movb  $0, (%ecx)

#Exit without errors, 0 is returned
movl  $0, %eax
movl  %ebp, %esp
popl  %ebp
ret

#On error, we return -1
exit_err:
movl  $1, %eax
negl  %eax
movl  %ebp, %esp
popl  %ebp
ret
