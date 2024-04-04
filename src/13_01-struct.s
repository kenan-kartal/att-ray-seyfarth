# Struct
.struct 0
c_id:
.struct c_id+4
c_name:
.struct c_name+64
c_addr:
.struct c_addr+64
c_baln:
.struct c_baln+1
c_size:
.section .data
name:
        .asciz "Calvin"
addr:
        .asciz "12 Mockingbird Lane"
baln:
        .int 12500
c:
        .double 0
.section .text
.global main
main:
        push %rbp
        mov %rsp,%rbp
        sub $32,%rsp
        mov $c_size,%rdi
        call malloc
        mov %rax,c              # save the pointer
        mov $7,c_id(%rax)
        lea c_name(%rax),%rdi
        mov $name,%rsi
        call strcpy
        mov c,%rax              # restore the pointer
        lea c_addr(%rax),%rdi
        mov $addr,%rsi
        call strcpy
        mov c,%rax              # restore the pointer
        mov baln,%edx
        mov %edx,c_baln(%rax)
        xor %eax,%eax
        leave
        ret

