.include "linux.s"
.include "record-def.s"
.section .data
input_file_name:
.ascii "test.dat\0"

#Length of the search string
.equ SSTR_LEN, 6

.section .bss
.lcomm record_buffer, RECORD_SIZE
.lcomm search_str, SSTR_LEN

#Input file descriptor offset
.equ ST_INPUT_DESCRIPTOR, -4

.section .text
.globl _start
_start:
#Copy stack pointer
movl  %esp, %ebp
subl  $4, %esp

#Open file for reading
movl  $SYS_OPEN, %eax
movl  $input_file_name, %ebx
movl  $0, %ecx
movl  $0666, %edx
int   $LINUX_SYSCALL
cmpl  $0, %eax
jl    exit_err
movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)

#Read the characters which we want to search for
pushl $search_str
pushl $SSTR_LEN
call  read_5chars
addl  $8, %esp
cmpl  $0, %eax
jl    exit_err

loop_begin:
#Read a record into the buffer
pushl ST_INPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call  read_record
addl  $8, %esp
cmpl  $RECORD_SIZE, %eax
jne   exit_err

#Compare the firstname to the search string.
#If the strings are not equal, we jump to loop_begin.
pushl $record_buffer
pushl $search_str
call  compare_strings
addl  $8, %esp
cmpl  $0, %eax
jne   loop_begin

#If the strings are equal, the record is written to STDOUT.
pushl $record_buffer
call  write_record_std
addl  $4, %esp
cmpl  $0, %eax
jl    exit_err
jmp   loop_begin

#exit the program
movl  $0, %ebx
movl  $SYS_EXIT, %eax
int   $LINUX_SYSCALL

exit_err:
movl  %eax, %ebx
movl  $SYS_EXIT, %eax
int   $LINUX_SYSCALL
