# Binary trees
# Binary tree node and tree structures
# node
.struct 0
n_val:
.struct n_val+8
n_lft:
.struct n_lft+8
n_rht:
.struct n_rht+8
.align 8
n_sz:
# tree
.struct 0
t_cnt:
.struct t_cnt+8
t_rt:
.struct t_rt+8
.align 8
t_sz:
# Creating an empty tree
.section .text
new_tree:
        push %rbp
        mov %rsp,%rbp
        mov $t_sz,%rdi
        call malloc
        xor %edi,%edi
        mov %rdi,t_rt(%rax)
        mov %rdi,t_cnt(%rax)
        leave
        ret
# Finding a key in a tree
#       p = find(t, n);
#       p = 0 if not found
.section .text
find:
        push %rbp
        mov %rsp,%rbp
        mov t_rt(%rdi),%rdi
        xor %eax,%eax
more1:  cmp $0,%rdi
        je done1
        cmp n_val(%rdi),%rsi
        jl lft1
        jg rht1
        mov %rsi,%rax
        jmp done1
lft1:   mov n_lft(%rdi),%rdi
        jmp more1
rht1:   mov n_rht(%rdi),%rdi
        jmp more1
done1:  leave
        ret
# Inserting a key into the tree
#       insert(t, n);
.section .text
insert:
        .equ n1,0
        .equ t1,8
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
        mov %rdi,t1(%rsp)
        mov %rsi,n1(%rsp)
        call find
        cmp $0,%rax
        jne done2
        mov $n_sz,%rdi
        call malloc
        mov n1(%rsp),%rsi
        mov %rsi,n_val(%rax)
        xor %edi,%edi
        mov %rdi,n_lft(%rax)
        mov %rdi,n_rht(%rax)
        mov t1(%rsp),%rdx
        mov t_cnt(%rdx),%rdi
        cmp $0,%rdi
        jne parent
        inc t_cnt(%rdx)
        mov %rax,t_rt(%rdx)
        jmp done2
parent: mov t_rt(%rdx),%rdx
rptfnd: cmp n_val(%rdx),%rsi
        jl lft2
        jg rht2
        mov %rdx,%r8
        mov n_rht(%r8),%rdx
        cmp $0,%rdx
        jne rptfnd
        mov %rax,n_rht(%r8)
        jmp done2
lft2:   mov %rdx,%r8
        mov n_lft(%r8),%rdx
        cmp $0,%rdx
        jne rptfnd
        mov %rax,n_lft(%r8)
        jmp done2
rht2:   mov %rdx,%r8
        mov n_rht(%r8),%rdx
        cmp $0,%rdx
        jne rptfnd
        mov %rax,n_rht(%r8)
done2:  leave
        ret
# Printing the keys in order
.section .text
rec_print:
        .equ t2,0
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
        cmp $0,%rdi
        je done3
        mov %rdi,t2(%rsp)
        mov n_lft(%rdi),%rdi
        call rec_print
        mov t2(%rsp),%rdi
        mov n_val(%rdi),%rsi
.section .data
pfmt:   .asciz "%ld "
.section .text
        lea pfmt,%rdi
        call printf
        mov t2(%rsp),%rdi
        mov n_rht(%rsp),%rdi
        call rec_print
done3:  leave
        ret
#       print(t)
print:
        push %rbp
        mov %rsp,%rbp
        mov t_rt(%rdi),%rdi
        call rec_print
.section .data
nl:     .asciz "\n"
.section .text
        lea pfmt,%rdi
        call printf
        leave
        ret

