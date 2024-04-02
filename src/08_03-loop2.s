# Do-while loops
.section .data
data:   .asciz "hello world"
n:      .quad 0
needle:  .byte 'w
.section .text
.global main
main:
        push %rbp
        mov %rsp, %rbp
        sub $16, %rsp
#       Register usage
#
#       rax: byte of data array
#       rbx: byte to search for
#       rcx: loop counter, 0-63
#
        mov needle,%bl
        xor %ecx,%ecx
        mov data(%rcx),%al
        cmp $0,%al
        jz end_while
while:
        cmp %al,%bl
        je found
        inc %rcx
        mov data(%rcx),%al
        cmp $0,%al
        jnz while
end_while:
        mov -1,%rcx
found:
        mov %rcx,n
        xor %eax,%eax
        leave
        ret

