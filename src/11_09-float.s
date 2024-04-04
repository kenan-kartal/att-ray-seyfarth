# Floats
# Distance in 3D
.section .text
distance3d:
        movss (%rdi),%xmm0              # x from first point
        subss (%rsi),%xmm0              # subtract x from second point
        mulss %xmm0,%xmm0               # (x1-x2)^2
        movss 4(%rdi),%xmm1             # y from first point
        subss 4(%rsi),%xmm1             # subtract y from second point
        mulss %xmm1,%xmm1               # (y1-y2)^2
        movss 8(%rdi),%xmm2             # z from first point
        subss 8(%rsi),%xmm2             # subtract z from second point
        mulss %xmm2,%xmm2               # (z1-z2)^2
        addss %xmm1,%xmm0               # add x and y parts
        addss %xmm2,%xmm0               # add z part
        sqrtss %xmm0,%xmm0
        ret
# Dot product of 3D vectors
dot_product:
        movss (%rdi),%xmm0
        mulss (%rsi),%xmm0
        movss 4(%rdi),%xmm1
        mulss 4(%rsi),%xmm1
        addss %xmm1,%xmm0
        movss 8(%rdi),%xmm2
        mulss 8(%rsi),%xmm2
        addss %xmm2,%xmm0
        ret
# Polynomial evaluation
horner:
        movsd   %xmm0,%xmm1             # use xmm1 as x
        movsd (%rdi,%rsi,8),%xmm0       # accumulator for b_k
        cmp $0,%esi                     # is the degree 0?
        jz done
more:
        sub $1,%esi
        mulsd %xmm1,%xmm0               # b_k*x
        addsd (%rdi,%rsi,8),%xmm0       # add p_k
        jnz more
done:
        ret

