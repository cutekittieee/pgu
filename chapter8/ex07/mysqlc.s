# This program demonstrates how to use the libmysqlclient library.
# It prints the library version.
# Creates a database.
# Creates a table.
# Inserts 3 records.
# Queries the records and prints them to STDOUT.

.section .data
version:
.ascii "MySQL client library version: %s\n\0"

hostname:
.ascii "localhost\0"

username:
.ascii "-------\0"

password:
.ascii "-------\0"

create_db:
.ascii "CREATE DATABASE testdb\0"

select_db:
.ascii "USE testdb\0"

create_table:
.ascii "CREATE TABLE person (person_id INT AUTO_INCREMENT, name VARCHAR(70) NOT NULL, age TINYINT, PRIMARY KEY(person_id))\0"

insert_record1:
.ascii "INSERT INTO person (name, age) VALUES('Anthony Hickman',19)\0"

insert_record2:
.ascii "INSERT INTO person (name, age) VALUES('Lucy Barrett',22)\0"

insert_record3:
.ascii "INSERT INTO person (name) VALUES('Mia Benson')\0"

select_records:
.ascii "SELECT * FROM person\0"

errmsg:
.ascii "Error: %s\n\0"

msg_numfields:
.ascii "There are %d columns in the table.\n\0"

msg_tabletb:
.ascii "==========================================================================\0"

msg_tableh:
.ascii "\n||         Index        ||         Name         ||         Age          ||\n\0"

msg_fieldbegin:
.ascii "|| \0"

msg_txtfields:
.ascii "%20s || \0"

msg_newline:
.ascii "\n\0"

msg_nullval:
.ascii "<empty field>\0"

.section .bss
#Holds the MYSQL structure pointer
.lcomm pmysql, 4

#Holds the MYSQL_RES structure pointer
.lcomm precords, 4

#Holds a pointer to the actual records
.lcomm prows, 4

#Holds the number of columns in each record
.lcomm numcols, 4

.section .text
.globl _start
_start:
#Get the library version.
pushl $0
call  mysql_get_client_info
addl  $4, %esp

#Print the library version.
pushl %eax
pushl $version
call  printf
addl  $8, %esp

#Get a MYSQL object. The pointer is returned in %eax.
pushl $0
call  mysql_init
addl  $4, %esp
cmpl  $0, %eax
je    exit_err
movl  %eax, pmysql

#Connect to the database.
pushl $0
pushl $0
pushl $0
pushl $0
pushl $password
pushl $username
pushl $hostname
pushl pmysql
call  mysql_real_connect
addl  $32, %esp
cmpl  $0, %eax
je    exit_err
movl  %eax, pmysql

#Create a new database.
pushl $create_db
pushl pmysql
call  mysql_query
addl  $8, %esp
cmpl  $0, %eax
jne   exit_err

#Select the new database.
pushl  $select_db
pushl  pmysql
call   mysql_query
addl   $8, %esp
cmpl   $0, %eax
jne    exit_err

#Create a new table.
pushl  $create_table
pushl  pmysql
call   mysql_query
addl   $8, %esp
cmpl   $0, %eax
jne    exit_err

#Insert 3 records.
pushl  $insert_record1
pushl  pmysql
call   mysql_query
addl   $8, %esp
cmpl   $0, %eax
jne    exit_err

pushl  $insert_record2
pushl  pmysql
call   mysql_query
addl   $8, %esp
cmpl   $0, %eax
jne    exit_err

pushl  $insert_record3
pushl  pmysql
call   mysql_query
addl   $8, %esp
cmpl   $0, %eax
jne    exit_err

#Query all the records in the table.
pushl  $select_records
pushl  pmysql
call   mysql_query
addl   $8, %esp
cmpl   $0, %eax
jne    exit_err

#Store the result.
pushl  pmysql
call   mysql_store_result
addl   $4, %esp
cmpl   $0, %eax
je     exit_err
movl   %eax, precords

#Get the number of the columns/fields.
pushl  precords
call   mysql_num_fields
addl   $4, %esp
movl   %eax, numcols

#Print the number of the columns/fields.
pushl  %eax
pushl  $msg_numfields
call   printf
addl   $8, %esp

#Display table header
pushl  $msg_tabletb
call   printf
addl   $4, %esp

pushl  $msg_tableh
call   printf
addl   $4, %esp

pushl  $msg_tabletb
call   printf
addl   $4, %esp

#Print all the records.
get_records:
pushl  precords
call   mysql_fetch_row
addl   $4, %esp
cmpl   $0, %eax
je     free_result
movl   %eax, prows

#ecx stores the index of the next column in a record
movl   $0, %ecx

#We display a newline before each record.
pushl  $msg_newline
call   printf
addl   $4, %esp

#Display a field separator before the 1st field
pushl  $msg_fieldbegin
call   printf
addl   $4, %esp

print_columns:
pushl  %ecx
movl   prows, %eax
cmpl   $0, (%eax)
je     write_nullval

pushl  (%eax)
pushl  $msg_txtfields
call   printf
addl   $8, %esp
jmp    continue_processing

write_nullval:
pushl  $msg_nullval
pushl  $msg_txtfields
call   printf
addl   $8, %esp

continue_processing:
addl   $4, prows
popl   %ecx
incl   %ecx
cmpl   numcols, %ecx
je     get_records
jmp    print_columns

free_result:
#Free the MYSQL_RES structure.
pushl  precords
call   mysql_free_result
addl   $4, %esp

#Close the connection to the database.
pushl  pmysql
call   mysql_close
addl   $4, %esp

#Print a newline.
pushl  $msg_newline
call   printf
addl   $4, %esp

#Display table footer
pushl  $msg_tabletb
call   printf
addl   $4, %esp

#Print a newline.
pushl  $msg_newline
call   printf
addl   $4, %esp

exit_ok:
pushl $0
call  exit
addl  $4, %esp

exit_err:
#Get the error message.
pushl pmysql
call  mysql_error
addl  $4, %esp

#Print the error message.
pushl %eax
pushl $errmsg
call  printf
addl  $8, %esp

#Exit with errorcode 1.
pushl $1
call  exit
addl  $4, %esp
