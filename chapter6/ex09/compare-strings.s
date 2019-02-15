#PURPOSE:   This function compares two strings. The ending white space characters are ignored.
#
#INPUT:     Two zero terminated buffers of which contents will be compared to each other.
#
#OUTPUT:    This function returns 0 if the two buffers contain exactly the same bytes.
#                                 <0 if the first buffer is alphabetically smaller than the second one.
#                                 >0 if the second buffer is alphabetically smaller than the first one.
#
#NOTE:      If there are white space characters at the end of any of the buffers, they are ignored and treated as a closing byte.

#STACK LOCAL VARIABLES
.equ ST_BUF1, 12
.equ ST_BUF2, 8
.section .text
.globl compare_strings
.type compare_strings, @function
compare_strings:
pushl %ebp
movl  %esp, %ebp

#The initial values are set to 0
movl  $0, %ecx
movl  $0, %edx
movl  $0, %edi

movl  ST_BUF1(%ebp), %eax
movl  ST_BUF2(%ebp), %ebx

cmp_loop:
movb  (%eax), %cl
movb  (%ebx), %dl
incl  %eax
incl  %ebx
cmpb  $10, %cl
je    cmp_exit
cmpb  $10, %dl
je    cmp_exit
cmpb  $0, %cl
je    cmp_exit
cmpb  $0, %dl
je    cmp_exit
movl  %ecx, %edi
subl  %edx, %edi
cmpl  $0, %edi
je    cmp_loop

cmp_exit:
movl  %edi, %eax
movl  %ebp, %esp
popl  %ebp
ret
