#PURPOSE:  This program finds the maximum number of a
#          set of data items.
#
#VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
# %ecx - Number of items in the list (more precisely, how many items left to process)
#
# The following memory locations are used:
#
# data_items - contains the item data.
#              All numbers are positive integers.
#

.section .data

data_items:                    # These are the data items
.long 3,67,34,222,45,75,54,34,44,33,22,11,66

.section .text

.globl _start
_start:
movl $0, %edi                  # move 0 into the index register
movl $13, %ecx                 # the number of list items is stored in ecx
movl $0, %ebx                  # by default 0 is the biggest (for an empty list)

start_loop:                    # start loop
cmpl $0, %ecx                  # if we reached the end of the list, jump
je loop_exit
decl %ecx                      # decrement the counter of list items
movl data_items(,%edi,4), %eax # load next value
incl %edi                      # update the index register
cmpl %ebx, %eax                # compare values
jle start_loop                 # jump to loop beginning if the new
                               # one isn't bigger
movl %eax, %ebx                # move the value as the largest
jmp start_loop                 # jump to loop beginning

loop_exit:
# %ebx is the status code for the exit system call
# and it already has the maximum number
movl $1, %eax                  #1 is the exit() syscall
int  $0x80
