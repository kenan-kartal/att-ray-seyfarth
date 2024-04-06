# Sobel computed using SSE instructions

# Macro to push and pop multiple registers.
# Used for callee save registers.
.macro multipush arg:req, rem:vararg
        push \arg
        .ifb \rem
        .exitm
        .endif
        multipush \rem
.endm
.macro multipop arg:req, rem:vararg
        .ifb \rem
        .else
        multipop \rem
        .endif
        pop \arg
.endm

#       sobe(input, output, rows, cols);
#       char input[rows][cols]
#       float output[rows][cols]
#       boundary of the output array will be unfilled
#
.section .text
.global sobel
.global main
sobel:
        .equ cols,0
        .equ rows,8
        .equ output,16
        .equ input,24
        .equ bpir,32
        .equ bpor,40
        multipush %rbx,%rbp,%r12,%r13,%r14,%r15
        sub $48,%rsp
        cmp $3,%rdx
        jl noworktodo
        cmp $3,%rcx
        jl noworktodo
        mov %rdi,input(%rsp)
        mov %rsi,output(%rsp)
        mov %rdx,rows(%rsp)
        mov %rcx,cols(%rsp)
        mov %rcx,bpir(%rsp)
        imul $4,%rcx
        mov %rcx,bpor(%rsp)

        mov rows(%rsp),%rax             # count of rows to process
        mov cols(%rsp),%rdx
        sub $2,%rax
        mov input(%rsp),%r8
        add %rdx,%r8
        mov %r8,%r9                     # address of row
        mov %r8,%r10
        sub %rdx,%r8                    # address of row-1
        add %rdx,%r10                   # address of row+1
        pxor %xmm13,%xmm13
        pxor %xmm14,%xmm14
        pxor %xmm15,%xmm15
more_rows:
        mov $1,%rbx                     # first column to process
more_cols:
        movdqu -1(%r8,%rbx),%xmm0       # data for 1st row of 3
        movdqu %xmm0,%xmm1
        movdqu %xmm0,%xmm2
        pxor %xmm9,%xmm9
        pxor %xmm10,%xmm10
        pxor %xmm11,%xmm11
        pxor %xmm12,%xmm12
        psrldq $1,%xmm1                 # shift the pixels 1 to the right
        psrldq $2,%xmm2                 # shift the pixels 2 to the right
                                        # Now the lowest 14 values of
                                        # xmm0, xmm1 and xmm2 are lined
                                        # up properly for applying the
                                        # top row of the 2 matrices.
        movdqa %xmm0,%xmm3
        movdqa %xmm1,%xmm4
        movdqa %xmm2,%xmm5
        punpcklbw %xmm13,%xmm3          # The low 8 values are now words
        punpcklbw %xmm14,%xmm4          # in registers xmm3, xmm4 and
        punpcklbw %xmm15,%xmm5          # xmm5 - ready for arithmetic.
        psubw %xmm3,%xmm11              # xmm11 will hold 8 values of Gx
        psubw %xmm3,%xmm9               # xmm9 will hold 8 values of Gy
        paddw %xmm5,%xmm11              # Gx subtracts left, adds right
        psubw %xmm4,%xmm9               # Gy subracts 2 * middle pixel
        psubw %xmm4,%xmm9
        psubw %xmm5,%xmm9               # Final subtraction for Gy
        punpckhbw %xmm13,%xmm0          # Convert top 8 bytes to words
        punpckhbw %xmm14,%xmm1
        punpckhbw %xmm15,%xmm2
        psubw %xmm0,%xmm12              # Perform the same arithmetic
        psubw %xmm0,%xmm10              # storing these 6 values in
        paddw %xmm2,%xmm12              # xmm12 and xmm10
        psubw %xmm1,%xmm10
        psubw %xmm1,%xmm10
        psubw %xmm2,%xmm10

        movdqu -1(%r9,%rbx),%xmm0       # data for 2nd row of 3
        movdqu %xmm0,%xmm2              # repeat math from 1st row
        psrldq $2,%xmm2                 # with nothing added to Gy
        movdqa %xmm0,%xmm3
        movdqa %xmm2,%xmm5
        punpcklbw %xmm13,%xmm3
        punpcklbw %xmm15,%xmm5          # 8 values for 1st row
        psubw %xmm3,%xmm11
        psubw %xmm3,%xmm11
        paddw %xmm5,%xmm11
        paddw %xmm5,%xmm11
        punpckhbw %xmm13,%xmm0
        punpckhbw %xmm15,%xmm2
        psubw %xmm0,%xmm12
        psubw %xmm0,%xmm12
        paddw %xmm2,%xmm12
        paddw %xmm2,%xmm12

        movdqu -1(%r10,%rbx),%xmm0      # data for 3rd row of 3
        movdqu %xmm0,%xmm1
        movdqu %xmm0,%xmm2
        psrldq $1,%xmm1
        psrldq $2,%xmm2
        movdqa %xmm0,%xmm3
        movdqa %xmm1,%xmm4
        movdqa %xmm2,%xmm5
        punpcklbw %xmm13,%xmm3
        punpcklbw %xmm14,%xmm4
        punpcklbw %xmm15,%xmm5          # 8 values for 3rd row
        psubw %xmm3,%xmm11
        paddw %xmm3,%xmm9
        paddw %xmm5,%xmm11
        paddw %xmm4,%xmm9
        paddw %xmm4,%xmm9
        paddw %xmm5,%xmm9
        punpckhbw %xmm13,%xmm0
        punpckhbw %xmm14,%xmm1
        punpckhbw %xmm15,%xmm2
        psubw %xmm0,%xmm12
        paddw %xmm0,%xmm10
        paddw %xmm2,%xmm12
        paddw %xmm1,%xmm10
        paddw %xmm1,%xmm10
        paddw %xmm2,%xmm10

        pmullw %xmm9,%xmm9              # square Gx and Gy values
        pmullw %xmm10,%xmm10
        pmullw %xmm11,%xmm11
        pmullw %xmm12,%xmm12
        paddw %xmm11,%xmm9              # sum of squares
        paddw %xmm12,%xmm10
        movdqa %xmm9,%xmm1
        movdqa %xmm10,%xmm3
        punpcklwd %xmm13,%xmm9          # Convert low 4 words to dwords
        punpckhwd %xmm13,%xmm1          # Convert high 4 words to dwords
        punpcklwd %xmm13,%xmm10         # Convert low 4 words to dwords
        punpckhwd %xmm13,%xmm3          # Convert high 4 words to dwords
        cvtdq2ps %xmm9,%xmm0            # Convert to floating point
        cvtdq2ps %xmm1,%xmm1            # Convert to floating point
        cvtdq2ps %xmm10,%xmm2           # Convert to floating point
        cvtdq2ps %xmm3,%xmm3            # Convert to floating point
        sqrtps %xmm0,%xmm0              # Take sqrt to get magnitude
        sqrtps %xmm1,%xmm1              # Take sqrt to get magnitude
        sqrtps %xmm2,%xmm2              # Take sqrt to get magnitude
        sqrtps %xmm3,%xmm3              # Take sqrt to get magnitude
        movups %xmm0,(%rsi,%rbx,4)
        movups %xmm1,16(%rsi,%rbx,4)
        movups %xmm2,32(%rsi,%rbx,4)
        movlps %xmm3,48(%rsi,%rbx,4)

        add $14,%rbx                    # process 14 Sobel values
        cmp %rdx,%rbx
        jl more_cols
        add %rdx,%r8
        add %rdx,%r9
        add %rdx,%r10
        add bpor(%rsp),%rsi
        sub $1,%rax                     # 1 fewer row to process
        cmp $0,%rax
        jg more_rows
noworktodo:
        add $48,%rsp
        multipop %rbx,%rbp,%r12,%r13,%r14,%r15
        ret

