extern malloc
extern free
extern printf
global alloc_table

;
; table (size 16 + ...)
;     columns count (size 8) & rows count (size 8) &
;     qword [columns count * rows count * 8]    
; 


section .text
alloc_table: ; rdi - columns count rsi - rows count -> rax table*
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    mov     [rbp - 16], qword rdi
    mov     [rbp - 24], qword rsi

    mov     rax, qword [rbp - 16]
    mov     rbx, qword [rbp - 24]
    mul     rbx
    mov     rbx, 8
    mul     rbx
    mov     rbx, 16
    add     rax, rbx
    mov     rdi, rax
    
    push    rbp
    call    malloc
    pop     rbp

    mov     rbx, rax
    mov     rax, qword [rbp - 16]
    mov     [rbx], qword rax
    mov     rax, qword [rbp - 24]
    mov     [rbx + 8], qword rax

    mov     rax, rbx

    add     rsp, 32
    pop     rbp
    ret

section .rodata
    format:
        db  "%d",10,0