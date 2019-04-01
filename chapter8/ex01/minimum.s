#PURPOSE:  This program finds the minimum number of a
#          set of data items.
#
#VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Smallest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data.  A 0 is used
#              to terminate the data.
#              All valid numbers are positive integers.
#

.section .data

data_items:                    # These are the data items
.long 3,67,34,222,45,75,54,2,34,44,33,22,11,66,0
resultstring:
.ascii "%d\n\0"

.section .text

.globl _start
_start:
movl $0, %edi                  # move 0 into the index register
movl data_items(,%edi,4), %eax # load the first byte of data
movl %eax, %ebx                # since this is the first item, %eax is
                               # the smallest
cmpl $0, %eax                  # check for an empty list
je loop_exit

start_loop:                    # start loop
incl %edi                      # load next value
movl data_items(,%edi,4), %eax
cmpl $0, %eax                  # check to see if we've hit the end
je loop_exit                   #
cmpl %ebx, %eax                # compare values
jge start_loop                 # jump to loop beginning if the new
                               # one isn't smaller
movl %eax, %ebx                # move the value as the smallest
jmp start_loop                 # jump to loop beginning

loop_exit:
#Print the minimum value
pushl %ebx
pushl $resultstring
call  printf
addl  $8, %esp

#Exit the program with status code 0
pushl $0
call  exit
addl  $4, %esp
