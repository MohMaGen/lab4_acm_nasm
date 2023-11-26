extern printf
extern calc_step



section .text 
global range
; (
;   rdi - steps count
;   rsi - range pointer 
;   xmm0 - from
;   xmm1 - end
; ) -> start with rsi {
;   steps count 8 bit
;   curr iter   8 bit
;   curr        8 bit
;   step        8 bit
; }
;
range:
    mov     qword [rsi], rdi ; steps count
    mov     qword [rsi + 8], qword 0 ; it
    movsd   [rsi + 16], xmm0 ; from / curr

    call    calc_step
    movsd   [rsi + 24], xmm0 ; step

    ret

global range_next
; ( rid - *range )
range_next:
    mov     rax, qword [rdi + 8]
    cmp     rax, qword [rdi]
    jnl     .null
    
    inc     rax
    mov     [rdi + 8], qword rax

    movsd   xmm0, [rdi + 16]
    movsd   xmm1, [rdi + 24]
    movsd   xmm2, [rdi + 16]

    addsd   xmm0, xmm1
    movsd   [rdi + 16], xmm0

    movsd   xmm0, xmm2
    mov     rax, 1

    .return:
    ret

    .null:
        mov     rax, 0
        jmp     .return

global print_range
print_range:
    push    rbp
    mov     rsi, [rdi]
    mov     rdx, [rdi + 8]
    movsd   xmm0, [rdi + 16]
    movsd   xmm1, [rdi + 24]
    lea     rdi, [rel .pf]
    call    printf
    pop     rbp
    ret
section .rodata:
    .pf: db     "(",10,9,"n = %u,",10,9,"i = %u,",10,9,"curr = %lf,",10,9,"step =  %lf,",10,")",10,0


global test_range
extern for_each
extern map_iter
extern map_next
extern sum
test_range:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 64

    lea     rsi, [rbp - 32]
    mov     rdi, qword [nums.i]
    movsd   xmm0, [nums.f]
    movsd   xmm1, [nums.f + 8]
    call    range


    lea     rdi, [rbp - 32]
    lea     rsi, [rel range_next]
    call    sum

    call    .print_func

    add     rsp, 64
    pop     rbp
    ret
    .print_func:
        push    rbp 
        sub     rsp, 8
        lea     rdi, [rel pf]
        mov     rax, 1
        call    printf
        add     rsp, 8
        pop     rbp
        ret
    .eq_numf:
        movsd   xmm0, qword [nums.f]
        ret

section .rotdata
    nums: 
        .f  dq 1.0, 5.0
        .i  dq 4

    pf:     db "x = %0.2lf, Delta x = %0.2lf", 10, 0


