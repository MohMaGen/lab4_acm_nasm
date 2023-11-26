section .text

global map_iter
map_iter: ; (rdi - *iter, rsi - iter_next_func, rdx - map func)
    mov     [rcx], rdi
    mov     [rcx + 8], rsi
    mov     [rcx + 16], rdx
    ret

global map_next
map_next:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16

    mov     [rbp - 8], rdi

    mov     rax, [rbp - 8]
    mov     rdi, [rax]
    call    [rax + 8]
    test    rax, rax
    je      .null

    mov     rdi, rax
    mov     rax, [rbp - 8]
    call    [rax + 16]

    .return:
        add     rsp, 16
        pop     rbp
        ret
    .null:
        mov     rax, 0
        jmp     .return

    

global for_each
; rdi - iter, rsi - next func, rdx - func
for_each:
    push    rbp
    mov     rbp, rsp 
    sub     rsp, 32

    mov     [rbp - 8], rdi
    mov     [rbp - 16], rsi
    mov     [rbp - 24], rdx

    call    [rbp - 16]
    .loop:
        test    rax,rax
        je      .end_loop

        mov     rdi, rax
        call    [rbp - 24]

        mov     rdi, [rbp - 8]
        call    [rbp - 16]
        jmp     .loop
    .end_loop:

    add     rsp, 32
    pop     rbp
    ret


global sum
; rdi - iter, rsi - next func 
sum:
    push    rbp

    movsd   xmm0, qword [.null]
    movsd   [.sum], xmm0

    lea     rdx, [rel .func]
    call    for_each

    movsd   xmm0, [.sum]

    pop     rbp
    ret
    .func:
        movsd   xmm1, [.sum]
        addsd   xmm0, xmm1
        movsd   [.sum], xmm0
        ret

section .bss
    .sum: resq 1
section .rodata
    .null: dq 0.0


section .text
global test_iters
extern printf
extern alloc_array
extern array_iter
extern array_iter_next
extern array_into_iter_next
test_iters:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 80


    mov     rdi, qword 10
    call    alloc_array

    mov     [rbp - 8], rax ; array pointer 

    lea     rsi, [rbp - 32]
    mov     rdi, qword [rbp - 8]
    call    array_iter

    lea     rdi, [rbp - 32]
    lea     rsi, [rel array_into_iter_next]
    lea     rdx, [rel .func2]
    lea     rcx, [rbp - 56]
    call    map_iter

    lea     rdi, [rbp - 56]
    lea     rsi, [rel map_next]
    lea     rdx, [rel .func2]
    lea     rcx, [rbp - 80]
    call    map_iter

    lea     rdi, [rbp - 80]
    lea     rsi, [rel map_next]
    call    sum

    push    rbp
    lea     rdi, [rel pf]
    mov     rax, 1
    call    printf
    pop     rbp


    add     rsp, 80
    pop     rbp 
    ret

    .func:
        movsd   xmm0, qword [num]
        movsd   [rdi], xmm0
        ret

    .func2:
        movsd   xmm0, qword [num]
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
        

section .rodata
    num: dq 11.0
    pf: db "%lf", 10, 0
