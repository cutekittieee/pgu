.include "linux.s"

#PURPOSE:  This function reads up to 32 binary characters from the keyboard.
#
#INPUT:    A 4 byte buffer to store the value entered by the user.
#          The input string is converted to an unsigned integer (32 bits).
#
#OUTPUT:   This function returns 0 on successful completion,
#          or -1 on error.

.section .bss
#Allowed length of the input: 32 binary characters and a terminating newline
.equ MAX_SIZE, 33

#Stack position for the parameter of the function
#The buffer is to be used to store the result
.equ ST_BUFFER, 8

#Buffer for the user input
.lcomm input_str, MAX_SIZE

.section .text
.globl read_32chars
.type read_32chars, @function
read_32chars:
pushl %ebp
movl  %esp, %ebp

#Total number of bytes read
movl  $0, %edi

read_loop:
movl  $STDIN, %ebx
movl  $input_str, %ecx
movl  $MAX_SIZE, %edx
movl  $SYS_READ, %eax
addl  %edi, %ecx
subl  %edi, %edx

#We have already read 32 characters, so we are finished
cmpl  $0, %edx
je    finish_read

#Check for possible errors
cmpl  $0, %edx
jl    exit_err

pushl %edi
int   $LINUX_SYSCALL
popl  %edi
cmpl  $0, %eax
je    finish_read
cmpl  $0, %eax
jl    exit_err
addl  %eax, %edi
jmp   read_loop

finish_read:
movl  $input_str, %ecx

#Check whether the user entered all the 32 binary characters or not
cmpl  $MAX_SIZE, %edi
jne   exit_err

#Set the newline position at the end of the buffer
addl  %edi, %ecx
decl  %ecx

#If its not a newline character, an error is returned
cmpb  $10, (%ecx)
jne   exit_err

#Convert the binary string to an unsigned integer
movl  $input_str, %ebx
# %eax: The converted number
movl  $0, %eax
convert_str:
movb  (%ebx), %dl
cmpb  $10, %dl
je    convert_fin
cmpb  $48, %dl
jl    exit_err
cmpb  $49, %dl
jg    exit_err
shll  $1, %eax
subb  $48, %dl
orb   %dl, %al
incl  %ebx
jmp   convert_str

convert_fin:
#The number is stored in the parameter
movl  ST_BUFFER(%ebp), %ebx
movl  %eax, (%ebx)

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
