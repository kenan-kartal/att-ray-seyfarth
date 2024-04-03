.section .text
#       array=create(size);
create:
        push %rbp
        mov %rsp,%rbp
        imul $4,%rdi
        call malloc
        leave
        ret
#       fill(array,size);
fill:
        .equ array,0
        .equ size,8
        .equ i,16
        push %rbp
        mov %rsp,%rbp
        sub $32,%rsp
        mov %rdi,array(%rsp)
        mov %rsi,size(%rsp)
        xor %ecx,%ecx
0: # more
        mov %rcx,i(%rsp)
        call random
        mov i(%rsp),%rcx
        mov array(%rsp),%rdi
        mov %eax,(%rdi,%rcx,4)
        inc %rcx
        cmp size(%rsp),%rcx
        jl 0b # more
        leave
        ret
#       print(array,size)
print:
        .equ array,0
        .equ size,8
        .equ i,16
        push %rbp
        mov %rsp,%rbp
        sub $32,%rsp
        mov %rdi,array(%rsp)
        mov %rsi,size(%rsp)
        xor %ecx,%ecx
        mov %rcx,i(%rsp)
.section .data
format:
        .asciz "%10d\n"
.section .text
0: # more
        lea format,%rdi
        mov array(%rsp),%rdx
        mov i(%rsp),%rcx
        mov (%rdx,%rcx,4),%esi
        mov %rcx,i(%rsp)
        call printf
        mov i(%rsp),%rcx
        inc %rcx
        mov %rcx,i(%rsp)
        cmp size(%rsp),%rcx
        jl 0b # more
        leave
        ret
#       x=min(array,size)
min:
        mov %rdi,%rax
        mov $1,%rcx
0: # more
        mov (%rdi,%rcx,4),%r8d
        cmp %eax,%r8d
        cmovl %r8d,%eax
        inc %rcx
        cmp %rsi,%rcx
        jl 0b # more
        ret
#       main
.global main
main:
        .equ array,0
        .equ size,8
        push %rbp
        mov %rsp,%rbp
        sub $16,%rsp
#       set default size
        mov $10,%ecx
        mov %rcx,size(%rsp)
#       check for argv[1] providing a size
        cmp $2,%edi
        jl 0f #nosize
        mov 8(%rsi),%rdi
        call atoi
        mov %rax,size(%rsp)
0: # nosize
#       create the array
        mov size(%rsp),%rdi
        call create
        mov %rax,array(%rsp)
#       fill the array with random numbers
        mov %rax,%rdi
        mov size(%rsp),%rsi
        call fill
#       if size<=20 print the array
        mov size(%rsp),%rsi
        cmp $20,%rsi
        jg 1f # too big
        mov array(%rsp),%rdi
        call print
1: # too big
#       print the minimum
.section .data
format2:
        .asciz "min %ld\n"
.section .text
        mov array(%rsp),%rdi
        mov size(%rsp),%rsi
        call min
        lea format2,%rdi
        mov %rax,%rsi
        call printf
        xor %eax,%eax           # NOTE: Adding this so program succeeds
                                #       as far as shell is concerned.
        leave
        ret

