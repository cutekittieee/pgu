.include "linux.s"

#PURPOSE:  This program finds the maximum number of a
#          set of data items.
#
#VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data.  A 0 is used
#              to terminate the data
#

.section .data

data_items:                    # These are the data items
.long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
tmp_buffer:
.ascii "\0\0\0\0\0\0\0\0\0\0\0"

.section .text

.globl _start
_start:
movl $0, %edi                  # move 0 into the index register
movl data_items(,%edi,4), %eax # load the first byte of data
movl %eax, %ebx                # since this is the first item, %eax is
                               # the biggest

start_loop:                    # start loop
cmpl $0, %eax                  # check to see if we've hit the end
je loop_exit
incl %edi                      # load next value
movl data_items(,%edi,4), %eax
cmpl %ebx, %eax                # compare values
jle start_loop                 # jump to loop beginning if the new
                               # one isn't bigger
movl %eax, %ebx                # move the value as the largest
jmp start_loop                 # jump to loop beginning

loop_exit:
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
