#PURPOSE:  Count the characters until either a null byte or the maximum length of the field is reached.
#          This check is necessary because there is no guarantee that any of the fields are zero-terminated.
#
#INPUT:    The address of the character string and its maximum length.
#
#OUTPUT:   Returns the count in %eax
#
#PROCESS:
#  Registers used:
#    %ebx - maximum length of the field
#    %ecx - character count
#    %al - current character
#    %edx - current character address

.type count_chars, @function
.globl count_chars

#Parameter offsets on the stack
.equ ST_STRING_START_ADDRESS, 12
.equ ST_STRING_MAXLEN, 8
count_chars:
pushl %ebp
movl  %esp, %ebp

#Counter starts at zero
movl  $0, %ecx
#Starting address and max length of data
movl  ST_STRING_START_ADDRESS(%ebp), %edx
movl  ST_STRING_MAXLEN(%ebp), %ebx

count_loop_begin:
#Grab the current character
movb  (%edx), %al
#Is it null?
cmpb  $0, %al
#If yes, we're done
je    count_loop_end
#Otherwise, increment the counter and the pointer
incl  %ecx
incl  %edx
#did we reach the maximum length?
cmpl  %ebx, %ecx
#If yes, we are done
je    count_loop_end
#Go back to the beginning of the loop
jmp   count_loop_begin

count_loop_end:
#We're done.  Move the count into %eax
#and return.
movl  %ecx, %eax

popl  %ebp
ret
