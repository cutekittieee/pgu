.include "linux.s"
.include "record-def.s"

.section .data

#This is the name of the file we will write to
#If it already exists, the record is appended to the end of the file
file_name:
.ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
.equ ST_FILE_DESCRIPTOR, -4
.globl _start
_start:
#Copy the stack pointer to %ebp
movl %esp, %ebp
#Allocate space to hold the file descriptor
subl $4, %esp

#Open the file
movl  $SYS_OPEN, %eax
movl  $file_name, %ebx
movl  $02101, %ecx #This says to create if it
                   #doesn't exist, and open for
                   #writing
movl  $0666, %edx
int   $LINUX_SYSCALL
cmpl  $0, %eax
jl    exit_err

#Store the file descriptor away
movl  %eax, ST_FILE_DESCRIPTOR(%ebp)

#Read a record from the keyboard
pushl $record_buffer
call  read_record
addl  $4, %esp
cmpl  $0, %eax
jl    exit_err

#Write the record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record_buffer
call  write_record
addl  $8, %esp

#Close the file descriptor
movl  $SYS_CLOSE, %eax
movl  ST_FILE_DESCRIPTOR(%ebp), %ebx
int   $LINUX_SYSCALL
cmpl  $0, %eax
jl    exit_err

#Exit the program
movl  $SYS_EXIT, %eax
movl  $0, %ebx
int   $LINUX_SYSCALL

exit_err:
movl  %eax, %ebx
movl  $SYS_EXIT, %eax
int   $LINUX_SYSCALL
