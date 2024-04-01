# Unconditional jump
.section .data
switch:
        .quad .Lc0
        .quad .Lc1
        .quad .Lc2
i:      .quad 2
.section .text
.global main                    # tell linker about main
main:
        mov i, %rax             # move i to rax
        jmp *switch(,%rax,8)    # switch(i)
.Lc0:
        mov $100, %rbx          # go here if i == 0
        jmp .Lend
.Lc1:
        mov $101, %rbx          # go here if i == 1
        jmp .Lend
.Lc2:
        mov $102, %rbx          # go here if i == 2
.Lend:
        xor %eax, %eax
        ret

