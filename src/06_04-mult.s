# Multiplication
.section .data
data:   .quad 10
high:   .quad 0
low:    .quad 0
.section .text
.global main
main:
        push %rbp
        mov %rsp, %rbp
        sub $16, %rsp
        mov $10, %rax
        imul data               # multiply rax by data
        mov %rdx, high          # store upper part of product
        mov %rax, low           # store lower part of product
        imul $100, %rax         # multiply rax by 100
        imul data, %rax         # multiply rax by data
        imul %r10, %r9          # multiply r9 by r10
        imul $100, data, %rbx   # store 100*data in rbx
        imul $50, %rbx, %rdx    # store 50*rbx in rdx
        mov $0, %rax
        leave
        ret

