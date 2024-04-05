# C stream I/O functions
# Opening a file
.section .data
name:   .asciz "customers.dat"
mode:   .asciz "w+"
fp:     .quad 0
.section .text
        mov $name,%rdi
        mov $mod,%rsi
        call fopen
        mov %rax,fp
# fgetc and fputc
.section .data
ifp:    .quad 0
ofp:    .quad 0
more:
        mov ifp,%rdi            # input file pointer
        call fgetc
        cmp $-1,%eax
        je done
        mov %rax,%rdi
        mov ofp,%rsi            # output file pointer
        call fputc
        jmp more
done:
# fgets and fputs
.section .data
s:      .dcb.b 200
.section .text
more2:
        lea s, %rdi
        mov $200,%esi
        mov ifp,%rdx
        call fgets
        cmp $0,%rax
        je done2
        mov s,%al
        cmp ';,%al
        je more2
        lea s,%rdi
        mov ofp,%rsi
        call fputs
        jmp more2
done2:
# fread and fwrite
.section .data
customers:
        .dcb.b 100*10
customer_size:
        .int 10
.section .text
        mov customers,%rdi
        mov customer_size,%esi
        mov $100,%edx
        mov fp,%rcx
        call fwrite
# fseek and ftell
#       void write_customer(FILE *fp, struct Customer *c,
#                               int record_number);
.section .text
.global write_customer
write_customer:
        .equ .fp,0
        .equ .c,8
        .equ .rec,16
        push %rbp
        mov %rsp,%rbp
        sub $32,%rsp
        mov %rdi,.fp(%rsp)      # save parameters
        mov %rsi,.c(%rsp)
        mov %rdx,.rec(%rsp)
        imul customer_size,%rdx
        mov %rdx,%rsi           # 2nd parameter to ftell
        mov $0,%rdx             # whence
        call ftell
        mov .c(%rsp),%rdi
        mov customer_size,%rsi
        mov $1,%rdx
        mov .fp(%rsp),%rcx
        call fwrite
        leave
        ret

