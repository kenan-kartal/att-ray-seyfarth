# Doubly-linked list node structure
.struct 0
n_val:
.struct n_val+8
n_nxt:
.struct n_nxt+8
n_prv:
.struct n_prv+8
.align 8
n_sz:
# Creating a new list
#       list = newlist();
.section .text
newlist:
        push %rbp
        mov %rsp,%rbp
        mov n_sz,%edi
        call malloc
        mov %rax,n_nxt(%rax)
        mov %rax,n_prv(%rax)
        leave
        ret
# Inserting at the front of the list
#       insert(list, k);
.section .text
insert:
        .equ list1,0
        .equ k1,8
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
        mov %rdi,list1(%rsp)    # save list pointer
        mov %rsi,k1(%rsp)       # and k on stack
        mov n_sz,%edi
        call malloc             # rax will be node pointer
        mov list1(%rsp),%r8     # get list pointer
        mov n_nxt(%r8),%r9      # get head's next
        mov %r9,n_nxt(%rax)     # set new node's next
        mov %r8,n_prv(%rax)     # set new node's prev
        mov %rax,n_nxt(%r8)     # set head's next
        mov %rax,n_prv(%r9)     # set new node's next's prev
        mov k1(%rsp),%r9        # get k
        mov %r9,n_val(%rax)     # save k in node
        leave
        ret
# List traversal
#       print(list);
.section .data
pfmt:   .asciz "%ld "
nl:     .asciz "\n"
.section .text
print:
        .equ list2,0
        .equ olrbx,8
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
        mov %rbx,olrbx(%rsp)
        mov %rdi,list2(%rsp)
        mov n_nxt(%rdi),%rbx
        cmp list2(%rsp),%rbx
        je done1
more1:  lea pfmt,%rdi
        mov n_val(%rbx),%rsi
        call printf
        mov n_nxt(%rbx),%rbx
        cmp list(%rbx),%rbx
        jne more1
done1:  lea nl,%rdi
        call printf
        mov olrbx(%rbx),%rbx
        leave
        ret

