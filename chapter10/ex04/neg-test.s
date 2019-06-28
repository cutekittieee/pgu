.include "linux.s"

#PURPOSE:   Tests the is_negative function
#           Writes a message to STDOUT:
#             txt_positive, if the number is positive
#             txt_negative, if the number is negative

.section .data
txt_positive:
.ascii "The number is positive.\n\0"

txt_negative:
.ascii "The number is negative.\n\0"

.section .text
.globl _start
_start:
pushl $-1213232
call  is_negative
addl  $4, %esp

cmpl  $1, %eax
je    negative
movl  $txt_positive, %ecx
jmp   print_res

negative:
movl  $txt_negative, %ecx

#Write a message to STDOUT
print_res:
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  $25, %edx
int   $LINUX_SYSCALL

#Exit
movl  $SYS_EXIT, %eax
movl  $0, %ebx
int   $LINUX_SYSCALL
