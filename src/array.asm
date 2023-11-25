extern malloc
extern printf
extern calc_steps

; array (8 bite + ...)
;   length [0-7] &
;   elems [8 + (7 + length * 8)]
global alloc_array
section .text
alloc_array:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16

    mov     [rbp - 16], rdi ; length
    call    malloc
    
    cmp     rax, qword 0
    je      .allocation_error
    
    mov     rbx, qword [rbp - 16]
    mov     qword [rax], qword rbx

    .return:
        add     rsp, 16
        pop     rbp
        ret

    .allocation_error:
        push    rbp
        lea     rdi, [rel alloc.error_log]
        mov     rdi, [rbp - 16]
        call    printf
        pop     rbp
        mov     rax, qword 0
        jmp     .return

section .rodata 
    alloc:
        .error_log  db "[ ", 0x40, "[31mallocation error", 0x40, "[0m ] can't allocate array of length %ld",0



global array_iter ; length 8 bite, it 8 bite, pointer 8 bite
section .text 
array_iter:
    mov     rax, qword [rdi]
    test    rax, rax 
    je      .empty_array

    mov     [rsi], rax
    mov     rax, qword 0
    mov     [rsi + 8], rax
    mov     [rsi + 16], rdi

    mov     rax, 1

    .return:
        ret

    .empty_array:
        mov     rax, 0
        jmp     .return

global array_into_iter_next
array_into_iter_next: ; return 0  |  ( 1 & value )
    mov     rax, qword [rdi + 8]
    cmp     rax, [rdi]
    jnl     .null

    inc     rax
    mov     [rdi + 8], qword rax

    mov     rbx, 8
    mul     rbx

    mov     rbx, qword [rdi + 16]
    add     rax, rbx
    
    movsd   xmm0, qword [rax]
    mov     rax, 1

    .return:
        ret

    .null:
        mov     rax, 0
        jmp     .return

global array_iter_next
array_iter_next: ; return 0  |  ( 1 & (*value) )
    mov     rax, qword [rdi + 8]
    cmp     rax, [rdi]
    jnl     .null

    inc     rax
    mov     [rdi + 8], qword rax

    mov     rbx, 8
    mul     rbx

    mov     rbx, qword [rdi + 16]
    add     rax, rbx

    .return:
        ret

    .null:
        mov     rax, 0
        jmp     .return

global test_array
test_array:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    mov     rdi, qword 10
    call    alloc_array

    mov     [rbp - 8], rax ; array pointer 
    
    lea     rsi, [rbp - 32]
    mov     rdi, qword [rbp - 8]
    call    array_iter

    movsd   xmm0, qword [num]
    
    lea     rdi, [rbp - 32]
    call    array_iter_next
    .loop1:
        cmp     rax, qword 0
        je      .end_loop1
        
        movsd   xmm1, qword [num]
        addsd   xmm0, xmm1
        movsd   [rax], xmm0

        call     array_iter_next
        jmp .loop1
    .end_loop1:

    lea     rsi, [rbp - 32]
    mov     rdi, qword [rbp - 8]
    call    array_iter

    lea     rdi, [rbp - 32]
    call    array_into_iter_next
    .loop2:
        cmp     rax, qword 0
        je      .end_loop2

        push    rbp
        lea     rdi, [rel pf]
        mov     rax, 1
        call    printf
        pop     rbp

        lea     rdi, [rbp - 32]
        call     array_into_iter_next
        jmp .loop2
    .end_loop2:

    add     rsp, 32
    pop     rbp
    ret



section .rodata:
    num:    dq 10.0
    pf:     db "%lf",10, 0
    

