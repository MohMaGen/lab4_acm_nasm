extern fprintf 
extern fopen
extern calc_step
global kortes_6

section .rodata
    file:
        db "kortes_6.txt", 0
    file_format:
        db "%lf %lf", 10, 0
    open_mode:
        db  "w", 0
    nums:
        dq  0.0, 6.0, 3.0, 0.5, 2.0, 5.0, 840.0, 41.0, 216.0, 27.0, 272.0


section .text
kortes_6:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 128


    movsd   [rbp - 16], xmm0    ; from
    movsd   [rbp - 24], xmm1    ; to
    mov     [rbp - 32], rdi     ; n 
    mov     [rbp - 40], rsi     ; function
    
    call    calc_step
    movsd   [rbp - 48], xmm0    ; step

    movsd   xmm0, qword [nums]
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
        call    [rbp - 40]
        movsd   [rbp - 24], xmm0 ; -24 = f(x)


        movsd   xmm0, [rbp - 48]
        divsd   xmm0, qword [nums + 8]
        addsd   xmm0, [rbp - 16]
        call    [rbp - 40]
        movsd   [rbp - 80], xmm0 ; -80 = f(x + Delta / 6)


        movsd   xmm0, [rbp - 48]
        divsd   xmm0, qword [nums + 16]
        addsd   xmm0, [rbp - 16]
        call    [rbp - 40]
        movsd   [rbp - 88], xmm0 ; -88 = f(x + Delta / 3)


        movsd   xmm0, [rbp - 48]
        mulsd   xmm0, qword [nums + 24]
        addsd   xmm0, [rbp - 16]
        call    [rbp - 40]
        movsd   [rbp - 96], xmm0 ; -96 = f(x + Delta / 2)


        movsd   xmm0, [rbp - 48]
        divsd   xmm0, qword [nums + 16]
        mulsd   xmm0, qword [nums + 32]
        addsd   xmm0, [rbp - 16]
        call    [rbp - 40]
        movsd   [rbp - 104], xmm0 ; -24 = f(x + Delta / 3 * 2)


        movsd   xmm0, [rbp - 48]
        divsd   xmm0, qword [nums + 8]
        mulsd   xmm0, qword [nums + 40]
        addsd   xmm0, [rbp - 16]
        call    [rbp - 40]
        movsd   [rbp - 112], xmm0 ; -24 = f(x + Delta / 6 * 5)


        
        movsd   xmm0, [rbp - 48]
        addsd   xmm0, [rbp - 16]
        call    [rbp - 40] ; xmm0, f(x + Delta)
        

        mulsd   xmm0, [nums + 56]

        movsd   xmm1, [rbp - 112]
        mulsd   xmm1, [nums + 64]
        addsd   xmm0, xmm1 

        movsd   xmm1, [rbp - 104]
        mulsd   xmm1, [nums + 72]
        addsd   xmm0, xmm1

        movsd   xmm1, [rbp - 96]
        mulsd   xmm1, [nums + 80]
        addsd   xmm0, xmm1

        movsd   xmm1, [rbp - 88]
        mulsd   xmm1, [nums + 72]
        addsd   xmm0, xmm1

        movsd   xmm1, [rbp - 80]
        mulsd   xmm1, [nums + 64]
        addsd   xmm0, xmm1

        movsd   xmm1, [rbp - 24]
        mulsd   xmm1, [nums + 56]
        addsd   xmm0, xmm1

        divsd   xmm0, [nums + 48]
        movsd   xmm1, xmm0
        mulsd   xmm0, [rbp - 48]
        addsd   xmm0, [rbp - 56]
        movsd   [rbp - 56], xmm0
        
        
        movsd   xmm0, [rbp - 16]

        push    rbp
        mov     rdi, [rbp - 72]
        lea     rsi, [rel file_format]
        mov     rax, 2
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

    add     rsp, 128
    pop     rbp
    ret
    
