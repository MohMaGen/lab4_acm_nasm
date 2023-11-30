extern map_iter
extern map_next
extern range_next
extern clone
extern sum


global calc_method
calc_method:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 72

    mov     [rbp - 8], rsi ; method function
    movsd   [rbp - 16], xmm0 ; divider

    lea     rsi, [rbp - 48] ; range 
    mov     rdx, qword 32
    call    clone

    lea     rdi, [rbp - 48]
    lea     rsi, [rel range_next]
    mov     rdx, [rbp - 8]
    lea     rcx, [rbp - 72]
    call    map_iter

    lea     rdi, [rbp - 72]
    lea     rsi, [rel map_next]
    call    sum

    movsd   xmm1, [rbp - 16]
    divsd   xmm0, xmm1
    movsd   xmm1, [rbp - 24]
    mulsd   xmm0, xmm1


    add     rsp, 72
    pop     rbp
    ret


extern function

global left_rects_func
left_rects_func:     call    function
    ret

global right_rects_func
right_rects_func:
    addsd   xmm0, xmm1
    call    function
    ret

global average_rects_func
average_rects_func:
    movsd   xmm2, qword [.half]
    mulsd   xmm1, xmm2
    addsd   xmm0, xmm1
    call    function
    ret
section .rodata
    .half: dq 0.5

section .text
global trapezoids_func
trapezoids_func:
    sub     rsp, 16
    movsd   [rsp], xmm0
    
    addsd   xmm0, xmm1
    call    function ; f(x + Dx)
    movsd   [rsp + 8], xmm0

    movsd   xmm0, [rsp]
    call    function  ; f(x)

    movsd   xmm1, [rsp + 8]
    addsd   xmm0, xmm1

    add     rsp, 16
    ret

global porabolas_func
global porabolas_func.divider
porabolas_func:
    sub     rsp, 32

    movsd   [rsp], xmm0
    movsd   [rsp + 8], xmm1

    call    function 
    movsd   [rsp + 16], xmm0

    movsd   xmm1, qword [rsp + 8]
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    movsd   [rsp + 24], xmm0

    movsd   xmm2, qword [.half]
    movsd   xmm1, qword [rsp + 8]
    mulsd   xmm1, xmm2
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function

    movsd   xmm1, qword [.four]
    mulsd   xmm0, xmm1

    movsd   xmm1, qword [rsp + 16]
    addsd   xmm0, xmm1

    movsd   xmm1, qword [rsp + 24]
    addsd   xmm0, xmm1

    add     rsp, 32
    ret
section .rodata
    .four:      dq 4.0
    .half:      dq 0.5
    .divider:   dq 6.0

section .text
global kotes_6_func
global kotes_6_func.divider
kotes_6_func:
    sub     rsp, 64

    movsd   [rsp], xmm0
    movsd   [rsp + 8], xmm1

    call    function
    movsd   xmm1, qword [.k1]
    mulsd   xmm0, xmm1
    movsd   [rsp + 16], xmm0

    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [.sixth]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    movsd   xmm1, qword [.k2]
    mulsd   xmm0, xmm1
    movsd   [rsp + 24], xmm0

    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [.third]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    movsd   xmm1, qword [.k3]
    mulsd   xmm0, xmm1
    movsd   [rsp + 32], xmm0

    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [.half]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    movsd   xmm1, qword [.k4]
    mulsd   xmm0, xmm1
    movsd   [rsp + 40], xmm0

    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [.tthird]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    movsd   xmm1, qword [.k3]
    mulsd   xmm0, xmm1
    movsd   [rsp + 48], xmm0


    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [.fsixth]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    movsd   xmm1, qword [.k2]
    mulsd   xmm0, xmm1
    movsd   [rsp + 56], xmm0


    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    movsd   xmm1, qword [.k1]
    mulsd   xmm0, xmm1

    movsd   xmm1, qword [rsp + 56]
    addsd   xmm0, xmm1

    movsd   xmm1, qword [rsp + 48]
    addsd   xmm0, xmm1

    movsd   xmm1, qword [rsp + 40]
    addsd   xmm0, xmm1

    movsd   xmm1, qword [rsp + 32]
    addsd   xmm0, xmm1

    movsd   xmm1, qword [rsp + 24]
    addsd   xmm0, xmm1

    movsd   xmm1, qword [rsp + 16]
    addsd   xmm0, xmm1
    
    add     rsp, 64
    ret

section .rodata
    .k1:        dq 41.0
    .k2:        dq 216.0
    .k3:        dq 27.0
    .k4:        dq 272.0
    .sixth:     dq 0.1666666666666666667
    .third:     dq 0.3333333333333333333
    .half:      dq 0.5
    .tthird:    dq 0.6666666666666666667
    .fsixth:    dq 0.8333333333333333333
    .divider:   dq 840.0



