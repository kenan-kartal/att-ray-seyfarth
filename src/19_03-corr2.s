# Computing Correlation
# Implementation using AVX instructions
.section .text
.global corr

#       rdi: x array
#       rsi: y array
#       rcx: loop counter
#       rdx: n
#       ymm0: 4 parts of sum_x
#       ymm1: 4 parts of sum_y
#       ymm2: 4 parts of sum_xx
#       ymm3: 4 parts of sum_yy
#       ymm4: 4 parts of sum_xy
#       ymm5: 4 x values - later squared
#       ymm6: 4 y values - later squared
#       ymm7: 4 xy values
corr:
        xor %r8,%r8
        mov %rdx,%rcx
        vzeroall
0:
        vmovupd (%rdi,%r8),%ymm5        # mov x
        vmovupd (%rsi,%r8),%ymm6        # mov y
        vmulpd %ymm6,%ymm5,%ymm7        # xy
        vaddpd %ymm5,%ymm0,%ymm0        # sum_x
        vaddpd %ymm6,%ymm1,%ymm1        # sum_y
        vmulpd %ymm5,%ymm5,%ymm5        # xx
        vmulpd %ymm6,%ymm6,%ymm6        # yy
        vaddpd %ymm5,%ymm2,%ymm2        # sum_xx
        vaddpd %ymm6,%ymm3,%ymm3        # sum_yy
        vaddpd %ymm7,%ymm4,%ymm4        # sum_xy
        vmovupd 32(%rdi,%r8),%ymm13     # mov x
        vmovupd 32(%rsi,%r8),%ymm14     # mov y
        vmulpd %ymm14,%ymm13,%ymm15     # xy
        vaddpd %ymm13,%ymm8,%ymm8       # sum_x
        vaddpd %ymm14,%ymm9,%ymm9       # sum_y
        vmulpd %ymm13,%ymm13,%ymm13     # xx
        vmulpd %ymm14,%ymm14,%ymm14     # yy
        vaddpd %ymm13,%ymm10,%ymm10     # sum_xx
        vaddpd %ymm14,%ymm11,%ymm11     # sum_yy
        vaddpd %ymm15,%ymm12,%ymm12     # sum_xy
        add $64,%r8
        sub $8,%rcx
        jnz 0b
        vaddpd %ymm8,%ymm0,%ymm0
        vaddpd %ymm9,%ymm1,%ymm1
        vaddpd %ymm10,%ymm2,%ymm2
        vaddpd %ymm11,%ymm3,%ymm3
        vaddpd %ymm12,%ymm4,%ymm4
        vhaddpd %ymm0,%ymm0,%ymm0       # sum_x
        vhaddpd %ymm1,%ymm1,%ymm1       # sum_y
        vhaddpd %ymm2,%ymm2,%ymm2       # sum_xx
        vhaddpd %ymm3,%ymm3,%ymm3       # sum_yy
        vhaddpd %ymm4,%ymm4,%ymm4       # sum_xy
        vextractf128 $1,%ymm0,%xmm5
        vaddsd %xmm5,%xmm0,%xmm0
        vextractf128 $1,%ymm1,%xmm6
        vaddsd %xmm6,%xmm1,%xmm1
        vmulsd %xmm0,%xmm0,%xmm6        # sum_x^2
        vmulsd %xmm1,%xmm1,%xmm7        # sum_y^2
        vextractf128 $1,%ymm2,%xmm8
        vaddsd %xmm8,%xmm2,%xmm2
        vextractf128 $1,%ymm3,%xmm9
        vaddsd %xmm9,%xmm3,%xmm3
        cvtsi2sd %rdx,%xmm8             # n
        vmulsd %xmm8,%xmm2,%xmm2        # n*sum_xx
        vmulsd %xmm8,%xmm3,%xmm3        # n*sum_yy
        vsubsd %xmm6,%xmm2,%xmm2        # n*sum_xx-sum_x^2
        vsubsd %xmm7,%xmm3,%xmm3        # n*sum_yy-sum_y^2
        vmulsd %xmm3,%xmm2,%xmm2        # denom*denom
        vsqrtsd %xmm2,%xmm2,%xmm2       # denom
        vextractf128 $1,%ymm4,%xmm6
        vaddsd %xmm6,%xmm4,%xmm4
        vmulsd %xmm8,%xmm4,%xmm4        # n*sum_xy
        vmulsd %xmm1,%xmm0,%xmm0        # sum_x*sum_y
        vsubsd %xmm0,%xmm4,%xmm4        # n*sum_xy-sum_x*sum_y
        vdivsd %xmm2,%xmm4,%xmm0        # correlation
        ret

