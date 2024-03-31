# Conditional move
.section .data
x:      .quad 99
.section .text
.global main
main:
        push %rbp
        mov %rsp, %rbp
        sub $16, %rsp
        mov x, %rax
        mov %rax, %rbx          # save original value
        neg %rax                # negate rax
        cmovl %rbx, %rax        # replace rax if negative
        mov $0, %rbx            # set rbx to 0
        mov x, %rax             # get x from memory
        sub $100, %rax          # subtract 100 from x
                                # NOTE: In the book the instruction
                                # is add, it should be sub instead.
        cmovl %rbx, %rax        # set rax to 0 if rax was negative
        mov $0, %rax
        leave
        ret

