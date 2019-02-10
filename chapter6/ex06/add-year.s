.include "linux.s"
.include "record-def.s"
.section .data
file_name:
.ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

#Stack offsets of local variables
.equ ST_FDESCRIPTOR, -4

.section .text
.globl _start
_start:
#Copy stack pointer and make room for local variables
movl  %esp, %ebp
subl  $4, %esp

#Open file for read/write
movl  $SYS_OPEN, %eax
movl  $file_name, %ebx
movl  $2, %ecx
movl  $0666, %edx
int   $LINUX_SYSCALL

movl  %eax, ST_FDESCRIPTOR(%ebp)

loop_begin:
pushl ST_FDESCRIPTOR(%ebp)
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

#Increment the age
incl  record_buffer + RECORD_AGE

#Reposition the file offset to the beginning of the current record
pushl ST_FDESCRIPTOR(%ebp)
call f_repos
addl $4, %esp

#Write the record out
pushl ST_FDESCRIPTOR(%ebp)
pushl $record_buffer
call  write_record
addl  $8, %esp

jmp   loop_begin

loop_end:
movl  $SYS_EXIT, %eax
movl  $0, %ebx
int   $LINUX_SYSCALL
