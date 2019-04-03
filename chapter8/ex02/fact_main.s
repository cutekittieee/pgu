#PURPOSE - Given a number, this program computes the
#          factorial.  For example, the factorial of
#          3 is 3 * 2 * 1, or 6.  The factorial of
#          4 is 4 * 3 * 2 * 1, or 24, and so on.
#

#This program shows how to call a function recursively.

.section .data

#This program has no global data

.section .text

.globl _start
_start:
pushl $4             #The factorial takes one argument - the
                     #number we want a factorial of.  So, it
                     #gets pushed
call  factorial      #run the factorial function
addl  $4, %esp       #Scrubs the parameter that was pushed on
                     #the stack
movl  %eax, %ebx     #factorial returns the answer in %eax, but
                     #we want it in %ebx to send it as our exit
                     #status
movl  $1, %eax       #call the kernel's exit function
int   $0x80
