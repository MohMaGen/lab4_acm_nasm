extern malloc
extern free
extern printf

global dinamic_try

section .rodata
    format:
        db     "%d ",10,0

section .text
dinamic_try:
    push     rbp
    mov      rbp, rsp
    sub      rsp, 32

    mov      edi, 80
    call     malloc
    mov      qword [rbp - 16], rax ; *arr
    
    mov      rax, 0
    mov      [rbp - 24], rax
    .loop1:
        mov      rax, [rbp - 24]
        mov      rbx, 10
        cmp      rax, rbx
        jnl      .end_loop1

        mov     rax, qword [rbp - 24]
        mov     rbx, 8
        mul     rbx
        mov     rbx, qword [rbp - 16]
        add     rax, rbx
        mov     rbx, rax
        mov     rax, qword [rbp - 24]
        mov     qword [rbx], rax
        
         
        mov     rax, [rbp - 24]
        inc     rax
        mov     [rbp - 24], rax 

        jmp      .loop1
        
    .end_loop1:


    
    mov      rax, 0
    mov      [rbp - 24], rax
    
    .loop:
        mov      rax, [rbp - 24]
        mov      rbx, 10
        cmp      rax, rbx
        jnl      .end_loop

        mov     rax, [rbp - 24]
        mov     rbx, 8
        mul     rbx
        mov     rbx, qword [rbp - 16]
        add     rax, rbx
        mov     rsi, qword [rax]
        
        push    rbp
        lea     rdi, [rel format]
        mov     rax, 0
        call    printf
        pop     rbp

         
        mov     rax, [rbp - 24]
        inc     rax
        mov     [rbp - 24], rax 

        jmp      .loop
        
    .end_loop:


    mov     rdi, qword [rbp - 16]
    call    free
    

    add      rsp, 32
    pop      rbp
    ret
