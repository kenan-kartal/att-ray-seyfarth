.section .data
format:
        .asciz "%s\n"
.section .text
.global main                    # let the linker know about main
main:
        push %rbp               # prepare stack frame for main
        mov %rsp,%rbp
        sub $16,%rsp
        mov %rsi,%rcx           # move argv to rcx
        mov (%rcx),%rsi         # get first argv string
start_loop:
        lea format,%rdi
        mov %rcx,(%rsp)         # save argv
        call printf
        mov (%rsp),%rcx         # restore rsi
        add $8,%rcx             # advance to next pointer in argv
        mov (%rcx),%rsi         # get next argv string
        cmp $0,%rsi
        jnz start_loop          # end with NULL pointer
end_loop:
        xor %eax,%eax
        leave
        ret

