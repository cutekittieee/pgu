#PURPOSE:  Program to illustrate how functions work
#          This program will compute the value of
#          2^2 + 5^2 = 29 (return value to Linux)
#          The program implements and illustrates the square function.
#
#Everything in the main program is stored in registers,
#so the data section doesn't have anything.
.section .data

.section .text

.globl _start
_start:
pushl $2                   #push first argument
call  square               #call the function
addl  $4, %esp             #move the stack pointer back

pushl %eax                 #save the first answer before
                           #calling the next function
pushl $5                   #push first argument
call  square               #call the function
addl  $4, %esp             #move the stack pointer back

popl   %ebx                #The second answer is already
                           #in %eax. We saved the
                           #first answer onto the stack,
                           #so now we can just pop it
                           #out into %ebx

addl   %eax, %ebx          #add them together
                           #the result is in %ebx

movl   $1, %eax            #exit (%ebx is returned)
int    $0x80

#PURPOSE:   This function is used to compute
#           the square of a number.
#
#INPUT:     First argument - the number to compute the square of.
#
#OUTPUT:    Will give the result as a return value
#
#VARIABLES:
#           %eax is used for storing the return value.
#
.type square, @function
square:
pushl %ebp             #save old base pointer
movl  %esp, %ebp       #make stack pointer the base pointer

movl  8(%ebp), %eax    #put first argument in %eax
imull %eax, %eax       #multiply the current result by
                       #itself
                       #the return value stays in eax

movl %ebp, %esp        #restore the stack pointer
popl %ebp              #restore the base pointer
ret
