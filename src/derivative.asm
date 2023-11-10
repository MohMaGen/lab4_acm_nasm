global derivative

section .rodata
    minus_one:
        dq -1.0
    half:
        dq 0.5

section .text
derivative:
    sub     rsp, 32
    movsd   [rsp], xmm0 ; error
    movsd   [rsp + 8], xmm1 ; x 
    mov     [rsp + 16], rdi ; function

    movsd   xmm0, [rsp + 8]
    addsd   xmm0, [rsp]
    call    [rsp + 16] 
    movsd   [rsp + 24], xmm0 ; [rsp + 24] = f(x + e)


    movsd   xmm0, [rsp]
    mulsd   xmm0, [minus_one]
    addsd   xmm0, [rsp + 8]
    call    [rsp + 16] ; xmm0 = f(x - e)

    mulsd   xmm0, [minus_one] ; xmm0 = -f(x - e)

    addsd   xmm0, [rsp + 24] ; xmm0 = f(x + e) - f(x - e)
    mulsd   xmm0, [half] ; xmm0 = (f(x+e) - f(x-e)) / 2
    divsd   xmm0, [rsp] ; xmm0 = (f(x+e) - f(x-e)) / (2 * e)

    add     rsp, 32
    ret



