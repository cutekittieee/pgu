.include "linux.s"

.section .data

#Constant data of the records we want to write
#Each text data item is padded to the proper
#length with null (i.e. 0) bytes.

#.rept is used to pad each item.  .rept tells
#the assembler to repeat the section between
#.rept and .endr the number of times specified.
#This is used in this program to add extra null
#characters at the end of each field to fill
#it up
record1:
.ascii "Fredrick\0"
.rept 31 #Padding to 40 bytes
.byte 0
.endr

.ascii "Bartlett\0"
.rept 31 #Padding to 40 bytes
.byte 0
.endr

.ascii "4242 S Prairie\nTulsa, OK 55555\0"
.rept 209 #Padding to 240 bytes
.byte 0
.endr

.long 45

record2:
.ascii "Marilyn\0"
.rept 32 #Padding to 40 bytes
.byte 0
.endr

.ascii "Taylor\0"
.rept 33 #Padding to 40 bytes
.byte 0
.endr

.ascii "2224 S Johannan St\nChicago, IL 12345\0"
.rept 203 #Padding to 240 bytes
.byte 0
.endr

.long 29

record3:
.ascii "Derrick\0"
.rept 32 #Padding to 40 bytes
.byte 0
.endr
.ascii "McIntire\0"
.rept 31 #Padding to 40 bytes
.byte 0
.endr

.ascii "500 W Oakland\nSan Diego, CA 54321\0"
.rept 206 #Padding to 240 bytes
.byte 0
.endr

.long 36

record4:
.ascii "Edith\0"
.rept 34
.byte 0
.endr
.ascii "Siefert\0"
.rept 32
.byte 0
.endr

.ascii "4781 Winifred Way\nTipton, IN 46072\0"
.rept 205
.byte 0
.endr

.long 23

record5:
.ascii "Edward\0"
.rept 33
.byte 0
.endr
.ascii "Trombley\0"
.rept 31
.byte 0
.endr

.ascii "2505 Ray Court\nWilmington, NC 28412\0"
.rept 204
.byte 0
.endr

.long 75

record6:
.ascii "Bryci\0"
.rept 34
.byte 0
.endr
.ascii "Mauricio\0"
.rept 31
.byte 0
.endr

.ascii "439 Columbia Road\nNewark, DE 19711\0"
.rept 205
.byte 0
.endr

.long 39

record7:
.ascii "David\0"
.rept 34
.byte 0
.endr
.ascii "Brackett\0"
.rept 31
.byte 0
.endr

.ascii "4108 Blue Spruce Lane\nDundalk, MD 21222\0"
.rept 200
.byte 0
.endr

.long 41

record8:
.ascii "Kyle\0"
.rept 35
.byte 0
.endr
.ascii "Andrews\0"
.rept 32
.byte 0
.endr

.ascii "2013 Graystone Lakes\nMacon, GA 31201\0"
.rept 203
.byte 0
.endr

.long 32

record9:
.ascii "Reid\0"
.rept 35
.byte 0
.endr
.ascii "Keller\0"
.rept 33
.byte 0
.endr

.ascii "376 Mattson Street\nPortland, OR 97225\0"
.rept 202
.byte 0
.endr

.long 48

record10:
.ascii "Brennen\0"
.rept 32
.byte 0
.endr
.ascii "Justice\0"
.rept 32
.byte 0
.endr

.ascii "2597 Jarvisville Road\nHuntington, NY 11743\0"
.rept 197
.byte 0
.endr

.long 19

#This is the name of the file we will write to
file_name:
.ascii "test.dat\0"

.section .text
.equ ST_FILE_DESCRIPTOR, -4
.globl _start
_start:
#Copy the stack pointer to %ebp
movl  %esp, %ebp
#Allocate space to hold the file descriptor
subl  $4, %esp

#Open the file
movl  $SYS_OPEN, %eax
movl  $file_name, %ebx
movl  $0101, %ecx #This says to create if it
                 #doesn't exist, and open for
                 #writing
movl  $0666, %edx
int   $LINUX_SYSCALL

#Store the file descriptor away
movl  %eax, ST_FILE_DESCRIPTOR(%ebp)

#Write the 1st record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record1
call  write_record
addl  $8, %esp

#Write the 2nd record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record2
call  write_record
addl  $8, %esp

#Write the 3rd record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record3
call  write_record
addl  $8, %esp

#Write the 4th record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record4
call  write_record
addl  $8, %esp

#Write the 5th record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record5
call  write_record
addl  $8, %esp

#Write the 6th record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record6
call  write_record
addl  $8, %esp

#Write the 7th record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record7
call  write_record
addl  $8, %esp

#Write the 8th record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record8
call  write_record
addl  $8, %esp

#Write the 9th record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record9
call  write_record
addl  $8, %esp

#Write the 10th record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record10
call  write_record
addl  $8, %esp

#Close the file descriptor
movl  $SYS_CLOSE, %eax
movl  ST_FILE_DESCRIPTOR(%ebp), %ebx
int   $LINUX_SYSCALL

#Exit the program
movl  $SYS_EXIT, %eax
movl  $0, %ebx
int   $LINUX_SYSCALL
