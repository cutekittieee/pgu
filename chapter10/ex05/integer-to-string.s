#PURPOSE:  Convert an integer number to a string (base is a parameter)
#          for display
#
#INPUT:    (a) A buffer large enough to hold the largest
#          possible number
#          (b) An integer to convert
#          (c) Conversion base
#
#OUTPUT:   The buffer will be overwritten with the string representation
#
#RETURNS:  0, if the conversion is successful
#          1, if an error has occurred while the conversion
#
#Variables:
#
# %ecx will hold the count of characters processed
# %eax will hold the current value
# %edi will hold the base
#
.equ ST_BASE, 8
.equ ST_VALUE, 12
.equ ST_BUFFER, 16

.globl integer2string
.type integer2string, @function
integer2string:
#Normal function beginning
pushl %ebp
movl  %esp, %ebp
#Current character count
movl  $0, %ecx

#Move the value into position
movl  ST_VALUE(%ebp), %eax

#When we divide by the base, it
#must be in a register or memory location
movl  ST_BASE(%ebp), %edi

#There are a few sanity checks.

#Base cannot be smaller than 2
cmpl  $2, %edi
jl    return_err

#Base cannot be higher than 62
cmpl  $62, %edi
jg    return_err

conversion_loop:
#Division is actually performed on the
#combined %edx:%eax register, so first
#clear out %edx
movl  $0, %edx

#Divide %edx:%eax (which are implied) by the base.
#Store the quotient in %eax and the remainder
#in %edx (both of which are implied).
divl  %edi

#Quotient is in the right place.  %edx has
#the remainder, which now needs to be converted
#into a number.  So, %edx has a number that is
#0 through {base-1}.  You could also interpret this as
#an index on the ASCII table starting from the
#character '0'.  The ascii code for '0' plus zero
#is still the ascii code for '0'.  The ascii code
#for '0' plus 1 is the ascii code for the
#character '1'.  Therefore, the following
#instructions will give us the character for the
#number stored in %edx.

#Remainder is between 0..9
cmpl  $9, %edx
jg    upcase
addl  $'0', %edx
jmp   conv_done

#Remainder is between 10..35
upcase:
cmpl  $35, %edx
jg    lowcase
addl  $'A', %edx
subl  $10, %edx
jmp   conv_done

#Remainder is between 36..61
lowcase:
addl  $'a', %edx
subl  $36, %edx

#Now we will take this value and push it on the
#stack.  This way, when we are done, we can just
#pop off the characters one-by-one and they will
#be in the right order.  Note that we are pushing
#the whole register, but we only need the byte
#in %dl (the last byte of the %edx register) for
#the character.
conv_done:
pushl %edx

#Increment the digit count
incl  %ecx

#Check to see if %eax is zero yet, go to next
#step if so.
cmpl  $0, %eax
je    end_conversion_loop

#%eax already has its new value.

jmp conversion_loop

end_conversion_loop:
#The string is now on the stack, if we pop it
#off a character at a time we can copy it into
#the buffer and be done.

#Get the pointer to the buffer in %edx
movl ST_BUFFER(%ebp), %edx

copy_reversing_loop:
#We pushed a whole register, but we only need
#the last byte.  So we are going to pop off to
#the entire %eax register, but then only move the
#small part (%al) into the character string.
popl  %eax
movb  %al, (%edx)
#Decreasing %ecx so we know when we are finished
decl  %ecx
#Increasing %edx so that it will be pointing to
#the next byte
incl  %edx

#Check to see if we are finished
cmpl  $0, %ecx
#If so, jump to the end of the function
je    end_copy_reversing_loop
#Otherwise, repeat the loop
jmp   copy_reversing_loop

end_copy_reversing_loop:
#Done copying.  Now write a null byte and return
movb  $0, (%edx)

#0 is returned on success
movl  $0, %eax
jmp return_ok

#1 is returned on error
return_err:
movl  $1, %eax

return_ok:
movl  %ebp, %esp
popl  %ebp
ret
