# Counting 1 Bits in Assembly
.section .text
.global popcnt_array
popcnt_array:
        push %rbx
        push %rbp
        push %r12
        push %r13
        push %r14
        push %r15

        xor %eax,%eax
        xor %ebx,%ebx
        xor %ecx,%ecx
        xor %edx,%edx
        xor %r12d,%r12d
        xor %r13d,%r13d
        xor %r14d,%r14d
        xor %r15d,%r15d

0:      mov (%rdi),%r8
        mov %r8,%r9
        mov %r8,%r10
        mov %r9,%r11

        and $0xffff,%r8
        shr $16,%r9
        and $0xffff,%r9
        shr $32,%r10
        and $0xffff,%r10
        shr $48,%r11
        and $0xffff,%r11

        mov %r8w,%r12w
        and $1,%r12w
        add %r12,%rax
        mov %r9w,%r13w
        and $1,%r13w
        add %r13,%rbx
        mov %r10w,%r14w
        and $1,%r14w
        add %r14,%rcx
        mov %r11w,%r15w
        and $1,%r15w
        add %r15,%rdx

.rept 15
        shr $1,%r8w
        mov %r8w,%r12w
        and $1,%r12w
        add %r12,%rax
        shr $1,%r9w
        mov %r9w,%r13w
        and $1,%r13w
        add %r13,%rbx
        shr $1,%r10w
        mov %r10w,%r14w
        and $1,%r14w
        add %r14,%rcx
        shr $1,%r11w
        mov %r11w,%r15w
        and $1,%r15w
        add %r15,%rdx
.endr

        add $8,%rdi
        dec %rsi
        jg 0b
        add %rbx,%rax
        add %rcx,%rax
        add %rdx,%rax
        pop %r15
        pop %r14
        pop %r13
        pop %r12
        pop %rbp
        pop %rbx
        ret

