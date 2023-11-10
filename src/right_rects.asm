extern fprintf 
extern fopen
extern calc_step
global right_rects

section .rodata
    file:
        db "right_rects.txt", 0
    file_format:
        db "%lf %lf", 10, 0
    open_mode:
        db  "w", 0
    null:
        dq  0.0


section .text
right_rects:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 80

    movsd   [rbp - 16], xmm0    ; from
    movsd   [rbp - 24], xmm1    ; to
    mov     [rbp - 32], rdi     ; n 
    mov     [rbp - 40], rsi     ; function
    
    call    calc_step
    movsd   [rbp - 48], xmm0    ; step

    movsd   xmm0, qword [null]
    movsd   [rbp - 56], xmm0    ; result
    
    mov     rax, qword 0
    mov     [rbp - 64], rax     ; iter


    push    rbp
    lea     rdi, [rel file]
    lea     rsi, [rel open_mode]
    call    fopen wrt ..plt
    pop     rbp
    mov     [rbp - 72], rax     ; fd


    .loop:
        mov     rax, [rbp - 64]
        cmp     rax, [rbp - 32]
        jnl     .end_loop

        
        movsd   xmm0, [rbp - 16]
        addsd   xmm0, [rbp - 48]
        call    [rbp - 40]
        movsd   xmm1, xmm0      ; f(x + Delta x)
        
        movsd   xmm0, [rbp - 48]
        mulsd   xmm0, xmm1      ; f(x + Delta x) * step
        addsd   xmm0, [rbp - 56]
        movsd   [rbp - 56], xmm0

        movsd   xmm0, [rbp - 16]
        
        push    rbp
        mov     rdi, [rbp - 72]
        lea     rsi, [rel file_format]
        call    fprintf wrt ..plt
        pop     rbp

        mov     rax, [rbp - 64]
        inc     rax
        mov     [rbp - 64], rax 

        movsd   xmm0, [rbp - 16]
        addsd   xmm0, [rbp - 48]
        movsd   [rbp - 16], xmm0

        jmp     .loop

    .end_loop:

    movsd   xmm0, [rbp - 56]

    add     rsp, 80
    pop     rbp
    ret
