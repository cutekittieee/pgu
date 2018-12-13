#PURPOSE - Given a number, this program computes the
#          factorial.  For example, the factorial of
#          3 is 3 * 2 * 1, or 6.  The factorial of
#          4 is 4 * 3 * 2 * 1, or 24. The factorial of
#          5 is 5 * 4 * 3 * 2 * 1, or 120, and so on.
#
# This program shows how to call a function recursively.
# This program uses an alternative calling convention.

.section .data

retval:              # contains the return value (0 by default)
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
#The only parameter is passed in %eax
.type factorial,@function
factorial:
pushl %eax           #we save %eax because every invocation needs its own value to work properly
pushl %ebp           #standard function stuff - we have to
                     #restore %ebp to its prior state before
                     #returning, so we have to push it
movl  %esp, %ebp     #This is because we don't want to modify
                     #the stack pointer, so we use %ebp.
cmpl  $0, retval     #if retval equals to 0, we set it to 1
jne fact_start       #0! = 1 by definition,
movl  $1, retval     #so it should be the initial value

fact_start:
cmpl  $1, %eax       #If the number is 1, that is our base
                     #case, and we simply return (1 is
                     #already in retval as the return value)
je end_factorial
decl  %eax           #otherwise, decrease the value in %eax
call  factorial      #call factorial recursively
movl  retval, %ebx   #retval has the return value, so we
                     #reload it into %ebx
incl  %eax           #this was the original parameter of the function
imull %ebx, %eax     #multiply that by the result of the
                     #last call to factorial (in retval)
                     #the answer is stored in %eax
movl  %eax, retval   #we move the return value into retval

end_factorial:
movl  %ebp, %esp     #standard function return stuff - we
popl  %ebp           #have to restore %ebp and %esp to where
popl  %eax           #they were before the function started
ret                  #return from the function (this pops the
                     #return value, too)
