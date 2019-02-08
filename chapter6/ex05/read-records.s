.include "linux.s"
.include "record-def.s"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
#Main program
.globl _start
_start:
#These are the locations on the stack where
#we will store the input and output descriptors
#(FYI - we could have used memory addresses in
#a .data section instead)
.equ ST_INPUT_DESCRIPTOR, -4
.equ ST_OUTPUT_DESCRIPTOR, -8

#Copy the stack pointer to %ebp
movl %esp, %ebp
#Allocate space to hold the file descriptors
subl $8,  %esp

#We expect either 2 or 3 parameters on the command line
#If 2 parameters are given, we use STDOUT to print the firstnames
#If 3 parameters are given, the last parameter is interpreted as the output filename instead of using STDOUT
#Param #1 is always the invocation text for the program
#Param #2 is the input filename

cmpl $2, (%ebp)
jl exit_err

cmpl $3, (%ebp)
jg exit_err

#Open the input file (first parameter on the command line)
movl  $SYS_OPEN, %eax
movl  8(%ebp), %ebx
movl  $0, %ecx    #This says to open read-only
movl  $0666, %edx
int   $LINUX_SYSCALL

movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)

#Open the output file (if it is not STDOUT) and save the file descriptor
cmpl $2, (%ebp)
je st_fdes

movl $SYS_OPEN, %eax
movl 12(%ebp), %ebx
movl $0101, %ecx
movl $0666, %edx
int  $LINUX_SYSCALL

movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)
jmp record_read_loop

st_fdes:
movl  $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
pushl ST_INPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call  read_record
addl  $8, %esp

#Returns the number of bytes read.
#If it isn't the same number we
#requested, then it's either an
#end-of-file, or an error, so we're
#quitting
cmpl  $RECORD_SIZE, %eax
jne   finished_reading

#Otherwise, print out the first name
#but first, we must know it's size
pushl  $RECORD_FIRSTNAME + record_buffer
call   count_chars
addl   $4, %esp
movl   %eax, %edx
movl   ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
movl   $SYS_WRITE, %eax
movl   $RECORD_FIRSTNAME + record_buffer, %ecx
int    $LINUX_SYSCALL

pushl  ST_OUTPUT_DESCRIPTOR(%ebp)
call   write_newline
addl   $4, %esp

jmp    record_read_loop

finished_reading:
movl   $SYS_EXIT, %eax
movl   $0, %ebx
int    $LINUX_SYSCALL

#Return -1 on error
exit_err:
movl $SYS_EXIT, %eax
movl $1, %ebx
negl %ebx
int  $LINUX_SYSCALL
