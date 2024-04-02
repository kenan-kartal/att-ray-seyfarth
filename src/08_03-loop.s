# Looping with conditional jumps
.section .data
data:   .quad 0xfedcba9876543210
sum:    .quad 0
.section .text
.global main
main:
        push %rbp
        mov %rsp, %rbp
        sub $16, %rsp
#       Register usage
#
#       rax: bits being examined
#       rbx: carry bit after bt, setc
#       rcx: loop counter, 0-63
#       rdx: sum of 1 bits
#
        mov data, %rax
        xor %ebx, %ebx
        xor %ecx, %ecx
        xor %edx, %edx
while:
        cmp $64, %rcx
        jnl end_while
        bt $0, %rax
        setc %bl
        add %ebx, %edx
        shr $1, %rax
        inc %rcx
        jmp while
end_while:
        mov %rdx, sum
        xor %eax, %eax
        leave
        ret

