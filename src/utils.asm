global clone
; (
;   from    - rdi
;   to      - rsi
;   size    - rdx ( in bits )
; )
clone:
    xor     rax, rax
    .loop:
        cmp     rax, rdx
        jnl     .end
        push    rax

        mov     rbx, rax
        add     rbx, rdi
        add     rax, rsi
        mov     bl, byte [rbx] 
        mov     [rax], byte bl

        pop     rax
        inc     rax
        jmp     .loop
    .end:
    ret
