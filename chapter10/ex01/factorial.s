.include "linux.s"

#PURPOSE - Given a number, this program computes the
#          factorial.  For example, the factorial of
#          3 is 3 * 2 * 1, or 6.  The factorial of
#          4 is 4 * 3 * 2 * 1, or 24, and so on.
#

#This program shows how to call a function recursively.

.section .data

tmp_buffer:
.ascii "\0\0\0\0\0\0\0\0\0\0\0"

.section .text

.globl _start
.globl factorial     #this is unneeded unless we want to share
                     #this function among other programs
_start:
pushl $4             #The factorial takes one argument - the
                     #number we want a factorial of.  So, it
                     #gets pushed
call  factorial      #run the factorial function
addl  $4, %esp       #Scrubs the parameter that was pushed on
                     #the stack
movl  %eax, %ebx     #factorial returns the answer in %eax, but
                     #we want it in %ebx to send it as our exit
                     #status (written to STDOUT)

#Storage for the result
pushl $tmp_buffer
#Number to convert
pushl %ebx
call  integer2string
addl  $8, %esp

#Get the character count for our system call
pushl $tmp_buffer
call  count_chars
addl  $4, %esp

#The count goes in %edx for SYS_WRITE
movl  %eax, %edx

#Make the system call
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  $tmp_buffer, %ecx
int   $LINUX_SYSCALL

#Write a carriage return
pushl $STDOUT
call  write_newline
addl  $4, %esp

#Exit
movl  $SYS_EXIT, %eax
movl  $0, %ebx
int   $LINUX_SYSCALL

#This is the actual function definition
.type factorial,@function
factorial:
pushl %ebp           #standard function stuff - we have to
                     #restore %ebp to its prior state before
                     #returning, so we have to push it
movl  %esp, %ebp     #This is because we don't want to modify
                     #the stack pointer, so we use %ebp.

movl  8(%ebp), %eax  #This moves the first argument to %eax
                     #4(%ebp) holds the return address, and
                     #8(%ebp) holds the first parameter
cmpl  $1, %eax       #If the number is 1, that is our base
                     #case, and we simply return (1 is
                     #already in %eax as the return value)
je end_factorial
decl  %eax           #otherwise, decrease the value
pushl %eax           #push it for our call to factorial
call  factorial      #call factorial
movl  8(%ebp), %ebx  #%eax has the return value, so we
                     #reload our parameter into %ebx
imull %ebx, %eax     #multiply that by the result of the
                     #last call to factorial (in %eax)
                     #the answer is stored in %eax, which
                     #is good since that's where return
                     #values go.
end_factorial:
movl  %ebp, %esp     #standard function return stuff - we
popl  %ebp           #have to restore %ebp and %esp to where
                     #they were before the function started
ret                  #return from the function (this pops the
                     #return value, too)
