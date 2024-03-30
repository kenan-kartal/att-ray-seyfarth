# Addition
.section .data
a:      .quad 151
b:      .quad 310
sum:    .quad 0
.section .text
.global main
main:
        push %rbp
        mov %rsp, %rbp
        sub $16, %rsp
        mov $9, %rax    # set rax to 9
        add %rax, a     # add rax to a
        mov b, %rax     # get b into rax
        add $10, %rax   # add 10 to rax
        add a, %rax     # add the contents of a
        mov %rax, sum   # save the sum in sum
        mov $0, %rax
        leave
        ret

