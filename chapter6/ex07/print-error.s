.include "linux.s"

#PURPOSE:  This function prints an error message to STDERR.
#          The error codes can be returned by any of the system calls.
#          They are translated into human-readable messages (according to errno(-base).h).
#
#INPUT:    Parameter1: A null-terminated leading string which will be printed directly before the error message itself. (for example, it might refer to the affected file name or resource)
#          Parameter2: The error code (number) which will be translated into an appropriate error message. It should be a negative number.
#
#OUTPUT:   This function simply returns 0.

#STACK LOCAL VARIABLES
.equ ST_ERRCODE, 8
.equ ST_LDBUF, 12

#Constants

#Maximum allowed length of an error message without the leading string.
#The error messages which are shorter will be padded with zero bytes. Currently, 49 bytes is the maximum length with the newline and terminating zero characters included.
.equ MSG_MAX, 50

.section .data

err_messages:
#Error code 0 and some others do not refer to an actual error condition, so their fields are only padded to the rigth length.
.rept MSG_MAX
.byte 0
.endr

#Error code 1
.ascii "Operation not permitted\n\0"
.rept MSG_MAX-25
.byte 0
.endr

#Error code 2
.ascii "No such file or directory\n\0"
.rept MSG_MAX-27
.byte 0
.endr

#Error code 3
.ascii "No such process\n\0"
.rept MSG_MAX-17
.byte 0
.endr

#Error code 4
.ascii "Interrupted system call\n\0"
.rept MSG_MAX-25
.byte 0
.endr

#Error code 5
.ascii "I/O error\n\0"
.rept MSG_MAX-11
.byte 0
.endr

#Error code 6
.ascii "No such device or address\n\0"
.rept MSG_MAX-27
.byte 0
.endr

#Error code 7
.ascii "Argument list too long\n\0"
.rept MSG_MAX-24
.byte 0
.endr

#Error code 8
.ascii "Exec format error\n\0"
.rept MSG_MAX-19
.byte 0
.endr

#Error code 9
.ascii "Bad file number\n\0"
.rept MSG_MAX-17
.byte 0
.endr

#Error code 10
.ascii "No child processes\n\0"
.rept MSG_MAX-20
.byte 0
.endr

#Error code 11
.ascii "Try again, operation would block\n\0"
.rept MSG_MAX-34
.byte 0
.endr

#Error code 12
.ascii "Out of memory\n\0"
.rept MSG_MAX-15
.byte 0
.endr

#Error code 13
.ascii "Permission denied\n\0"
.rept MSG_MAX-19
.byte 0
.endr

#Error code 14
.ascii "Bad address\n\0"
.rept MSG_MAX-13
.byte 0
.endr

#Error code 15
.ascii "Block device required\n\0"
.rept MSG_MAX-23
.byte 0
.endr

#Error code 16
.ascii "Device or resource busy\n\0"
.rept MSG_MAX-25
.byte 0
.endr

#Error code 17
.ascii "File exists\n\0"
.rept MSG_MAX-13
.byte 0
.endr

#Error code 18
.ascii "Cross-device link\n\0"
.rept MSG_MAX-19
.byte 0
.endr

#Error code 19
.ascii "No such device\n\0"
.rept MSG_MAX-16
.byte 0
.endr

#Error code 20
.ascii "Not a directory\n\0"
.rept MSG_MAX-17
.byte 0
.endr

#Error code 21
.ascii "Is a directory\n\0"
.rept MSG_MAX-16
.byte 0
.endr

#Error code 22
.ascii "Invalid argument\n\0"
.rept MSG_MAX-18
.byte 0
.endr

#Error code 23
.ascii "File table overflow\n\0"
.rept MSG_MAX-21
.byte 0
.endr

#Error code 24
.ascii "Too many open files\n\0"
.rept MSG_MAX-21
.byte 0
.endr

#Error code 25
.ascii "Not a typewriter\n\0"
.rept MSG_MAX-18
.byte 0
.endr

#Error code 26
.ascii "Text file busy\n\0"
.rept MSG_MAX-16
.byte 0
.endr

#Error code 27
.ascii "File too large\n\0"
.rept MSG_MAX-16
.byte 0
.endr

#Error code 28
.ascii "No space left on device\n\0"
.rept MSG_MAX-25
.byte 0
.endr

#Error code 29
.ascii "Illegal seek\n\0"
.rept MSG_MAX-14
.byte 0
.endr

#Error code 30
.ascii "Read-only file system\n\0"
.rept MSG_MAX-23
.byte 0
.endr

#Error code 31
.ascii "Too many links\n\0"
.rept MSG_MAX-16
.byte 0
.endr

#Error code 32
.ascii "Broken pipe\n\0"
.rept MSG_MAX-13
.byte 0
.endr

#Error code 33
.ascii "Math argument out of domain of func\n\0"
.rept MSG_MAX-37
.byte 0
.endr

#Error code 34
.ascii "Math result not representable\n\0"
.rept MSG_MAX-31
.byte 0
.endr

#Error code 35
.ascii "Resource deadlock would occur\n\0"
.rept MSG_MAX-31
.byte 0
.endr

#Error code 36
.ascii "File name too long\n\0"
.rept MSG_MAX-20
.byte 0
.endr

#Error code 37
.ascii "No record locks available\n\0"
.rept MSG_MAX-27
.byte 0
.endr

#Error code 38
.ascii "Invalid system call number\n\0"
.rept MSG_MAX-28
.byte 0
.endr

#Error code 39
.ascii "Directory not empty\n\0"
.rept MSG_MAX-21
.byte 0
.endr

#Error code 40
.ascii "Too many symbolic links encountered\n\0"
.rept MSG_MAX-37
.byte 0
.endr

#Error code 41
.rept MSG_MAX
.byte 0
.endr

#Error code 42
.ascii "No message of desired type\n\0"
.rept MSG_MAX-28
.byte 0
.endr

#Error code 43
.ascii "Identifier removed\n\0"
.rept MSG_MAX-20
.byte 0
.endr

#Error code 44
.ascii "Channel number out of range\n\0"
.rept MSG_MAX-29
.byte 0
.endr

#Error code 45
.ascii "Level 2 not synchronized\n\0"
.rept MSG_MAX-26
.byte 0
.endr

#Error code 46
.ascii "Level 3 halted\n\0"
.rept MSG_MAX-16
.byte 0
.endr

#Error code 47
.ascii "Level 3 reset\n\0"
.rept MSG_MAX-15
.byte 0
.endr

#Error code 48
.ascii "Link number out of range\n\0"
.rept MSG_MAX-26
.byte 0
.endr

#Error code 49
.ascii "Protocol driver not attached\n\0"
.rept MSG_MAX-30
.byte 0
.endr

#Error code 50
.ascii "No CSI structure available\n\0"
.rept MSG_MAX-28
.byte 0
.endr

#Error code 51
.ascii "Level 2 halted\n\0"
.rept MSG_MAX-16
.byte 0
.endr

#Error code 52
.ascii "Invalid exchange\n\0"
.rept MSG_MAX-18
.byte 0
.endr

#Error code 53
.ascii "Invalid request descriptor\n\0"
.rept MSG_MAX-28
.byte 0
.endr

#Error code 54
.ascii "Exchange full\n\0"
.rept MSG_MAX-15
.byte 0
.endr

#Error code 55
.ascii "No anode\n\0"
.rept MSG_MAX-10
.byte 0
.endr

#Error code 56
.ascii "Invalid request code\n\0"
.rept MSG_MAX-22
.byte 0
.endr

#Error code 57
.ascii "Invalid slot\n\0"
.rept MSG_MAX-14
.byte 0
.endr

#Error code 58
.rept MSG_MAX
.byte 0
.endr

#Error code 59
.ascii "Bad font file format\n\0"
.rept MSG_MAX-22
.byte 0
.endr

#Error code 60
.ascii "Device not a stream\n\0"
.rept MSG_MAX-21
.byte 0
.endr

#Error code 61
.ascii "No data available\n\0"
.rept MSG_MAX-19
.byte 0
.endr

#Error code 62
.ascii "Timer expired\n\0"
.rept MSG_MAX-15
.byte 0
.endr

#Error code 63
.ascii "Out of streams resources\n\0"
.rept MSG_MAX-26
.byte 0
.endr

#Error code 64
.ascii "Machine is not on the network\n\0"
.rept MSG_MAX-31
.byte 0
.endr

#Error code 65
.ascii "Package not installed\n\0"
.rept MSG_MAX-23
.byte 0
.endr

#Error code 66
.ascii "Object is remote\n\0"
.rept MSG_MAX-18
.byte 0
.endr

#Error code 67
.ascii "Link has been severed\n\0"
.rept MSG_MAX-23
.byte 0
.endr

#Error code 68
.ascii "Advertise error\n\0"
.rept MSG_MAX-17
.byte 0
.endr

#Error code 69
.ascii "Srmount error\n\0"
.rept MSG_MAX-15
.byte 0
.endr

#Error code 70
.ascii "Communication error on send\n\0"
.rept MSG_MAX-29
.byte 0
.endr

#Error code 71
.ascii "Protocol error\n\0"
.rept MSG_MAX-16
.byte 0
.endr

#Error code 72
.ascii "Multihop attempted\n\0"
.rept MSG_MAX-20
.byte 0
.endr

#Error code 73
.ascii "RFS specific error\n\0"
.rept MSG_MAX-20
.byte 0
.endr

#Error code 74
.ascii "Not a data message\n\0"
.rept MSG_MAX-20
.byte 0
.endr

#Error code 75
.ascii "Value too large for defined data type\n\0"
.rept MSG_MAX-39
.byte 0
.endr

#Error code 76
.ascii "Name not unique on network\n\0"
.rept MSG_MAX-28
.byte 0
.endr

#Error code 77
.ascii "File descriptor in bad state\n\0"
.rept MSG_MAX-30
.byte 0
.endr

#Error code 78
.ascii "Remote address changed\n\0"
.rept MSG_MAX-24
.byte 0
.endr

#Error code 79
.ascii "Can not access a needed shared library\n\0"
.rept MSG_MAX-40
.byte 0
.endr

#Error code 80
.ascii "Accessing a corrupted shared library\n\0"
.rept MSG_MAX-38
.byte 0
.endr

#Error code 81
.ascii ".lib section in a.out corrupted\n\0"
.rept MSG_MAX-33
.byte 0
.endr

#Error code 82
.ascii "Attempting to link in too many shared libraries\n\0"
.rept MSG_MAX-49
.byte 0
.endr

#Error code 83
.ascii "Cannot exec a shared library directly\n\0"
.rept MSG_MAX-39
.byte 0
.endr

#Error code 84
.ascii "Illegal byte sequence\n\0"
.rept MSG_MAX-23
.byte 0
.endr

#Error code 85
.ascii "Interrupted system call should be restarted\n\0"
.rept MSG_MAX-45
.byte 0
.endr

#Error code 86
.ascii "Streams pipe error\n\0"
.rept MSG_MAX-20
.byte 0
.endr

#Error code 87
.ascii "Too many users\n\0"
.rept MSG_MAX-16
.byte 0
.endr

#Error code 88
.ascii "Socket operation on non-socket\n\0"
.rept MSG_MAX-32
.byte 0
.endr

#Error code 89
.ascii "Destination address required\n\0"
.rept MSG_MAX-30
.byte 0
.endr

#Error code 90
.ascii "Message too long\n\0"
.rept MSG_MAX-18
.byte 0
.endr

#Error code 91
.ascii "Protocol wrong type for socket\n\0"
.rept MSG_MAX-32
.byte 0
.endr

#Error code 92
.ascii "Protocol not available\n\0"
.rept MSG_MAX-24
.byte 0
.endr

#Error code 93
.ascii "Protocol not supported\n\0"
.rept MSG_MAX-24
.byte 0
.endr

#Error code 94
.ascii "Socket type not supported\n\0"
.rept MSG_MAX-27
.byte 0
.endr

#Error code 95
.ascii "Operation not supported on transport endpoint\n\0"
.rept MSG_MAX-47
.byte 0
.endr

#Error code 96
.ascii "Protocol family not supported\n\0"
.rept MSG_MAX-31
.byte 0
.endr

#Error code 97
.ascii "Address family not supported by protocol\n\0"
.rept MSG_MAX-42
.byte 0
.endr

#Error code 98
.ascii "Address already in use\n\0"
.rept MSG_MAX-24
.byte 0
.endr

#Error code 99
.ascii "Cannot assign requested address\n\0"
.rept MSG_MAX-33
.byte 0
.endr

#Error code 100
.ascii "Network is down\n\0"
.rept MSG_MAX-17
.byte 0
.endr

#Error code 101
.ascii "Network is unreachable\n\0"
.rept MSG_MAX-24
.byte 0
.endr

#Error code 102
.ascii "Network dropped connection because of reset\n\0"
.rept MSG_MAX-45
.byte 0
.endr

#Error code 103
.ascii "Software caused connection abort\n\0"
.rept MSG_MAX-34
.byte 0
.endr

#Error code 104
.ascii "Connection reset by peer\n\0"
.rept MSG_MAX-26
.byte 0
.endr

#Error code 105
.ascii "No buffer space available\n\0"
.rept MSG_MAX-27
.byte 0
.endr

#Error code 106
.ascii "Transport endpoint is already connected\n\0"
.rept MSG_MAX-41
.byte 0
.endr

#Error code 107
.ascii "Transport endpoint is not connected\n\0"
.rept MSG_MAX-37
.byte 0
.endr

#Error code 108
.ascii "Cannot send after transport endpoint shutdown\n\0"
.rept MSG_MAX-47
.byte 0
.endr

#Error code 109
.ascii "Too many references: cannot splice\n\0"
.rept MSG_MAX-36
.byte 0
.endr

#Error code 110
.ascii "Connection timed out\n\0"
.rept MSG_MAX-22
.byte 0
.endr

#Error code 111
.ascii "Connection refused\n\0"
.rept MSG_MAX-20
.byte 0
.endr

#Error code 112
.ascii "Host is down\n\0"
.rept MSG_MAX-14
.byte 0
.endr

#Error code 113
.ascii "No route to host\n\0"
.rept MSG_MAX-18
.byte 0
.endr

#Error code 114
.ascii "Operation already in progress\n\0"
.rept MSG_MAX-31
.byte 0
.endr

#Error code 115
.ascii "Operation now in progress\n\0"
.rept MSG_MAX-27
.byte 0
.endr

#Error code 116
.ascii "Stale file handle\n\0"
.rept MSG_MAX-19
.byte 0
.endr

#Error code 117
.ascii "Structure needs cleaning\n\0"
.rept MSG_MAX-26
.byte 0
.endr

#Error code 118
.ascii "Not a XENIX named type file\n\0"
.rept MSG_MAX-29
.byte 0
.endr

#Error code 119
.ascii "No XENIX semaphores available\n\0"
.rept MSG_MAX-31
.byte 0
.endr

#Error code 120
.ascii "Is a named type file\n\0"
.rept MSG_MAX-22
.byte 0
.endr

#Error code 121
.ascii "Remote I/O error\n\0"
.rept MSG_MAX-18
.byte 0
.endr

#Error code 122
.ascii "Quota exceeded\n\0"
.rept MSG_MAX-16
.byte 0
.endr

#Error code 123
.ascii "No medium found\n\0"
.rept MSG_MAX-17
.byte 0
.endr

#Error code 124
.ascii "Wrong medium type\n\0"
.rept MSG_MAX-19
.byte 0
.endr

#Error code 125
.ascii "Operation Canceled\n\0"
.rept MSG_MAX-20
.byte 0
.endr

#Error code 126
.ascii "Required key not available\n\0"
.rept MSG_MAX-28
.byte 0
.endr

#Error code 127
.ascii "Key has expired\n\0"
.rept MSG_MAX-17
.byte 0
.endr

#Error code 128
.ascii "Key has been revoked\n\0"
.rept MSG_MAX-22
.byte 0
.endr

#Error code 129
.ascii "Key was rejected by service\n\0"
.rept MSG_MAX-29
.byte 0
.endr

#Error code 130
.ascii "Owner died\n\0"
.rept MSG_MAX-12
.byte 0
.endr

#Error code 131
.ascii "State not recoverable\n\0"
.rept MSG_MAX-23
.byte 0
.endr

#Error code 132
.ascii "Operation not possible due to RF-kill\n\0"
.rept MSG_MAX-39
.byte 0
.endr

#Error code 133
.ascii "Memory page has hardware error\n\0"
.rept MSG_MAX-32
.byte 0
.endr

.section .text
.globl print_error
.type print_error, @function
print_error:
pushl %ebp
movl  %esp, %ebp

#Firstly, the leading string is printed to STDERR.
movl  ST_LDBUF(%ebp), %eax
pushl %eax
call  count_chars
addl  $4, %esp
cmpl  $0, %eax
je    print_errmsg

movl  %eax, %edx
movl  $SYS_WRITE, %eax
movl  $STDERR, %ebx
movl  ST_LDBUF(%ebp), %ecx
int   $LINUX_SYSCALL

#If an error is detected, we silently exit
cmpl  $0, %eax
jl    exit_prerr

#Next, we lookup and print out the error message
print_errmsg:
#Calculate the address and length of the message
movl  ST_ERRCODE(%ebp), %eax
negl  %eax
imull $MSG_MAX, %eax
addl  $err_messages, %eax
pushl %eax
call  count_chars
addl  $4, %esp
cmpl  $0, %eax
je    exit_prerr

#Print out the error message
movl  %eax, %edx
movl  ST_ERRCODE(%ebp), %eax
negl  %eax
imull $MSG_MAX, %eax
addl  $err_messages, %eax
movl  %eax, %ecx
movl  $SYS_WRITE, %eax
movl  $STDERR, %ebx
int   $LINUX_SYSCALL

exit_prerr:
#We return 0. The function does not handle consecutive errors.
movl  $0, %eax

movl  %ebp, %esp
popl  %ebp
ret
