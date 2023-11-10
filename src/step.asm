global calc_step
section .rodata
    minus_one:
        dq  -1.0

section .text
calc_step:
    movsd   xmm3, xmm0
    movsd   xmm0, qword [minus_one]
    mulsd   xmm0, xmm3
    addsd   xmm0, xmm1
    cvtsi2sd xmm1, rdi
    divsd   xmm0, xmm1
    ret

