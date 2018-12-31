#PURPOSE:    This program creates a file called heynow.txt
#            and fills it with the string 'Hey diddle diddle!'
#
#PROCESSING: 1) Create the output file
#            2) Call the write syscall to write the buffer containing the string to the output file
#            3) Close the output file

.section .data

#######CONSTANTS########

#system call numbers
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

#options for open (look at
#/usr/include/asm/fcntl.h for
#various values.  You can combine them
#by adding them or ORing them)
#This is discussed at greater length
#in "Counting Like a Computer"
.equ O_CREAT_WRONLY_TRUNC, 03101

#system call interrupt
.equ LINUX_SYSCALL, 0x80

filename:       # The name of the output file
.ascii "heynow.txt\0"

filestr:        # The string written to the output file
.ascii "Hey diddle diddle!"


.section .bss
#Buffer - this is where the data is written from
#         into the output file.  This should
#         never exceed 16,000 for various
#         reasons.
#F_OUT  - the output file descriptor

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE
.lcomm F_OUT, 4

.section .text

.globl _start
_start:
###INITIALIZE PROGRAM###

open_fd_out:
###OPEN OUTPUT FILE###
#open the file
movl  $SYS_OPEN, %eax
#output filename into %ebx
movl  $filename, %ebx
#flags for writing to the file
movl  $O_CREAT_WRONLY_TRUNC, %ecx
#permission set for new file (if it's created)
movl  $0666, %edx
#call Linux
int   $LINUX_SYSCALL

store_fd_out:
#store the file descriptor here
movl  %eax, F_OUT

###WRITE THE STRING OUT TO THE OUTPUT FILE###
#size of the buffer
movl  $18, %edx

#write syscall
movl  $SYS_WRITE, %eax

#file to use
movl  F_OUT, %ebx

#location of the buffer
movl  $filestr, %ecx
int   $LINUX_SYSCALL

###CLOSE THE FILES###
#NOTE - we don't need to do error checking
#       on these, because error conditions
#       don't signify anything special here
movl  $SYS_CLOSE, %eax
movl  F_OUT, %ebx
int   $LINUX_SYSCALL

###EXIT###
movl  $SYS_EXIT, %eax
movl  $0, %ebx
int   $LINUX_SYSCALL
