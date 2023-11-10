extern printf
extern fprintf
extern fopen
global left_rects

section .rodata
    minus_one: 
        dq  -1.0 
    null:
        dq  0.0
    file_format:
        db  "%lf %lf", 10, 0
    format_int:
        db  "rax is %d", 10, 0
    iter_start:
        dq  0
    file_name:
        db  "left_rects.txt", 0
    open_mode:
        db  "w", 0

section .text 
left_rects:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 80

    movsd   [rbp - 16], xmm0
    movsd   [rbp - 24], xmm1
    mov     [rbp - 32], rdi
    mov     [rbp - 40], rsi

    push    rbp 
    lea     rdi, [rel file_name]
    lea     rsi, [rel open_mode]
    call    fopen wrt ..plt
    pop     rbp
    mov     [rbp - 64], rax

    ; step
    movsd   xmm0, [rbp - 16]
    mulsd   xmm0, qword [minus_one]
    addsd   xmm0, [rbp - 24]

    cvtsi2sd    xmm1, [rbp - 32]
    divsd   xmm0, xmm1
    movsd   [rbp - 48], xmm0 ; step at rbp - 48


    movsd   xmm0, qword [null] 
    movsd   [rbp - 24], xmm0 ; sum
    mov     rax, qword 0 
    mov     [rbp - 56], rax; iterator




    .loop:
        mov     rax, [rbp - 56]
        cmp     rax, [rbp - 32]
        jnl     .loop_end

    
        movsd   xmm0, [rbp - 16]
        call    [rbp - 40] 
        movsd   xmm1, xmm0 ; xmm1 = f(x)
        movsd   xmm2, [rbp - 48] ; step
        mulsd   xmm2, xmm1 ; step * f(x)
        addsd   xmm2, [rbp - 24]
        movsd   [rbp - 24], xmm2
        movsd   xmm0, [rbp - 16]
        movsd   [rbp - 72], xmm1


        push    rbp 
        mov     rdi, [rbp - 64]
        lea     rsi, [rel file_format]
        movsd   xmm0, [rbp - 16]
        movsd   xmm1, [rbp - 72]
        call    fprintf wrt ..plt
        pop     rbp


        mov     rax, [rbp - 56]
        inc     rax
        mov     [rbp - 56], rax

        movsd   xmm0, [rbp - 16]
        movsd   xmm1, [rbp - 48]
        addsd   xmm0, xmm1
        movsd   [rbp - 16], xmm0

        jmp     .loop

    .loop_end
    



    movsd   xmm0, [rbp - 24]

    add     rsp, 80
    pop     rbp
    ret

