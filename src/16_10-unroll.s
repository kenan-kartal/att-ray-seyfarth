# Unroll loops
# Simple
.section .text
.global add_array
add_array:
        xor %eax,%eax
0:      add (%rdi),%rax
        add $8,%rdi
        dec %rsi
        jg 0b
        ret
# Unrolled
.section .text
.global add_array_unrolled
add_array_unrolled:
        push %r15
        push %r14
        push %r13
        push %r12
        push %rbp
        push %rbx
        xor %eax,%eax
        mov %rax,%rbx
        mov %rax,%rcx
        mov %rax,%rdx
0:      add (%rdi),%rax
        add 8(%rdi),%rbx
        add 16(%rdi),%rcx
        add 24(%rdi),%rdx
        add $32,%rdi
        sub $4,%rsi
        jg 0b
        add %rdx,%rcx
        add %rbx,%rax
        add %rcx,%rax
        pop %rbx
        pop %rbp
        pop %r12
        pop %r13
        pop %r14
        pop %r15
        ret

