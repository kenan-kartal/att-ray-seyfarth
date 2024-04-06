# Hash tables
# A good hash function for integers
#       i = hash(n);
.section .text
hash:
        mov %rdi,%rax
        and $0xff,%rax
        ret
# Hash table node structure and array
.section .data
table:
        .ds.d 256
.struct 0
n_val:
.struct n_val+8
n_nxt:
.struct n_nxt+8
.align 8
n_sz:
# Function to find a value in the hash table
#       p = find(n);
#       p = 0 if not found
.section .text
find:
        .equ n1,0
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
        mov %rdi,n1(%rsp)
        call hash
        mov table(,%rax,8),%rax
        mov n1(%rsp),%rdi
        cmp $0,%rax
        je done1
more1:  cmp n_val(%rax),%rdi
        je done1
        mov n_nxt(%rax),%rax
        cmp $0,%rax
        jne more1
done1:  leave
        ret
# Insertion code
#       insert(n);
.section .text
insert:
        .equ n2,0
        .equ h2,8
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
        mov %rdi,n2(%rsp)
        call find
        cmp $0,%rax
        jne found2
        mov n2(%rsp),%rdi
        call hash
        mov %rax,h2(%rsp)
        mov $n_sz,%rdi
        call malloc
        mov h2(%rsp),%r9
        mov table(,%r9,8),%r8
        mov %r8,n_nxt(%rax)
        mov n2(%rsp),%r8
        mov %r8,n_val(%rax)
        mov %rax,table(,%r9,8)
found2: leave
        ret
# Printing the hash table
.section .text
print:
        push %rbp
        mov %rsp,%rbp
        push %r12               # i: integer counter for table
        push %r13               # p: pointer for list at table[i]
        xor %r12,%r12
mrtbl3: mov table(,%r12,8),%r13
        cmp $0,%r13
        je empty3
.section .data
fmtlst: .asciz "list %3d: "
.section .text
        lea fmtlst,%rdi
        mov %r12,%rsi
        call printf
mrlst3:
.section .data
fmtitm: .asciz "%ld "
.section .text
        lea fmtitm,%rdi
        mov n_val(%r13),%rsi
        call printf
        mov n_nxt(%r13),%r13
        cmp $0,%r13
        jne mrlst3
.section .data
nl:     .asciz "\n"
.section .text
        lea nl,%rdi
        call printf
empty3: inc %r12
        cmp $256,%r12
        jl mrtbl3
        pop %r13
        pop %r12
        leave
        ret
# Testing the hash table
.section .text
.global main
main:
        .equ k4,0
.section .data
sfmt:   .asciz "%ld"
.section .text
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
more4:  lea sfmt,%rdi
        lea k4(%rsp),%rsi
        call scanf
        cmp $1,%rax
        jne done4
        mov k4(%rsp),%rdi
        call insert
        call print
        jmp more4
done4:  xor %eax,%eax
        leave
        ret

