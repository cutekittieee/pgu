.include "linux.s"
.include "record-def.s"

.section .data
file_name:
.ascii "test.dat\0"

error_read:
.ascii "Error while reading test.dat: \0"

error_writenl:
.ascii "Error while writing newline: \0"

error_writef:
.ascii "Error while writing firstname: \0"

error_open:
.ascii "Error while opening test.dat: \0"

error_readr:
.ascii "Error while reading record: \0"

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

#Open the file
movl  $SYS_OPEN, %eax
movl  $file_name, %ebx
movl  $0, %ecx    #This says to open read-only
movl  $0666, %edx
int   $LINUX_SYSCALL
cmpl  $0, %eax
jl    exit_err_open

#Save file descriptor

movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)

#Even though it's a constant, we are
#saving the output file descriptor in
#a local variable so that if we later
#decide that it isn't always going to
#be STDOUT, we can change it easily.
movl  $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
pushl ST_INPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call  read_record
addl  $8, %esp
cmpl  $0, %eax
jl    exit_err_readr

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
cmpl   $0, %eax
jl     exit_err_writef

pushl  ST_OUTPUT_DESCRIPTOR(%ebp)
call   write_newline
addl   $4, %esp
cmpl   $0, %eax
jl     exit_err_writenl

jmp    record_read_loop

finished_reading:
movl   $SYS_EXIT, %eax
movl   $0, %ebx
int    $LINUX_SYSCALL

exit_err_writenl:
pushl $error_writenl
pushl %eax
call  print_error
addl  $8, %esp
movl  %eax, %ebx
movl  $SYS_EXIT, %eax
int   $LINUX_SYSCALL

exit_err_read:
pushl $error_read
pushl %eax
call  print_error
addl  $8, %esp
movl  %eax, %ebx
movl  $SYS_EXIT, %eax
int   $LINUX_SYSCALL

exit_err_open:
pushl $error_open
pushl %eax
call  print_error
addl  $8, %esp
movl  %eax, %ebx
movl  $SYS_EXIT, %eax
int   $LINUX_SYSCALL

exit_err_readr:
pushl $error_readr
pushl %eax
call  print_error
addl  $8, %esp
movl  %eax, %ebx
movl  $SYS_EXIT, %eax
int   $LINUX_SYSCALL

exit_err_writef:
pushl $error_writef
pushl %eax
call  print_error
addl  $8, %esp
movl  %eax, %ebx
movl  $SYS_EXIT, %eax
int   $LINUX_SYSCALL
