# Division
.section .data
x:      .quad 255
y:      .quad 2
quot:   .quad 0
rem:    .quad 0
.section .text
.global main
main:
        push %rbp
        mov %rsp, %rbp
        sub $16, %rsp
        mov x, %rax             # x will be the dividend
        mov $0, %rdx            # 0 out rdx, so rdx:rax == rax
                                # NOTE: In the book it shows rax as dest,
                                # which is a bug.
        idiv y                  # divide by y
        mov %rax, quot          # store the quotient
        mov %rdx, rem           # store the remainder
        mov $0, %rax
        leave
        ret

