bits 64

extern printf
extern exit
extern dinamic_try
extern alloc_table
extern print_table
extern read_column_from_file
extern methods
extern mul_str
extern concat_str
extern test_array
extern copy_str
extern test_iters
extern test_range
extern iter_right_rects
extern free
extern range
extern calc_method
extern right_rects_func
extern average_rects_func
extern trapezoids_func
extern porabolas_func
extern porabolas_func.divider
extern kotes_6_func
extern kotes_6_func.divider
extern jaba_table
extern calc_errors
extern calc_errors_lr
global main

default rel

section .rodata
    message:
        db  "Hello, world", 0
    format:
        db  "<%s>", 10, 0
    format_double:
        db  "xmm0 is %lf", 10, 0
    format_int:
        db  "rax is %d", 10, 0
    num:
        dq  2.4
    error:
        dq  0.001
    from:
        dq  -1.4
    end: 
        dq  4.3
    n:  
        dq  30
    one:
        dq  1.0
    two:
        dq  2.0
    aboba:
        db  "+aboba+",0
    buffers:
        db  10,"<%s>, <%s>",10,0
    files:
        .lr:    db "./left_rects.txt",0
        .rr:    db "./right_rects.txt",0
        .k:     db "./kotes_6.txt",0
        .t:     db "./trapezoids.txt",0
        .p:     db "./parabolas.txt",0
        .mr:    db "./middle_rects.txt",0

section .bss 
    buffer1: resb 1024
    buffer2: resb 1024

section .text

main:
    ;push    rbp
    ;call    methods
    ;pop     rbp

    mov     rbp, rsp
    sub     rsp, 32

    mov     rdi, qword 7
    mov     rsi, qword [n]
    call    alloc_table

    mov     [rbp - 16], rax


    lea     rsi, [rel files.lr]
    call .read_column
    lea     rsi, [rel files.lr]
    call .read_column
    lea     rsi, [rel files.rr]
    call .read_column
    lea     rsi, [rel files.mr]
    call .read_column
    lea     rsi, [rel files.t]
    call .read_column
    lea     rsi, [rel files.p]
    call .read_column
    lea     rsi, [rel files.k]
    call .read_column

    mov     rdi, [rbp - 16]
    call    print_table

    mov     rdi, [rbp - 16]
    call    free
    
    add     rsp, 32
    mov     rbp, rsp
    sub     rsp, 32


    mov     rdi, qword [n]
    lea     rsi, [rbp - 32]
    movsd   xmm0, qword [from]
    movsd   xmm1, qword [end]
    call    range


    lea     rdi, [rbp - 32]
    lea     rsi, [rel trapezoids_func]
    movsd   xmm0, qword [two]
    call    calc_method
    call    .print_xmm0

    lea     rdi, [rbp - 32]
    lea     rsi, [rel average_rects_func]
    movsd   xmm0, qword [one]
    call    calc_method
    call    .print_xmm0

    lea     rdi, [rbp - 32]
    lea     rsi, [rel porabolas_func]
    movsd   xmm0, qword [porabolas_func.divider]
    call    calc_method
    call    .print_xmm0

    lea     rdi, [rbp - 32]
    lea     rsi, [rel kotes_6_func]
    movsd   xmm0, qword [kotes_6_func.divider]
    call    calc_method
    call    .print_xmm0


    lea     rdi, [rbp - 32]
    call    jaba_table

    mov     rdi, qword [n]
    lea     rsi, [rbp - 32]
    movsd   xmm0, qword [from]
    movsd   xmm1, qword [end]
    call    range

    lea     rdi, [rbp - 32]
    call    calc_errors

    lea     rdi, [rbp - 32]
    call    calc_errors_lr

    add     rsp, 32

    xor     rdi,rdi
    mov     rdi, 0
    call    exit
    ret

    .print_xmm0:        
        push    rbp
        sub     rsp, 8
        mov     rdi, format_double
        mov     eax, 1
        call    printf wrt ..plt
        add     rsp, 8
        pop     rbp
        ret

    .print_rax: 
        push    rbp
        sub     rsp, 8
        mov     rdi, format_int
        mov     rsi, rax
        mov     eax, 0
        call    printf wrt ..plt
        add     rsp, 8
        pop     rbp
        ret

    .read_column:
        push    rbp
        mov     rdi, [rbp - 16]
        call    read_column_from_file
        pop     rbp
        ret
    






