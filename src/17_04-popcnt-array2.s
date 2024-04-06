# Using the popcnt instruction
.section .text
.global popcnt_array
popcnt_array:
        xor %eax,%eax
        xor %r8d,%r8d
        xor %ecx,%ecx
0:      popcnt (%rdi,%rcx,8),%rdx
        add %rdx,%rax
        popcnt 8(%rdi,%rcx,8),%r9
        add %r9,%r8
        add $2,%rcx
        cmp $rsi,%rcx
        jl 0b
        add %r8,%rax
        ret

