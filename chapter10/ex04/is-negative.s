#PURPOSE:    Determine whether an integer number is negative or positive
#
#INPUT:      An integer number
#
#OUTPUT:     0, if the number is positive
#            1, if the number is negative

#Stack position for the parameter
.equ ST_VALUE, 8

.globl is_negative
.type is_negative, @function
is_negative:
pushl %ebp
movl  %esp, %ebp

movl  ST_VALUE(%ebp), %eax
#The sign bit will be the LSB
roll  $1, %eax
#1, if negative
#0, if positive
andl $0b00000000000000000000000000000001, %eax

movl  %ebp, %esp
popl  %ebp
ret
