# Computing Correlation
# Implementation using SSE instructions
.section .text
.global corr

#       rdi: x array
#       rsi: y array
#       rcx: loop counter
#       rdx: n
#       xmm0: 2 parts of sum_x
#       xmm1: 2 parts of sum_y
#       xmm2: 2 parts of sum_xx
#       xmm3: 2 parts of sum_yy
#       xmm4: 2 parts of sum_xy
#       xmm5: 2 x values - later squared
#       xmm6: 2 y values - later squared
#       xmm7: 2 xy values
corr:
        xor %r8,%r8
        mov %rdx,%rcx
        movapd %xmm0,%xmm1
        movapd %xmm0,%xmm2
        movapd %xmm0,%xmm3
        movapd %xmm0,%xmm4
        movapd %xmm0,%xmm8
        movapd %xmm0,%xmm9
        movapd %xmm0,%xmm10
        movapd %xmm0,%xmm11
        movapd %xmm0,%xmm12
0:
        movapd (%rdi,%r8),%xmm5         # mov x
        movapd (%rsi,%r8),%xmm6         # mov y
        movapd %xmm5,%xmm7              # mov x
        mulpd %xmm6,%xmm7               # xy
        addpd %xmm5,%xmm0               # sum_x
        addpd %xmm6,%xmm1               # sum_y
        mulpd %xmm5,%xmm5               # xx
        mulpd %xmm6,%xmm6               # yy
        addpd %xmm5,%xmm2               # sum_xx
        addpd %xmm6,%xmm3               # sum_yy
        addpd %xmm7,%xmm4               # sum_xy
        movapd 16(%rdi,%r8),%xmm13      # mov x
        movapd 16(%rsi,%r8),%xmm14      # mov y
        movapd %xmm13,%xmm15            # mov x
        mulpd %xmm14,%xmm15             # xy
        addpd %xmm13,%xmm8              # sum_x
        addpd %xmm14,%xmm9              # sum_y
        mulpd %xmm13,%xmm13             # xx
        mulpd %xmm14,%xmm14             # yy
        addpd %xmm13,%xmm10             # sum_xx
        addpd %xmm14,%xmm11             # sum_yy
        addpd %xmm15,%xmm12             # sum_xy
        add $32,%r8
        sub $4,%rcx
        jnz 0b
        addpd %xmm8,%xmm0
        addpd %xmm9,%xmm1
        addpd %xmm10,%xmm2
        addpd %xmm11,%xmm3
        addpd %xmm12,%xmm4
        haddpd %xmm0,%xmm0              # sum_x
        haddpd %xmm1,%xmm1              # sum_y
        haddpd %xmm2,%xmm2              # sum_xx
        haddpd %xmm3,%xmm3              # sum_yy
        haddpd %xmm4,%xmm4              # sum_xy
        movsd %xmm0,%xmm6               # sum_x
        movsd %xmm1,%xmm7               # sum_y
        cvtsi2sd %rdx,%xmm8             # n
        mulsd %xmm6,%xmm6               # sum_x^2
        mulsd %xmm7,%xmm7               # sum_y^2
        mulsd %xmm8,%xmm2               # n*sum_xx
        mulsd %xmm8,%xmm3               # n*sum_yy
        subsd %xmm6,%xmm2               # n*sum_xx-sum_x^2
        subsd %xmm7,%xmm3               # n*sum_yy-sum_y^2
        mulsd %xmm3,%xmm2               # denom_x*denom_y
        sqrtsd %xmm2,%xmm2              # denom
        mulsd %xmm8,%xmm4               # n*sum_xy
        mulsd %xmm1,%xmm0               # sum_x*sum_y
        subsd %xmm0,%xmm4               # n*sum_xy-sum_x*sum_y
        divsd %xmm2,%xmm4               # correlation
        movsd %xmm4,%xmm0               # need in xmm0
        ret

