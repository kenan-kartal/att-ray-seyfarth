# Function call
.section .data
msg:    .asciz "Hello World!\n"
.section .text
.global main
main:
        push %rbp
        mov %rsp,%rbp
        lea msg,%rdi            # parameter 1 for printf
        xor %eax,%eax           # 0 floating point parameters
        call printf
        xor %eax,%eax           # return 0
        pop %rbp
        ret

