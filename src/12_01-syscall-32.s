# 32 bit system calls
.section .data
hello:
        .asciz "Hello world!\n"
.section .text
.global main
main:
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
        mov $4,%eax             # syscall 4 is write
        mov $1,%ebx             # file descriptor
        lea hello,%ecx          # array to write
        mov $13,%rdx            # write 13 bytes
        int $0x80
        xor %eax,%eax
        leave
        ret

