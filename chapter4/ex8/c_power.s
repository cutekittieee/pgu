#PURPOSE:  Program to illustrate how functions work
#          This program will compute the value of
#          2^3 + 5^2
#
# Memory locations used:
#        retval - stores the return value
#
# This program uses an alternative calling convention.

.section .data
retval:                    # return value of the function (0 by default)
.long 0

.section .text

.globl _start
_start:
movl $2, %eax              #store first argument
movl $3, %ebx              #store second argument
call  power                #call the function

pushl retval               #save the first answer before
                           #calling the next function
movl $5, %eax              #store first argument
movl $2, %ebx              #store second argument
call  power                #call the function

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
#           the value of a number raised to
#           a power.
#
#INPUT:     First argument  - the base number (%eax)
#           Second argument - the power to raise it to (%ebx)
#
#OUTPUT:    Will give the result as a return value (retval)
#
#NOTES:     The power must be 1 or greater
#
#VARIABLES:
#           %eax - holds the base number
#           %ebx - holds the power
#           %ecx - used for temporary storage
#
#           -4(%ebp) - holds the current result
#
.type power, @function
power:
pushl %ebp             #save old base pointer
movl  %esp, %ebp       #make stack pointer the base pointer
subl  $4, %esp         #get room for our local storage

movl  %eax, -4(%ebp)   #store current result

power_loop_start:
cmpl  $1, %ebx         #if the power is 1, we are done
je    end_power
movl  -4(%ebp), %ecx   #move the current result into %ecx
imull %eax, %ecx       #multiply the current result by
                       #the base number
movl  %ecx, -4(%ebp)   #store the current result

decl  %ebx             #decrease the power
jmp   power_loop_start #run for the next power

end_power:
movl -4 (%ebp), %eax   #return value goes into %eax
movl %eax, retval      #and is finally copied into retval

movl %ebp, %esp        #restore the stack pointer
popl %ebp              #restore the base pointer
ret
