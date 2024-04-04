# 64 bit system calls
.section .data
hello:
        .asciz "Hello world!\n"
.section .text
.global _start
_start:
        mov $1,%eax             # syscall 1 is write
        mov $1,%edi             # file descriptor
        lea hello,%rsi          # array to write
        mov $13,%edx            # write 13 bytes
        syscall
        mov $60,%eax            # syscall 60 is exit
        xor %edi,%edi           # exit(0)
        syscall

