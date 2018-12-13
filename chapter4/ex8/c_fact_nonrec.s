#PURPOSE - Given a number, this program computes the
#          factorial.  For example, the factorial of
#          3 is 3 * 2 * 1, or 6.  The factorial of
#          4 is 4 * 3 * 2 * 1, or 24. The factorial of
#          5 is 5 * 4 * 3 * 2 * 1, or 120, and so on.
#
# Memory locations:
#        retval - used to store the return value of the function (0 by default)
#
# This program implements the factorial function non-recursively.
# This program uses an alternative calling convention.

.section .data

retval:                         # return value
.long 0

.section .text

.globl _start
.globl factorial     #this is unneeded unless we want to share
                     #this function among other programs
_start:
movl $5, %eax        #The factorial takes one argument - the
                     #number we want a factorial of.  So, it
                     #gets stored in %eax
call  factorial      #run the factorial function
movl  retval, %ebx   #factorial returns the answer in retval, but
                     #we want it in %ebx to send it as our exit
                     #status
movl  $1, %eax       #call the kernel's exit function
int   $0x80


#This is the actual function definition
.type factorial,@function
factorial:
pushl %ebp           #standard function stuff - we have to
                     #restore %ebp to its prior state before
                     #returning, so we have to push it
movl  %esp, %ebp     #This is because we don't want to modify
                     #the stack pointer, so we use %ebp.

movl $1, %ebx        #%ebx holds the return value of the function temporarily

fact_loop:
cmpl  $1, %eax       #If the number is 1, that is our base
                     #case, and we simply return (1 is
                     #already in %ebx as the return value)
je end_factorial     #exit point of the loop
imull %eax, %ebx     #multiply %ebx by %eax, the result is stored in %ebx
decl  %eax           #decrease the value in %eax
jmp fact_loop        #go back to loop start.

end_factorial:
movl  %ebx, retval   #copy the return value to retval
movl  %ebp, %esp     #standard function return stuff - we
popl  %ebp           #have to restore %ebp and %esp to where
                     #they were before the function started
ret                  #return from the function (this pops the
                     #return value, too)
