.include "linux.s"
.include "record-def.s"

#PURPOSE:   This function reads a record from the keyboard.
#           The fields are separated using a newline character.
#           Fields which are too long are truncated to match the allowed length.
#           Fields which are too short are padded with zero bytes to match the allowed length.
#           The age field is converted from ASCII characters to a 4-byte integer.
#           The input (record) is terminated with a 0 byte on the terminal.
#
#INPUT:     A buffer to store the record.
#
#OUTPUT:    This function writes the data to the buffer
#           and returns the number of bytes succesfully read, or -1 in case of an error.

#Maximum allowed length of the input from the keyboard
.equ MAX_LEN, 1024

#The byte at position MAX_LEN+1 will be forced to be 0 in case the user types more than MAX_LEN characters.
#This is because of error handling.

.section .bss
.lcomm record_in, MAX_LEN+1

#STACK LOCAL VARIABLES
.equ ST_READ_BUFFER, 8

.section .text
.globl read_record
.type read_record, @function
read_record:
pushl %ebp
movl  %esp, %ebp

#Count the number of bytes that have been read so far
movl  $0, %edi

#Read the data from the keyboard
read_loop:
movl  $MAX_LEN, %edx
subl  %edi, %edx
cmpl  $0, %edx
#If we have <= 0 free bytes in the buffer, we exit and return with an error code -1
jle   exit_readr_err
movl  $record_in, %ecx
addl  %edi, %ecx
movl  $SYS_READ, %eax
movl  $STDIN, %ebx
pushl %edi
int   $LINUX_SYSCALL
popl  %edi
cmpl  $0, %eax
jl    exit_readr_err
cmpl  $0, %eax
je    finish_read
addl  %eax, %edi
jmp   read_loop

finish_read:
#Zero the byte at position %edi so that the input will end with a zero byte
movl  $record_in, %ecx
addl  %edi, %ecx
movb  $0, (%ecx)

#Copy the input data to record_buffer (first parameter of the function)

#Here ecx counts the number of characters written to a given field of the record
copy_firstname:
movl  $0, %ecx
movl  $record_in, %eax
movl  ST_READ_BUFFER(%ebp), %ebx

process_firstname:
movb  (%eax), %dl
incl  %eax

#null indicates an error here
cmpb  $0, %dl
je    exit_readr_err

#newline indicates the end of the field
cmpb  $10, %dl
je    fill_first

movb  %dl, (%ebx)
incl  %ecx
incl  %ebx

#If the firstname is longer than LEN_FIRSTNAME bytes, it is truncated. If it is exactly LEN_FIRSTNAME bytes long, we do nothing.
cmpl  $LEN_FIRSTNAME, %ecx
je    trunc_firstname

#otherwise, continue processing
jmp process_firstname

#make sure we have LEN_FIRSTNAME bytes stored for the firstname
#If not, 0 bytes are appended
fill_first:
cmpl  $LEN_FIRSTNAME, %ecx
je    copy_lastname
movb  $0, (%ebx)
incl  %ebx
incl  %ecx
jmp   fill_first

trunc_firstname:
movb  (%eax), %dl
incl  %eax
cmpb  $0, %dl
je    exit_readr_err
cmpb  $10, %dl
jne   trunc_firstname

copy_lastname:
movl  $0, %ecx

process_lastname:
movb  (%eax), %dl
incl  %eax

#null indicates an error here
cmpb  $0, %dl
je    exit_readr_err

#newline indicates the end of the field
cmpb  $10, %dl
je    fill_last

movb  %dl, (%ebx)
incl  %ecx
incl  %ebx

#If the lastname is longer than LEN_LASTNAME bytes, it is truncated. If it is exactly LEN_LASTNAME bytes long, we do nothing.
cmpl  $LEN_FIRSTNAME, %ecx
je    trunc_lastname

#otherwise, continue processing
jmp process_lastname

#make sure we have LEN_FIRSTNAME bytes stored for the lastname
#If not, 0 bytes are appended
fill_last:
cmpl  $LEN_FIRSTNAME, %ecx
je    copy_address
movb  $0, (%ebx)
incl  %ebx
incl  %ecx
jmp   fill_last

trunc_lastname:
movb  (%eax), %dl
incl  %eax
cmpb  $0, %dl
je    exit_readr_err
cmpb  $10, %dl
jne   trunc_lastname

copy_address:
movl  $0, %ecx

process_address:
movb  (%eax), %dl
incl  %eax

#null indicates an error here
cmpb  $0, %dl
je    exit_readr_err

#newline indicates the end of the field
cmpb  $10, %dl
je    fill_addr

movb  %dl, (%ebx)
incl  %ecx
incl  %ebx

#If the address is longer than LEN_ADDRESS bytes, it is truncated. If it is exactly LEN_ADDRESS bytes long, we do nothing.
cmpl  $LEN_ADDRESS, %ecx
je    trunc_addr

#otherwise, continue processing
jmp process_address

#make sure we have LEN_ADDRESS bytes stored for the address
#If not, 0 bytes are appended
fill_addr:
cmpl  $LEN_ADDRESS, %ecx
je    copy_age
movb  $0, (%ebx)
incl  %ebx
incl  %ecx
jmp   fill_addr

trunc_addr:
movb  (%eax), %dl
incl  %eax
cmpb  $0, %dl
je    exit_readr_err
cmpb  $10, %dl
jne   trunc_addr

#Here ecx is used to store the 4-byte age (default: 0), we count nothing
copy_age:
movl  $0, %ecx

process_age:
movl  $0, %edx
movb  (%eax), %dl
incl  %eax

#null indicates the end of the field
cmpb  $0, %dl
je    finish_copy_age

#newline indicates the end of the field
cmpb  $10, %dl
je    finish_copy_age

#If less than 48, not a number
cmpb  $48, %dl
jl    exit_readr_err

#If greater than 57, not a number
cmpb  $57, %dl
jg    exit_readr_err

#The ASCII character is converted to the actual number
subl  $48, %edx

#ecx = ecx*10+edx
imull $10, %ecx
addl  %edx, %ecx

#continue processing
jmp process_age

finish_copy_age:
movl  %ecx, (%ebx)

#NOTE - %edi has the summarized return value of the SYS_READ calls, which we will
#       give back to our calling program in case of a normal execution.

exit_readr:
movl  %edi, %eax
movl  %ebp, %esp
popl  %ebp
ret

#On error, -1 is returned
exit_readr_err:
movl  $1, %eax
negl  %eax
movl  %ebp, %esp
popl  %ebp
ret
