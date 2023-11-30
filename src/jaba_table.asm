extern printf
extern len_str
extern mul_str
extern center
extern clone
extern for_each
extern range_next
extern function
extern calc_method
extern left_rects_func
extern average_rects_func
extern trapezoids_func
extern porabolas_func
extern porabolas_func.divider
extern kotes_6_func
extern kotes_6_func.divider

global jaba_table
jaba_table:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 160

    mov     [rbp - 8], rdi ; pointer to range
    lea     rdi, [rel names]
    mov     [rbp - 16], rdi 


    
    mov     rax, qword 0
    mov     [rbp - 24], rax

    mov     rdi, qword 8
    call    .print_line

    .print_names:
        cmp     rax, qword 8
        jnl     .end_print_names

        push    rbp
        lea     rdi, [rel cell_format.name]
        mov     rsi, [rbp - 16]
        call    printf
        pop     rbp

        mov     rdi, [rbp - 16]
        call    len_str

        mov     rbx, [rbp - 16]
        add     rax, rbx
        inc     rax
        mov     [rbp - 16], rax

        mov     rax, [rbp - 24]
        inc     rax
        mov     [rbp - 24], rax
        jmp     .print_names
    .end_print_names:


    push    rbp 
    lea     rdi, [rel line_end]
    call    printf
    pop     rbp

    mov     rdi, qword 8
    call    .print_line

    mov     rdi, [rbp - 8]
    lea     rsi, [rbp - 56]
    mov     rdx, qword 32
    call    clone


    lea     rdi, [rbp - 56]
    lea     rsi, [rel range_next]
    lea     rdx, [rel print_kotes]
    call    for_each

    mov     rdi, qword 8
    call    .print_line

    call    .print_offset

    mov     rax, qword 0
    mov     [rbp - 24], rax
    lea     rdi, [rel names2]
    mov     [rbp - 16], rdi 

    mov     rdi, qword 4
    call    .print_line

    .print_names2:
        cmp     rax, qword 4
        jnl     .end_print_names2

        push    rbp
        lea     rdi, [rel cell_format.name]
        mov     rsi, [rbp - 16]
        call    printf
        pop     rbp

        mov     rdi, [rbp - 16]
        call    len_str

        mov     rbx, [rbp - 16]
        add     rax, rbx
        inc     rax
        mov     [rbp - 16], rax

        mov     rax, [rbp - 24]
        inc     rax
        mov     [rbp - 24], rax
        jmp     .print_names2
    .end_print_names2:

    push    rbp 
    lea     rdi, [rel line_end]
    call    printf
    pop     rbp

    mov     rdi, qword 4
    call    .print_line

    mov     rdi, [rbp - 8]
    lea     rsi, [rbp - 88]
    mov     rdx, qword 32
    call    clone

    mov     rdi, [rbp - 8]
    lea     rsi, [rbp - 120]
    mov     rdx, qword 32
    call    clone

    lea     rdi, [rbp - 88]
    lea     rsi, [rel range_next]
    lea     rdx, [rel print_other]
    call    for_each


    mov     rdi, qword 4
    call    .print_line

    call    .print_offset
    
    mov     rdi, qword 2
    call    .print_line
    
    push    rbp
    lea     rdi, [rel cell_format.name]
    lea     rsi, [rel methods.kotes]
    call    printf
    pop     rbp

    lea     rdi, [rbp - 120]
    lea     rsi, [rel kotes_6_func]
    movsd   xmm0, qword [kotes_6_func.divider]
    call    calc_method

    push    rbp
    lea     rdi, [rel cell_format.value]
    mov     rax, 1
    call    printf
    pop     rbp


    push    rbp 
    lea     rdi, [rel line_end]
    call    printf
    pop     rbp

    push    rbp
    lea     rdi, [rel cell_format.name]
    lea     rsi, [rel methods.parabolas]
    call    printf
    pop     rbp

    lea     rdi, [rbp - 120]
    lea     rsi, [rel porabolas_func]
    movsd   xmm0, qword [rel porabolas_func.divider]
    call    calc_method

    push    rbp
    lea     rdi, [rel cell_format.value]
    mov     rax, 1
    call    printf
    pop     rbp

    push    rbp 
    lea     rdi, [rel line_end]
    call    printf
    pop     rbp

    push    rbp
    lea     rdi, [rel cell_format.name]
    lea     rsi, [rel methods.trapezoids]
    call    printf
    pop     rbp

    lea     rdi, [rbp - 120]
    lea     rsi, [rel trapezoids_func]
    movsd   xmm0, qword [nums.two]
    call    calc_method

    push    rbp
    lea     rdi, [rel cell_format.value]
    mov     rax, 1
    call    printf
    pop     rbp

    push    rbp 
    lea     rdi, [rel line_end]
    call    printf
    pop     rbp

    push    rbp
    lea     rdi, [rel cell_format.name]
    lea     rsi, [rel methods.avg_rects]
    call    printf
    pop     rbp

    lea     rdi, [rbp - 120]
    lea     rsi, [rel average_rects_func]
    movsd   xmm0, qword [nums.one]
    call    calc_method

    push    rbp
    lea     rdi, [rel cell_format.value]
    mov     rax, 1
    call    printf
    pop     rbp

    push    rbp 
    lea     rdi, [rel line_end]
    call    printf
    pop     rbp

    push    rbp
    lea     rdi, [rel cell_format.name]
    lea     rsi, [rel methods.left_rects]
    call    printf
    pop     rbp

    lea     rdi, [rbp - 120]
    lea     rsi, [rel left_rects_func]
    movsd   xmm0, qword [nums.one]
    call    calc_method

    push    rbp
    lea     rdi, [rel cell_format.value]
    mov     rax, 1
    call    printf
    pop     rbp

    push    rbp 
    lea     rdi, [rel line_end]
    call    printf
    pop     rbp

    mov     rdi, qword 2
    call    .print_line

    call    .print_offset

    mov     rdi, qword 2
    call    .print_line
    push    rbp
    lea     rdi, [rel cell_format.name]
    lea     rsi, [rel delta_x]
    call    printf
    pop     rbp


    movsd   xmm0, [rbp - 96]

    push    rbp
    lea     rdi, [rel cell_format.value]
    call    printf
    pop     rbp


    push    rbp 
    lea     rdi, [rel line_end]
    call    printf
    pop     rbp

    mov     rdi, qword 2
    call    .print_line

    add     rsp, 160
    pop     rbp
    ret
    .print_line:
        mov     rdx, rdi
        lea     rdi, [rel buffer]
        lea     rsi, [hline]
        call    mul_str

        push    rbp
        sub     rsp, 8
        lea     rdi, [rel buffer]
        call    printf
        add     rsp, 8
        pop     rbp

        push    rbp
        sub     rsp, 8
        lea     rdi, [rel hline_end]
        call    printf
        add     rsp, 8
        pop     rbp

        ret
    .print_offset:
        lea     rdi, [rel buffer]
        lea     rsi, [nl]
        mov     rdx, qword 8
        call    mul_str

        push    rbp
        sub     rsp, 8
        lea     rdi, [rel buffer]
        call    printf
        add     rsp, 8
        pop     rbp
        ret

section .rodata
    names:
        db  "       x       ", 0, "      f(x)     ", 0, " f(x + 1/6 Δx) ", 0, " f(x + 1/3 Δx) ", 0, " f(x + 1/2 Δx) ", 0, " f(x + 2/3 Δx) ", 0, " f(x + 5/6 Δx) ", 0, "   f(x + Δx)   ", 0

    names2:
        db  "       x       ", 0, "      f(x)     ", 0, " f(x + 1/2 Δx) ", 0, "   f(x + Δx)   ", 0
    delta_x:
        db "       Δx      ", 0
    nl:
        db  10, 0

    methods:
        .kotes:
            db      "     kotes     ", 0
        .parabolas:
            db      "   parabolas   ", 0
        .trapezoids:   
            db      "   trapezoids  ", 0
        .avg_rects:
            db      "   avg rects   ", 0
        .left_rects:
            db      "   left rects  ", 0

    nums:
        .sixth:     dq 0.1666666666666666667
        .third:     dq 0.3333333333333333333
        .half:      dq 0.5
        .tthird:    dq 0.6666666666666666667
        .fsixth:    dq 0.8333333333333333333
        .two:       dq 2.0
        .one:       dq 1.0

    cell_format:
        .name: 
            db  "|%s", 0
        .value:
            db  "|  %-13.6lf", 0
    line_end:
        db      "|", 10, 0
    hline:
        db      "+---------------", 0
    hline_end:
        db      "+", 10, 0

section .bss
    buffer: resb 1024

section .text
print_kotes:
    sub     rsp, 16
    movsd   [rsp], xmm0 ; x
    movsd   [rsp + 8], xmm1 ; Delta x

    lea     rdi, [rel cell_format.value]
    call    printf

    movsd   xmm0, [rsp]
    call    function
    lea     rdi, [rel cell_format.value]
    call    printf


    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [nums.sixth]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    lea     rdi, [rel cell_format.value]
    call    printf

    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [nums.third]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    lea     rdi, [rel cell_format.value]
    call    printf

    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [nums.half]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    lea     rdi, [rel cell_format.value]
    call    printf

    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [nums.tthird]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    lea     rdi, [rel cell_format.value]
    call    printf


    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [nums.fsixth]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    lea     rdi, [rel cell_format.value]
    call    printf

    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    lea     rdi, [rel cell_format.value]
    call    printf

    lea     rdi, [rel line_end]
    call    printf

    add     rsp, 16
    ret

print_other:
    sub     rsp, 16
    movsd   [rsp], xmm0
    movsd   [rsp + 8], xmm1

    
    lea     rdi, [rel cell_format.value]
    call    printf

    movsd   xmm0, [rsp]
    call    function
    lea     rdi, [rel cell_format.value]
    call    printf

    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [nums.half]
    mulsd   xmm1, xmm0
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    lea     rdi, [rel cell_format.value]
    call    printf

    movsd   xmm1, [rsp + 8]
    movsd   xmm0, qword [rsp]
    addsd   xmm0, xmm1
    call    function
    lea     rdi, [rel cell_format.value]
    call    printf

    lea     rdi, [rel line_end]
    call    printf

    add     rsp, 16
    ret
