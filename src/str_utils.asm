global mul_str
global concat_str
global copy_str


section .text
mul_str:
    push    rbp
    push    rax
    push    rbx
    mov     rbp, rsp
    sub     rsp, 64

    mov     [rbp - 16], rdi ; buffer to write multiplication result
    mov     [rbp - 24], rsi ; str to multiply
    mov     [rbp - 32], rdx ; times to multiply

    mov     [rbp - 40], rsi; str pointer 
    mov     [rbp - 48], rdi ; buffer pointer
    mov     rax, 0
    mov     [rbp - 56], rax ; counter

    .loop:
        mov     rax, qword [rbp - 40]
        mov     bl, byte [rax]
        mov     al, byte 0
        cmp     al, bl
        je      .end_str


        mov     rax, qword [rbp - 48]
        mov     rbx, qword [rbp - 40]
        mov     bl, byte [rbx]
        mov     [rax], bl

        mov     rax, qword [rbp - 40]
        inc     rax
        mov     [rbp - 40], qword rax

        mov     rax, qword [rbp - 48]
        inc     rax
        mov     [rbp - 48], rax


        jmp     .loop
        .end_str:
            mov     rax, qword [rbp - 56]
            inc     rax
            mov     [rbp - 56], qword rax

            cmp     rax, [rbp - 32]
            jnl     .end_loop
            mov     rax, qword [rbp - 24]
            mov     [rbp - 40], rax 
            jmp     .loop
    .end_loop:

    add     rsp, 64
    pop     rbx
    pop     rax
    pop     rbp
    ret

concat_str:
    push    rbp
    push    rax
    push    rbx
    mov     rbp, rsp
    sub     rsp, 24


    mov     [rbp - 16], rdi ; pointer to add
    mov     [rbp - 24], rsi ; pointer from

    .iter_pointer_to_add_end:
        mov     rax, [rbp - 16]
        mov     al, byte [rax]
        test    al, al
        je      .end1

        mov     rax, qword [rbp - 16]
        inc     rax
        mov     [rbp - 16], rax

        jmp     .iter_pointer_to_add_end
    .end1:

    .concat_pointer_from_to_pointer_to_add:
        mov     rax, [rbp - 24]
        mov     al, byte [rax]
        test    al, al
        je      .end2

        mov     rax, qword [rbp - 16]
        mov     rbx, qword [rbp - 24]
        mov     bl, byte [rbx]
        mov     [rax], byte bl

        
        mov     rax, qword [rbp - 16]
        inc     rax
        mov     [rbp -16], rax

        mov     rax, qword [rbp - 24]
        inc     rax
        mov     [rbp -24], rax

        jmp     .concat_pointer_from_to_pointer_to_add
    .end2:


    add     rsp, 24
    pop     rbx
    pop     rax
    pop     rbp
    ret



copy_str:
    push    rbp
    push    rax
    push    rbx
    mov     rbp, rsp
    sub     rsp, 24

    mov     [rbp - 16], rdi ; buffer to copy str
    mov     [rbp - 24], rsi ; string to copy

    .loop:
        mov     rax, [rbp - 24]
        mov     al, byte [rax]
        test    al, al
        je      .end

        mov     rax, qword [rbp - 16]
        mov     rbx, qword [rbp - 24]
        mov     bl, byte [rbx]
        mov     [rax], byte bl

        inc     rax
        mov     [rbp - 16], rax
        
        mov     rax, qword [rbp - 24]
        inc     rax
        mov     [rbp - 24], rax

        jmp     .loop
    .end:

    add     rsp, 24
    pop     rbx
    pop     rax
    pop     rbp
    ret

