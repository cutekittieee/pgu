.include "linux.s"

.section .data

#This is where it will be stored
tmp_buffer:
.ascii "\0\0\0\0\0\0\0\0\0\0\0"
.section .text

.globl _start
_start:
movl  %esp, %ebp

#Storage for the result
pushl $tmp_buffer
#Number to convert
pushl $824
#Base for the conversion
pushl $55
call  integer2string
addl  $12, %esp
cmpl  $0, %eax
jne   out_err

#Get the character count for our system call
pushl $tmp_buffer
call  count_chars
addl  $4, %esp

#The count goes in %edx for SYS_WRITE
movl  %eax, %edx

#Make the system call
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  $tmp_buffer, %ecx
int   $LINUX_SYSCALL

#Write a carriage return
pushl $STDOUT
call  write_newline
addl  $4, %esp

#Exit
movl  $SYS_EXIT, %eax
movl  $0, %ebx
int   $LINUX_SYSCALL

#Error (1 is returned)
out_err:
movl  $SYS_EXIT, %eax
movl  $1, %ebx
int   $LINUX_SYSCALL
