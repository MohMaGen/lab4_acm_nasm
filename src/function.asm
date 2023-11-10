extern exp

default rel

section .rodata
    a: dq   -1.28
    b: dq   6.50
    c: dq   -1.44
    d: dq   -0.14

; x1 = -1,4;  x2 = 4,3.

global function
; warning! change xmm registers
section .text
function:
    addsd   xmm0, qword [c] ; x - c

    mulsd   xmm0, xmm0 ; (x-c)^2

    mulsd   xmm0, qword [d] ; -d * (x-c)^2

    call    exp wrt ..plt ; e^(-d * (x-c)^2)

    mulsd   xmm0, qword [a] ; a * e^(-d * (x-c)^2) 

    addsd   xmm0, qword [b] ; a * e^(-d * (x-c)^2) + b 

    ret
