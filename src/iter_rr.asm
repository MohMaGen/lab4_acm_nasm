extern range_next
extern map_iter
extern map_next
extern sum
extern function
extern print_range
extern printf

global iter_right_rects
global iter_right_rects.func
; rdi - *range
iter_right_rects:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 48

    mov     [rbp - 8], rdi ; *range

    movsd   xmm0, [rdi + 24]
    movsd   [rbp - 16], xmm0 ; step


    mov     rdi, [rbp - 8]
    lea     rsi, [rel range_next]
    lea     rdx, [rel .func]
    lea     rcx, [rbp - 40]
    call    map_iter


    lea     rdi, [rbp - 40]
    lea     rsi, [rel map_next]
    call    sum
    
    movsd   xmm1, qword [rbp - 16]
    mulsd   xmm0, xmm1

    add     rsp, 48
    pop     rbp
    ret

    .func:
        call    function
        ret
section .rodata
    .num: dq 1.5
    .pf: db "bi",10,0

