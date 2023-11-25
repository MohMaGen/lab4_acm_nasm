extern printf
global range

section .rodata
    int_format:
        db "%d", 10, 0

section .text
range:
        sub     rsp, 24
        mov     [rsp + 8], edi ; start
        mov     [rsp + 12], esi ; end 
        mov     [rsp + 16], edx ; step
        mov     [rsp + 20], dword 0 ; sum

    .range_loop:
            mov     eax, [rsp + 8] ; start
            call    .print_eax_int

            mov     eax, [rsp + 20] ; sum
            add     eax, [rsp + 8] ; start
            mov     [rsp + 20], eax ; sum = sum + start

        .increase:
            mov     eax, [rsp + 8] ; start
            add     eax, [rsp + 16] ; step
            mov     [rsp + 8],  eax ; start += step

        .condition:
            mov     eax, [rsp + 16] ; step
            cmp     eax, 0
            jl      .condition_negative_step

            .condition_positive_step:
                mov     eax, [rsp + 8] ; start
                cmp     eax, [rsp + 12] ; end
                jg      .return
                jmp     .range_loop

            .condition_negative_step:
                mov     eax, [rsp + 8] ; start
                cmp     eax, [rsp + 12] ; end
                jl      .return
                jmp     .range_loop

    .print_eax_int:
        push    rbp
        mov     rdi, int_format ; format
        mov     esi, eax ; start
        xor     eax, eax
        call    printf wrt ..plt
        pop     rbp 
        ret

    .return: 
        .print_sum:
            mov     eax, [rsp + 20] ; sum
            call    .print_eax_int

       add      rsp, 24
       ret

extern alloc_array
extern calc_step
global create_range
section .text 
create_range:
    push    rbp 
    push    rax 
    push    rbx 
    mov     rbp, rsp
    sub     rsp, 64

    movsd   [rbp - 16], xmm0  ; start - included 
    movsd   [rbp - 24], xmm1  ; end - not included 
    mov     [rbp - 32], rdi         ; steps - count of steps

    call    calc_step
    movsd   [rbp - 40], xmm0 ; step


    mov     rax, [rbp - 32]
    dec     rax 
    mov     rdi, rax 
    call    alloc_array
    test    rax, rax
    jne     .error
    mov     [rbp - 56], rax


    mov     rax, qword 0
    mov     [rbp - 48], rax

    .iter_with_normal_step:
        mov     rbx, [rbp - 32]
        add     rbx, qword -1
        cmp     rax, rbx
        jnl     .last_iter

        inc     rax
        mov     rbx, 8
        mul     rbx 
        mov     rbx, qword [rbp - 56]
        add     rax, rbx
        movsd   xmm0, qword [rbp - 16]
        movsd   qword [rax], xmm0

        movsd   xmm1, qword [rbp - 40]
        addsd   xmm0, xmm1
        movsd   qword [rbp - 16], xmm0

        mov     rax, [rbp - 48]
        inc     rax
        mov     [rbp - 48], rax
        jmp     .iter_with_normal_step
    .last_iter:
        movsd   xmm0, [rbp - 16]
        movsd   xmm1, [rbp - 24]
        movsd   xmm2, qword [cr.nums]
        mulsd   xmm0, xmm2
        addsd   xmm0, xmm1
        movsd   [rbp - 40], xmm0


    .return:
        add     rsp, 64
        pop     rbx
        pop     rax
        pop     rbp
        ret

    .error:
        mov     rax, 0
        jmp .return

; (start) step (1) step ... step (n-2) end - current (end)
section .rodata:
    cr:
        .nums:  
            dq  -1.0


