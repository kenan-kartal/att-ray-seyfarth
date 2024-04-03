# Recursion
.section .data
x:      .quad 0
scanf_format:
        .asciz "%ld"
printf_format:
        .asciz "fact(%ld) = %ld\n"
.section .text
.global main                    # tell linker about main
.global fact                    # tell world about fact
main:
        push %rbp
        mov %rsp,%rbp
        lea scanf_format,%rdi   # set arg 1 for scanf
        lea x,%rsi              # set arg 2 for scanf
        xor %eax,%eax           # set rax to 0
        call scanf
        mov x,%rdi              # move x for fact call
        call fact
        lea printf_format,%rdi  # set arg 1 for printf
        mov x,%rsi              # set arg 2 for printf
        mov %rax,%rdx           # set arg 3 to be x!
        xor %eax,%eax           # set rax to 0
        call printf
        xor %eax,%eax           # set return value to 0
        leave
        ret
fact:                           # recursive function
.equ n, 8
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp            # make room for storing n
        cmp $1,%rdi             # compare argument with 1
        jg greater              # if n <= 1, return 1
        mov $1,%eax             # set return value to 1
        leave
        ret
greater:
        mov %rdi,n(%rsp)        # save n
        dec %rdi                # call facto with n-1
        call fact
        mov n(%rsp),%rdi        # restore original n
        imul %rdi,%rax          # multiply fact(n-1)*n
        leave
        ret

