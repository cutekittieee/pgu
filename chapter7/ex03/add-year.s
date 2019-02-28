.include "linux.s"
.include "record-def.s"
.section .data
input_file_name:
.ascii "test.dat\0"

output_file_name:
.ascii "testout.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

#Stack offsets of local variables
.equ ST_INPUT_DESCRIPTOR, -4
.equ ST_OUTPUT_DESCRIPTOR, -8

.section .text
.globl _start
_start:
#Copy stack pointer and make room for local variables
movl  %esp, %ebp
subl  $8, %esp

#Open file for reading
movl  $SYS_OPEN, %eax
movl  $input_file_name, %ebx
movl  $0, %ecx
movl  $0666, %edx
int   $LINUX_SYSCALL

movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)

#Open file for writing
movl  $SYS_OPEN, %eax
movl  $output_file_name, %ebx
movl  $0101, %ecx
movl  $0666, %edx
int   $LINUX_SYSCALL

movl  %eax, ST_OUTPUT_DESCRIPTOR(%ebp)

loop_begin:
cmpl  $0, ST_INPUT_DESCRIPTOR(%ebp)
jl    read_from_keyboard

read_from_file:
pushl ST_INPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call  fread_record
addl  $8, %esp
jmp   read_finish

read_from_keyboard:
pushl $record_buffer
call  read_record
addl  $4, %esp

read_finish:
#If the returned value is less than 0, it indicates an error.
#0 indicates an EOF.
cmpl  $0, %eax
jle   loop_end

#Increment the age
incl  record_buffer + RECORD_AGE

#Write the record out
pushl ST_OUTPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call  write_record
addl  $8, %esp

jmp   loop_begin

loop_end:
movl  $SYS_EXIT, %eax
movl  $0, %ebx
int   $LINUX_SYSCALL
