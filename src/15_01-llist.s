# Linked list
# List node structure
.struct 0
n_val:
.struct n_val+8
n_nxt:
.struct n_nxt+8
.align 8
n_sz:
# Creating an empty list
.section .text
newlist:
        xor %eax,%eax
        ret
# Inserting a number into a list
#       list = insert(list, k);
.section .text
insert:
        .equ list, 0
        .equ k, 8
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
        mov %rdi,list(%rsp)     # save list pointer
        mov %rsi,k(%rsp)        # and k on stack
        mov $n_sz,%edi
        call malloc             # rax will be node pointer
        mov list(%rsp),%r8      # get list pointer
        mov %r8,n_nxt(%rax)     # save pointer in node
        mov k(%rsp),%r9         # get k
        mov %r9,n_val(%rax)     # save k in node
        leave
        ret
# Traversing the list
.section .data
fmt:    .asciz "%ld "
nl:     .asciz "\n"
.section .text
print:
        .equ olrbx, 0
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp            # subtract multiples of 16
        mov %rbx,olrbx(%rsp)    # save old value of rbx
        cmp $0,%rdi
        je done
        mov %rdi,%rbx
more:   lea fmt,%rdi
        mov n_val(%rbx),%rsi
        xor %eax,%eax
        call printf
        mov n_nxt(%rbx),%rbx
        cmp $0,%rbx
        jne more
done:   lea nl,%rdi
        xor %eax,%eax
        call printf
        mov olrbx(%rsp),%rbx    # restore rbx
        leave
        ret
# main
.section .data
sfmt:   .asciz "%ld"
.section .text
.global main
main:
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
        call newlist
        mov %rax,list(%rsp)
more2:  lea sfmt,%rdi
        lea k(%rsp),%rsi
        xor %eax,%eax
        call scanf
        cmp $1,%rax
        jne done2
        mov list(%rsp),%rdi
        mov k(%rsp),%rsi
        call insert
        mov %rax,list(%rsp)
        mov %rax,%rdi
        call print
        jmp more2
done2:  xor %eax,%eax
        leave
        ret

