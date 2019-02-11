#Common Linux Definitions

#System Call Numbers
.equ SYS_EXIT, 1
.equ SYS_READ, 3
.equ SYS_WRITE, 4
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ SYS_BRK, 45

#System Call Interrupt Number
.equ LINUX_SYSCALL, 0x80

#Standard File Descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

#Common Status Codes
.equ END_OF_FILE, 0

#Error codes from errno(-base).h
.equ EPERM, 1                            # Operation not permitted
.equ ENOENT, 2                           # No such file or directory
.equ ESRCH, 3                            # No such process
.equ EINTR, 4                            # Interrupted system call
.equ EIO, 5                              # I/O error
.equ ENXIO, 6                            # No such device or address
.equ E2BIG, 7                            # Argument list too long
.equ ENOEXEC, 8                          # Exec format error
.equ EBADF, 9                            # Bad file number
.equ ECHILD, 10                          # No child processes
.equ EAGAIN, 11                          # Try again
.equ EWOULDBLOCK, 11                     # Operation would block
.equ ENOMEM, 12                          # Out of memory
.equ EACCES, 13                          # Permission denied
.equ EFAULT, 14                          # Bad address
.equ ENOTBLK, 15                         # Block device required
.equ EBUSY, 16                           # Device or resource busy
.equ EEXIST, 17                          # File exists
.equ EXDEV, 18                           # Cross-device link
.equ ENODEV, 19                          # No such device
.equ ENOTDIR, 20                         # Not a directory
.equ EISDIR, 21                          # Is a directory
.equ EINVAL, 22                          # Invalid argument
.equ ENFILE, 23                          # File table overflow
.equ EMFILE, 24                          # Too many open files
.equ ENOTTY, 25                          # Not a typewriter
.equ ETXTBSY, 26                         # Text file busy
.equ EFBIG, 27                           # File too large
.equ ENOSPC, 28                          # No space left on device
.equ ESPIPE, 29                          # Illegal seek
.equ EROFS, 30                           # Read-only file system
.equ EMLINK, 31                          # Too many links
.equ EPIPE, 32                           # Broken pipe
.equ EDOM, 33                            # Math argument out of domain of func
.equ ERANGE, 34                          # Math result not representable
.equ EDEADLK, 35                         # Resource deadlock would occur
.equ EDEADLOCK, 35                       # Resource deadlock would occur
.equ ENAMETOOLONG, 36                    # File name too long
.equ ENOLCK, 37                          # No record locks available
.equ ENOSYS, 38                          # Invalid system call number
.equ ENOTEMPTY, 39                       # Directory not empty
.equ ELOOP, 40                           # Too many symbolic links encountered
.equ ENOMSG, 42                          # No message of desired type
.equ EIDRM, 43                           # Identifier removed
.equ ECHRNG, 44                          # Channel number out of range
.equ EL2NSYNC, 45                        # Level 2 not synchronized
.equ EL3HLT, 46                          # Level 3 halted
.equ EL3RST, 47                          # Level 3 reset
.equ ELNRNG, 48                          # Link number out of range
.equ EUNATCH, 49                         # Protocol driver not attached
.equ ENOCSI, 50                          # No CSI structure available
.equ EL2HLT, 51                          # Level 2 halted
.equ EBADE, 52                           # Invalid exchange
.equ EBADR, 53                           # Invalid request descriptor
.equ EXFULL, 54                          # Exchange full
.equ ENOANO, 55                          # No anode
.equ EBADRQC, 56                         # Invalid request code
.equ EBADSLT, 57                         # Invalid slot
.equ EBFONT, 59                          # Bad font file format
.equ ENOSTR, 60                          # Device not a stream
.equ ENODATA, 61                         # No data available
.equ ETIME, 62                           # Timer expired
.equ ENOSR, 63                           # Out of streams resources
.equ ENONET, 64                          # Machine is not on the network
.equ ENOPKG, 65                          # Package not installed
.equ EREMOTE, 66                         # Object is remote
.equ ENOLINK, 67                         # Link has been severed
.equ EADV, 68                            # Advertise error
.equ ESRMNT, 69                          # Srmount error
.equ ECOMM, 70                           # Communication error on send
.equ EPROTO, 71                          # Protocol error
.equ EMULTIHOP, 72                       # Multihop attempted
.equ EDOTDOT, 73                         # RFS specific error
.equ EBADMSG, 74                         # Not a data message
.equ EOVERFLOW, 75                       # Value too large for defined data type
.equ ENOTUNIQ, 76                        # Name not unique on network
.equ EBADFD, 77                          # File descriptor in bad state
.equ EREMCHG, 78                         # Remote address changed
.equ ELIBACC, 79                         # Can not access a needed shared library
.equ ELIBBAD, 80                         # Accessing a corrupted shared library
.equ ELIBSCN, 81                         # .lib section in a.out corrupted
.equ ELIBMAX, 82                         # Attempting to link in too many shared libraries
.equ ELIBEXEC, 83                        # Cannot exec a shared library directly
.equ EILSEQ, 84                          # Illegal byte sequence
.equ ERESTART, 85                        # Interrupted system call should be restarted
.equ ESTRPIPE, 86                        # Streams pipe error
.equ EUSERS, 87                          # Too many users
.equ ENOTSOCK, 88                        # Socket operation on non-socket
.equ EDESTADDRREQ, 89                    # Destination address required
.equ EMSGSIZE, 90                        # Message too long
.equ EPROTOTYPE, 91                      # Protocol wrong type for socket
.equ ENOPROTOOPT, 92                     # Protocol not available
.equ EPROTONOSUPPORT, 93                 # Protocol not supported
.equ ESOCKTNOSUPPORT, 94                 # Socket type not supported
.equ EOPNOTSUPP, 95                      # Operation not supported on transport endpoint
.equ EPFNOSUPPORT, 96                    # Protocol family not supported
.equ EAFNOSUPPORT, 97                    # Address family not supported by protocol
.equ EADDRINUSE, 98                      # Address already in use
.equ EADDRNOTAVAIL, 99                   # Cannot assign requested address
.equ ENETDOWN, 100                       # Network is down
.equ ENETUNREACH, 101                    # Network is unreachable
.equ ENETRESET, 102                      # Network dropped connection because of reset
.equ ECONNABORTED, 103                   # Software caused connection abort
.equ ECONNRESET, 104                     # Connection reset by peer
.equ ENOBUFS, 105                        # No buffer space available
.equ EISCONN, 106                        # Transport endpoint is already connected
.equ ENOTCONN, 107                       # Transport endpoint is not connected
.equ ESHUTDOWN, 108                      # Cannot send after transport endpoint shutdown
.equ ETOOMANYREFS, 109                   # Too many references: cannot splice
.equ ETIMEDOUT, 110                      # Connection timed out
.equ ECONNREFUSED, 111                   # Connection refused
.equ EHOSTDOWN, 112                      # Host is down
.equ EHOSTUNREACH, 113                   # No route to host
.equ EALREADY, 114                       # Operation already in progress
.equ EINPROGRESS, 115                    # Operation now in progress
.equ ESTALE, 116                         # Stale file handle
.equ EUCLEAN, 117                        # Structure needs cleaning
.equ ENOTNAM, 118                        # Not a XENIX named type file
.equ ENAVAIL, 119                        # No XENIX semaphores available
.equ EISNAM, 120                         # Is a named type file
.equ EREMOTEIO, 121                      # Remote I/O error
.equ EDQUOT, 122                         # Quota exceeded
.equ ENOMEDIUM, 123                      # No medium found
.equ EMEDIUMTYPE, 124                    # Wrong medium type
.equ ECANCELED, 125                      # Operation Canceled
.equ ENOKEY, 126                         # Required key not available
.equ EKEYEXPIRED, 127                    # Key has expired
.equ EKEYREVOKED, 128                    # Key has been revoked
.equ EKEYREJECTED, 129                   # Key was rejected by service
.equ EOWNERDEAD, 130                     # Owner died
.equ ENOTRECOVERABLE, 131                # State not recoverable
.equ ERFKILL, 132                        # Operation not possible due to RF-kill
.equ EHWPOISON, 133                      # Memory page has hardware error
