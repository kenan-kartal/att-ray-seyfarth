# Subtraction
.section .data
a:      .quad 100
b:      .quad 200
diff:   .quad 0
.section .text
.global main
main:
        push %rbp
        mov %rsp, %rbp
        sub $16, %rsp
        mov $10, %rax
        sub %rax, a             # subtract 10 from a
        sub %rax, b             # subtract 10 from b
        mov b, %rax             # mov b into rax
        sub a, %rax             # set rax to b-a
        mov %rax, diff          # move the difference to diff
        mov $0, %rax
        leave
        ret

