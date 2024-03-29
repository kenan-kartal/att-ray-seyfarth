# Moving values from memory into registers
.section .data
a:      .quad 175
b:      .quad 4097
.section .text
.global main
main:
        mov a, %rax     # mov a into rax
        add b, %rax     # add b to rax
        xor %rax, %rax
        ret

