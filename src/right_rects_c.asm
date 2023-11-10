extern printf
global right_rects_c

section .rodata
    minus_one: 
        dq  -1.0 
    null:
        dq  0.0
    format:
        db  9, "| %10f | %10f |", 10, 0
    line:
        db  9, "+------------+------------+", 10, 0
    format_int:
        db  "rax is %d", 10, 0
    iter_start:
        dq  0

section .text 
right_rects_c:
    push    rbp
    mov     rbp, rsp
    movsd   [rbp - 8], xmm0 ; from
    movsd   [rbp - 16], xmm1 ; to
    mov     [rbp - 24], rdi ; n 
    mov     [rbp - 32], rsi ; function

    mov     rax, qword [iter_start]
    mov     [rbp - 48], rax; iterator

    call    .draw_line

    .calculate_step:
        ; calculate length
        movsd   xmm0, [rbp - 8] ; xmm0 = to
        mulsd   xmm0, [minus_one] ; xmm0 = - to
        addsd   xmm0, [rbp - 16] ; xmm0 = from - to 
        movsd   [rbp - 40], xmm0; length

        ; divide length by n 
        cvtsi2sd xmm1, [rbp - 24]
        movsd   xmm0, [rbp - 40]
        divsd   xmm0, xmm1 ; step = length / n

        ; mov step to [rbp - 32]
        movsd   [rbp -  40], xmm0

    movsd   xmm0, qword [null]
    movsd   [rbp - 16], xmm0 ; sum

    .loop:
        mov     rax, [rbp - 48]
        cmp     rax, [rbp - 24]
        jnl     .after_loop 
    
        movsd   xmm0, [rbp - 8]
        call    [rbp - 32]

        movsd   xmm1, xmm0
        movsd   xmm0, [rbp - 8]

        call    .print

        mulsd   xmm1, [rbp - 40] ; height * step
        addsd   xmm1, [rbp - 16]
        movsd   [rbp - 16], xmm1

        mov     rax, qword 1
        add     rax, [rbp - 48]
        mov     [rbp - 48], rax

        movsd   xmm0, [rbp - 8]
        addsd   xmm0, [rbp - 40]
        movsd   [rbp - 8], xmm0

        jmp     .loop


    .after_loop:

    call    .draw_line

    movsd   xmm0, [rbp - 16]
    mov     rsp, rbp
    pop     rbp
    ret

    .print:
        push    rbp
        mov     rdi, format
        mov     eax, 1
        call    printf wrt ..plt 
        pop     rbp
        ret

    .draw_line:    
        push    rbp
        mov     rdi, line
        xor     rax, rax
        call    printf wrt ..plt
        pop     rbp
        ret
