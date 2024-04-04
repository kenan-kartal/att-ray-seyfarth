# C wrapper functions - write
.section .data
msg:
        .asciz "Hello World!\n" # String to print
        .equ len,.-msg          # Length of the string
.section .text
.global main
main:
        mov $len,%edx           # Arg 3 is the length
        mov $msg,%rsi           # Arg 2 is the array
        mov $1,%edi             # Arg 1 is the fd
        call write
        xor %edi,%edi           # 0 return=success
        call exit

