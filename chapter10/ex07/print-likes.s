.include "linux.s"

#PURPOSE:  This function prints a list of properties based on the input variable.
#
#INPUT:    A 4 byte unsigned integer. It is interpreted as a set of bits, where 0 refers to 'no' and 1 refers to 'yes'.
#
#OUTPUT:   This function returns -1 on error, and 0 on successful compeltion.

.section .data
str_begin:
.ascii "Common likes: "

newline:
.ascii "\n"

sep:
.ascii ", "

ssv:
.ascii "cats dogs cars mountains oceans movies parties stars sports science books nature flowers music dancing shopping cooking photography skiing surfing fishing arts yoga cycling flying jewelry painting drawing swimming snakes rabbits fish "

#Stack position for the parameter of the function
.equ ST_BITS, 8

.section .text
.globl print_likes
.type print_likes, @function
print_likes:
pushl %ebp
movl  %esp, %ebp

movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  $str_begin, %ecx
movl  $14, %edx
int   $LINUX_SYSCALL

movl  $ssv, %esi
movl  $0x80000000, %edx

main_loop:
movl  ST_BITS(%ebp), %eax
movl  %esi, %ecx
movl  $0, %edi

print_loop:
incl  %ecx
incl  %edi
cmpb  $32, (%ecx)
jne   print_loop
andl  %edx, %eax
cmpl  $0, %eax
je    skip_str
#Print the characters to STDOUT
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  %esi, %ecx
pushl %edx
movl  %edi, %edx
int   $LINUX_SYSCALL
cmpl  $0, %eax
jl    exit_err
popl  %edx

skip_str:
addl  %edi, %esi
shrl  $1, %edx
cmpl  $0, %edx
jne   main_loop

movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  $newline, %ecx
movl  $1, %edx
int   $LINUX_SYSCALL

exit_ok:
#Exit without errors, 0 is returned
movl  $0, %eax
movl  %ebp, %esp
popl  %ebp
ret

#On error, we return -1
exit_err:
movl  $-1, %eax
movl  %ebp, %esp
popl  %ebp
ret
