extern range
extern calc_method
extern kotes_6_func
extern kotes_6_func.divider
extern left_rects_func
extern fopen
extern fclose
extern fprintf
extern fabs
extern clone

global calc_errors_lr
calc_errors_lr:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 160

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

    mov     rax, qword 250
    mov     [rbp - 64], rax
    mov     rax, qword 25
    mov     [rbp - 72], rax
    .loop:
        mov     rdi, [rbp - 72]
        lea     rsi, [rbp - 104]
        movsd   xmm0, qword [nums.from]
        movsd   xmm1, qword [nums.end]
        call    range

        lea     rdi, [rbp - 104]
        lea     rsi, [rel left_rects_func]
        movsd   xmm0, [nums.one]
        call    calc_method

        movsd   xmm1, [rbp - 56]
        subsd   xmm0, xmm1
        call    fabs

        push    rbp
        mov     rdi, [rbp - 16]
        lea     rsi, [rel print.format]
        mov     rdx, [rbp - 72]
        mov     rax, 1
        call    fprintf
        pop     rbp

        mov     rax, [rbp - 72]
        mov     rbx, [rbp - 64]
        cmp     rax, rbx
        jnl     .end_loop
        add     rax, qword 5
        mov     [rbp - 72], rax
        jmp     .loop
    .end_loop:

    mov     rdi, [rbp - 16]
    call    fclose 

    add     rsp, 160
    pop     rbp
    ret


section .rodata
    file:
        .path:
            db  "lrerrors.dat",0
        .mod:
            db  "w",0
    print:
        .format:
            db  "%d", 9, "%.8lf", 10, 0

    nums:
        .sixth:     dq 0.1666666666666666667
        .third:     dq 0.3333333333333333333
        .half:      dq 0.5
        .tthird:    dq 0.6666666666666666667
        .fsixth:    dq 0.8333333333333333333
        .two:       dq 2.0
        .one:       dq 1.0
        .from:
            dq  -1.4
        .end: 
            dq  4.3
