#PURPOSE:  This program finds the maximum number of a
#          set of data items and returns the maximum found
#          in the last dataset.
#          The maximum values of the first two
#          datasets are ignored.
#
#VARIABLES: The registers have the following uses:
#
# %eax - Exit syscall number
# %ebx - Largest data item found
#
# The following memory locations are used:
#
# data_items1 - contains the item data. A 0 is used
#               to terminate the dataset.
#
# data_items2 - contains another set of data. A 0 is used
#               to terminate the dataset.
#
# data_items3 - contains another set of data. A 0 is used
#               to terminate the dataset.
#
# retval      - contains the return value of the function
#
# This program uses an alternative calling convention.

.section .data

data_items1:                   # These are the data items
.long 3,67,34,227,45,75,54,34,44,33,22,11,66,0
data_items2:                   # 2nd dataset
.long 1,2,3,4,5,2,3,4,1,3,4,2,5,7,0
data_items3:                   # 3rd dataset
.long 10,55,66,11,63,7,77,49,39,44,42,0
retval:                        # the return value (0 by default)
.long 0

.section .text

.globl _start
.globl maxi
_start:
movl $data_items1, %eax        # store the address of the 1st set in %eax
call maxi                      # find the maximum value

movl $data_items2, %eax        # store the address of the 2nd set in %eax
call maxi                      # find the maximum value

movl $data_items3, %eax        # store the address of the last set in %eax
call maxi                      # find the maximum value

movl retval, %ebx              # the maximum value should be put into %ebx instead of retval

# %ebx is the status code for the exit system call
# and it already has the maximum number
movl $1, %eax                  #1 is the exit() syscall
int  $0x80

# maxi: Function used to find the maximum value in a dataset terminated by the number 0.
#
# RETURNS: the maximum value in retval
#
# MODIFIES: %eax, %ebx, %ecx
#
#           %eax: holds a pointer to the data items in memory
#           %ebx: temporary storage for the actual data item

.type maxi,@function
maxi:
pushl %ebp
movl %esp, %ebp

movl (%eax), %ebx              # load the first byte of data
movl %ebx, retval              # since this is the first item, %ebx is
                               # the biggest

start_loop:                    # start loop
cmpl $0, %ebx                  # check to see if we've hit the end
je loop_exit                   # exit, if the number 0 was found
addl $4, %eax                  # increase %eax by 4 to point to the next item
movl (%eax), %ebx              # load the next item
cmpl %ebx, retval              # compare values
jge start_loop                 # jump to loop beginning if the new
                               # one isn't bigger
movl %ebx, retval              # move the value as the largest
jmp start_loop                 # jump to loop beginning

loop_exit:
movl %ebp, %esp
popl %ebp
ret
