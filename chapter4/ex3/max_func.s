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
# data_items1 - contains the data items. A 0 is used
#               to terminate the dataset.
#
# data_items2 - contains another set of data. A 0 is used
#               to terminate the dataset.
#
# data_items3 - contains another set of data. A 0 is used
#               to terminate the dataset.

.section .data

data_items1:                    # These are the data items
.long 3,67,34,227,45,75,54,34,44,33,22,11,66,0
data_items2:                    # 2nd dataset
.long 1,2,3,4,5,2,3,4,1,3,4,2,5,7,0
data_items3:                    # 3rd dataset
.long 10,55,66,11,63,7,77,49,39,44,42,0

.section .text

.globl _start
.globl maxi
_start:
pushl $data_items1              # push the address of the 1st set onto the stack
call maxi                       # find the maximum value
addl $4, %esp                   # restore esp

pushl $data_items2              # push the address of the 2nd set onto the stack
call maxi                       # find the maximum value
addl $4, %esp                   # restore esp

pushl $data_items3              # push the address of the last set onto the stack
call maxi                       # find the maximum value
addl $4, %esp                   # restore esp

movl %eax, %ebx                 # the maximum value is saved in %ebx instead of %eax

# %ebx is the status code for the exit system call
# and it already has the maximum number
movl $1, %eax                  #1 is the exit() syscall
int  $0x80

# maxi: This function is used to find the maximum value in a dataset terminated by the number 0.
#
# RETURNS: the maximum value in %eax
#
# MODIFIES: %eax, %ebx, %ecx
#
#           %eax: used to store the actual largest value
#           %ebx: temporary storage for the actual data item
#           %ecx: holds a pointer to the data items in memory

.type maxi,@function
maxi:
pushl %ebp
movl %esp, %ebp

movl 8(%ebp), %ecx             # move the address of the data items (first parameter) into %ecx

movl (%ecx), %ebx              # load the first data item into %ebx
movl %ebx, %eax                # since this is the first item, %eax is
                               # the biggest

start_loop:                    # start loop
cmpl $0, %ebx                  # check to see if we've hit the end
je loop_exit                   # exit, if the number 0 was found
addl $4, %ecx                  # increase %ecx by 4 to point to the next item
movl (%ecx), %ebx              # load the next item
cmpl %ebx, %eax                # compare values
jge start_loop                 # jump to loop beginning if the new
                               # one isn't bigger
movl %ebx, %eax                # move the value as the largest
jmp start_loop                 # jump to loop beginning

loop_exit:

movl %ebp, %esp
popl %ebp
ret
