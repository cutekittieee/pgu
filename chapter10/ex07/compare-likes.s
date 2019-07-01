.include "linux.s"

.section .data

#Messages used to ask the user for input
msg1:
.ascii "Enter the 1st binary string (allowed characters: 0, 1): "

msg2:
.ascii "Enter the 2nd binary string (allowed characters: 0, 1): "

#Length of the previous two messages
.equ MSG_LEN, 56

.section .bss
#The input of the comparison is a 4 byte unsigned integer
.equ INPUT_SIZE, 4

#Buffers for the user input
.lcomm input_buffer1, INPUT_SIZE
.lcomm input_buffer2, INPUT_SIZE

.section .text
.globl _start
_start:
#Display the 1st message to the user
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  $msg1, %ecx
movl  $MSG_LEN, %edx
int   $LINUX_SYSCALL

#Read the 1st string from STDOUT
pushl $input_buffer1
call  read_32chars
addl  $4, %esp
cmpl  $0, %eax
jne   exit_err

#Display the 2nd message to the user
movl  $SYS_WRITE, %eax
movl  $STDOUT, %ebx
movl  $msg2, %ecx
movl  $MSG_LEN, %edx
int   $LINUX_SYSCALL

#Read the 2nd string from STDOUT
pushl $input_buffer2
call  read_32chars
addl  $4, %esp
cmpl  $0, %eax
jne   exit_err

#Print the commonalities
movl  input_buffer1, %eax
movl  input_buffer2, %ebx
andl  %ebx, %eax
pushl %eax
call  print_likes
addl  $4, %esp
cmpl  $0, %eax
jne   exit_err

#Normal exit
movl  $SYS_EXIT, %eax
movl  $0, %ebx
int   $LINUX_SYSCALL

#1 is returned on error
exit_err:
movl  $SYS_EXIT, %eax
movl  $1, %ebx
int   $LINUX_SYSCALL
