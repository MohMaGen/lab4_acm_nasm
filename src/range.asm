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
