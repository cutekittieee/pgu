.include "linux.s"

#PURPOSE - This program computes the sum of the first 10000 numbers.

.section .data

tmp_buffer:
.ascii "\0\0\0\0\0\0\0\0\0\0\0"

msg_begin:
.ascii "The sum is: "

.section .text
.globl _start
_start:
#Write the initial text to STDOUT
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  $msg_begin, %ecx
movl  $12, %edx
int   $LINUX_SYSCALL

#The number
movl  $10000, %ecx
#The current sum
movl  $0, %ebx

main_loop:
addl  %ecx, %ebx
decl  %ecx
cmpl  $0, %ecx
jne   main_loop

#Storage for the result
pushl $tmp_buffer
#Number to convert
pushl %ebx
call  integer2string
addl  $8, %esp

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

movl  $SYS_EXIT, %eax #call the kernel's exit function
movl  $0, %ebx        #we return 0
int   $LINUX_SYSCALL
