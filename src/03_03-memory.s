# Memory examle
.section .data
a:      .dc.l 4
b:      .dc.s 4.4
c:      .ds.l 10, 0
d:      .dc.w 1, 2
e:      .dc.b 0xFB
f:      .asciz "hello world"

.section .bss
        .lcomm g, 4
        .lcomm h, 40
        .lcomm i, 400

.section .text
.global main                    # let gcc know about main
main:
        push %rbp               # set up a stack frame for main
        mov %rsp, %rbp          # set rbp to point to the stack frame
        sub $16, %rsp           # leave some room for local variable
                                # leave rsp on a 16 byte boundary
        xor %eax, %eax          # set rax to 0 for return value
        leave                   # undo the stack frame manipulations
        ret

