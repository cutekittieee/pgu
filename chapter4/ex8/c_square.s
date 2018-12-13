#PURPOSE:  Program to illustrate how functions work
#          This program will compute the value of
#          2^2 + 5^2 = 29 (return value to Linux)
#          The program implements and illustrates the square function.
#
# Memory locations:
#       - retval: used to store the return value
#
# This program uses an alternative calling convention

.section .data
retval:                    # return value of the function (0 by default)
.long 0

.section .text

.globl _start
_start:
movl $2, %eax              #store first argument
call  square               #call the function
pushl retval               #save the first answer before calling the function again

movl $5, %eax              #store first argument
call  square               #call the function
popl   %ebx                #The second answer is already
                           #in retval. We saved the
                           #first answer onto the stack,
                           #so now we can just pop it
                           #out into %ebx

addl   retval, %ebx        #add them together
                           #the result is in %ebx

movl   $1, %eax            #exit (%ebx is returned)
int    $0x80

#PURPOSE:   This function is used to compute
#           the square of a number.
#
#INPUT:     First argument - the number to compute the square of (%eax).
#
#OUTPUT:    Will give the result as a return value (retval)

.type square, @function
square:
pushl %ebp             #save old base pointer
movl  %esp, %ebp       #make stack pointer the base pointer
imull %eax, %eax       #multiply the current result by
                       #itself
movl %eax, retval      #the return value goes into retval
movl %ebp, %esp        #restore the stack pointer
popl %ebp              #restore the base pointer
ret
