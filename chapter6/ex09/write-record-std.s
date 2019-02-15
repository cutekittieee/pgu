.include "linux.s"
.include "record-def.s"
#PURPOSE:   This function writes a record to STDOUT.
#
#INPUT:     A record buffer.
#
#OUTPUT:    This function produces a status code. It returns 0 on successful completion and -1 on error.

#STACK LOCAL VARIABLES
.equ ST_WRITE_BUFFER, 8
.section .text
.globl write_record_std
.type write_record_std, @function
write_record_std:
pushl %ebp
movl  %esp, %ebp

#Count the characters to write
pushl ST_WRITE_BUFFER(%ebp)
pushl $LEN_FIRSTNAME
call  count_chars
addl  $8, %esp

#Write the firstname field to STDOUT
movl  %eax, %edx
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  ST_WRITE_BUFFER(%ebp), %ecx
int   $LINUX_SYSCALL
cmpl  $0, %eax
jl    exit_wr_fail

#Write a newline to STDOUT
pushl $STDOUT
call  write_newline
addl  $4, %esp

#Count the characters to write
movl  ST_WRITE_BUFFER(%ebp), %eax
addl  $RECORD_LASTNAME, %eax
pushl %eax
pushl $LEN_LASTNAME
call  count_chars
addl  $8, %esp

#Write the lastname field to STDOUT
movl  %eax, %edx
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  ST_WRITE_BUFFER(%ebp), %ecx
addl  $RECORD_LASTNAME, %ecx
int   $LINUX_SYSCALL
cmpl  $0, %eax
jl    exit_wr_fail

#Write a newline to STDOUT
pushl $STDOUT
call  write_newline
addl  $4, %esp

#Count the characters to write
movl  ST_WRITE_BUFFER(%ebp), %eax
addl  $RECORD_ADDRESS, %eax
pushl %eax
pushl $LEN_ADDRESS
call  count_chars
addl  $8, %esp

#Write the address field to STDOUT
movl  %eax, %edx
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  ST_WRITE_BUFFER(%ebp), %ecx
addl  $RECORD_ADDRESS, %ecx
int   $LINUX_SYSCALL
cmpl  $0, %eax
jl    exit_wr_fail

#Write a newline to STDOUT
pushl $STDOUT
call  write_newline
addl  $4, %esp

#Write the age field (always LEN_AGE bytes, in this case) to STDOUT
#Here, we do not convert the age, we simply print out the LEN_AGE bytes to STDOUT.
movl  $LEN_AGE, %edx
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  ST_WRITE_BUFFER(%ebp), %ecx
addl  $RECORD_AGE, %ecx
int   $LINUX_SYSCALL
cmpl  $0, %eax
jl    exit_wr_fail

#Write two newlines to STDOUT
pushl $STDOUT
call  write_newline
call  write_newline
addl  $4, %esp

exit_wr_ok:
movl  $0, %eax
movl  %ebp, %esp
popl  %ebp
ret

exit_wr_fail:
movl  $1, %eax
negl  %eax
movl  %ebp, %esp
popl  %ebp
ret
