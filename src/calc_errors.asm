extern fopen
extern fclose
extern fprintf
extern calc_method
extern calc_method
extern left_rects_func
extern average_rects_func
extern trapezoids_func
extern porabolas_func
extern porabolas_func.divider
extern kotes_6_func
extern kotes_6_func.divider
extern fabs
extern clone


global calc_errors
calc_errors:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 64

    mov     [rbp - 8], rdi

    
    lea     rdi, [rel file.path]
    lea     rsi, [rel file.mod]
    call    fopen
    mov     [rbp - 16], rax

    mov     rdi, [rbp - 8]
    lea     rsi, [rbp - 48]
    mov     rdx, qword 32
    call    clone


    lea     rdi, [rbp - 48]
    lea     rsi, [rel kotes_6_func]
    movsd   xmm0, qword [kotes_6_func.divider]
    call    calc_method
    movsd   [rbp - 56], xmm0


    lea     rdi, [rbp - 48]
    lea     rsi, [rel porabolas_func]
    movsd   xmm0, qword [rel porabolas_func.divider]
    call    calc_method

    movsd   xmm1, [rbp - 56]
    subsd   xmm0, xmm1
    call    fabs

    push    rbp
    mov     rdi, [rbp - 16]
    lea     rsi, [rel print.format]
    lea     rdx, [rel methods.parabolas]
    mov     rax, 1
    call    fprintf
    pop     rbp



    lea     rdi, [rbp - 48]
    lea     rsi, [rel trapezoids_func]
    movsd   xmm0, qword [nums.two]
    call    calc_method

    movsd   xmm1, [rbp - 56]
    subsd   xmm0, xmm1
    call    fabs

    push    rbp
    mov     rdi, [rbp - 16]
    lea     rsi, [rel print.format]
    lea     rdx, [rel methods.trapezoids]
    mov     rax, 1
    call    fprintf
    pop     rbp


    lea     rdi, [rbp - 48]
    lea     rsi, [rel average_rects_func]
    movsd   xmm0, qword [nums.one]
    call    calc_method

    movsd   xmm1, [rbp - 56]
    subsd   xmm0, xmm1
    call    fabs

    push    rbp
    mov     rdi, [rbp - 16]
    lea     rsi, [rel print.format]
    lea     rdx, [rel methods.avg_rects]
    mov     rax, 1
    call    fprintf
    pop     rbp


    lea     rdi, [rbp - 48]
    lea     rsi, [rel left_rects_func]
    movsd   xmm0, qword [nums.one]
    call    calc_method

    movsd   xmm1, [rbp - 56]
    subsd   xmm0, xmm1
    call    fabs

    push    rbp
    mov     rdi, [rbp - 16]
    lea     rsi, [rel print.format]
    lea     rdx, [rel methods.left_rects]
    mov     rax, 1
    call    fprintf
    pop     rbp

    mov     rdi, [rbp - 16]
    call    fclose 

    add     rsp, 64
    pop     rbp
    ret

section .rodata
    file:
        .path:
            db  "errors.dat",0
        .mod:
            db  "w",0
    print:
        .format:
            db  "%s", 9, "%.8lf", 10, 0
    methods:
        .parabolas:
            db      "P", 0
        .trapezoids:   
            db      "T", 0
        .avg_rects:
            db      "AR", 0
        .left_rects:
            db      "LR", 0

    nums:
        .sixth:     dq 0.1666666666666666667
        .third:     dq 0.3333333333333333333
        .half:      dq 0.5
        .tthird:    dq 0.6666666666666666667
        .fsixth:    dq 0.8333333333333333333
        .two:       dq 2.0
        .one:       dq 1.0
