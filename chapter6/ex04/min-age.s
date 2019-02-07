.include "linux.s"
.include "record-def.s"
.section .data
input_file_name:
.ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

#Stack offsets of local variables
.equ ST_INPUT_DESCRIPTOR, -4

.section .text
.globl _start
_start:
#Copy stack pointer and make room for local variables
movl  %esp, %ebp
subl  $4, %esp

#The current smallest age (default: 255)
movl  $255, %edi

#Open file for reading
movl  $SYS_OPEN, %eax
movl  $input_file_name, %ebx
movl  $0, %ecx
movl  $0666, %edx
int   $LINUX_SYSCALL

movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)

loop_begin:
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
jne   loop_end

#Compare the age to the current smallest value
cmpl  %edi, record_buffer + RECORD_AGE
jge   loop_begin
#Set the new smallest value
movl  record_buffer + RECORD_AGE, %edi
jmp   loop_begin

loop_end:
movl  $SYS_EXIT, %eax
movl  %edi, %ebx
int   $LINUX_SYSCALL
