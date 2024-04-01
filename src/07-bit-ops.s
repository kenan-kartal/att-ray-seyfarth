# Bit operation
.section .data
data:   .quad 0x12345678, 0x1, 0x2, 0x3, 0x4, 0x0, 0xa, 0xb, 0xc, 0xd
sample: .quad 0x12345678
field:  .quad 0
.section .text
.global main
main:
        push %rbp
        mov %rsp, %rbp
        sub $16, %rsp
        ### Not operation ###
        mov $0, %rax
        not %rax                # rax == 0xffffffffffffffff
        mov $0, %rdx            # prepare for divide
        mov $15, %rbx           # will divide by 15 (0xf)
        div %rbx                # unsigned divide
                                # rax == 0x1111111111111111
        not %rax                # rax == 0xeeeeeeeeeeeeeeee
        ### And operation ###
        mov $0x12345678, %rax
        mov %rax, %rbx
        and $0xf, %rbx          # rbx has the low nibble 0x8
        mov $0, %rdx            # prepare to divide
        mov $16, %rcx           # by 16
        idiv %rcx               # rax has 0x1234567
        and $0xf, %rax          # rax has the nibble 0x7
                                # NOTE: using divide to shift
                                # by 4 bits because shift ops
                                # are not introduced yet.
        ### Or operation ###
        mov $0x1000, %rax
        or $1, %rax             # make the number odd
        or $0xff00, %rax        # set bits 15-8
        ### Exclusive or operation ###
        mov $0x1234567812345678, %rax
        xor %eax, %eax          # set to 0
        mov $0x1234, %rax
        xor $0xf, %rax          # change to 0x123b
        ### Shift operations ###
        mov $0x12345678, %rax
        shr $8, %rax            # I want bits 8-15
        and $0xff, %rax         # rax now holds 0x56
        mov $0x12345678, %rax   # I want to replace bits 8-15
        mov $0xaa, %rdx         # rdx holds replacement field
        mov $0xff, %rbx         # I need an 8 bit mask
        shl $8, %rbx            # Shift mask to align @ bit 8
        not %rbx                # rbx is the inverted mask
        and %rbx, %rax          # Now bits 8-15 are all 0
        shl $8, %rdx            # shift the new bits to align
        or %rdx, %rax           # rax now has 0x1234aa78
        ### Bit testing and setting ###
        mov $8, %rax
        mov %rax, %rbx          # copy bit number to rbx
        shr $6, %rbx            # qword number of data to test
        mov %rax, %rcx          # copy bit number to rcx
        and $0x3f, %rcx         # extract rightmost 6 bits
        xor %edx, %edx          # set rdx to 0
        bt %rcx, data(,%rbx,8)  # test bit
        setc %dl                # edx equals the tested bit
        bts %rcx, data(,%rbx,8) # set the bit, insert into set
        btr %rcx, data(,%rbx,8) # clear the bit, remove
        ### Extracting and filling a bit field ###
        mov sample, %rax        # move quad-word into rax
        shr $23, %rax           # shift to aligh bit 23 at 0
        and $0x1fffffff, %rax   # select the 29 low bits
        mov %rax, field         # save the field
        mov sample, %rax        # move quad-word into rax
        ror $23, %rax           # rotate to align bit 23 at 0
        shr $29, %rax           # wipe out 29 bits
        shl $29, %rax           # move bits back into alignment
        or field, %rax          # trusting the field is 29 bits
        rol $23, %rax           # realign the bit fields
        mov %rax, sample        # store the fields in memory
        mov $0, %rax
        leave
        ret

