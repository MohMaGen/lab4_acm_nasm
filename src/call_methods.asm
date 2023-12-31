extern function
extern range
extern derivative
extern left_rects
extern right_rects
extern middle_rects
extern trapezoids
extern parabolas
extern kortes_6
extern printf
global methods

section .text
methods: 
    movsd   xmm0, qword [num]
    call    function
    call    .print_xmm0
    
    movsd   xmm0, qword [error]
    movsd   xmm1, qword [num]
    mov     rdi, function
    call    derivative
    call    .print_xmm0
    
    
    movsd   xmm0, qword [from]
    movsd   xmm1, qword [end]
    mov     rdi, qword [n]
    mov     rsi, function
    call    left_rects
    call    .print_xmm0
    
    movsd   xmm0, qword [from]
    movsd   xmm1, qword [end]
    mov     rdi, qword [n]
    mov     rsi, function
    call    right_rects
    call    .print_xmm0
    
    movsd   xmm0, qword [from]
    movsd   xmm1, qword [end]
    mov     rdi, qword [n]
    mov     rsi, function
    call    middle_rects
    call    .print_xmm0
    
    movsd   xmm0, qword [from]
    movsd   xmm1, qword [end]
    mov     rdi, qword [n]
    mov     rsi, function
    call    trapezoids
    call    .print_xmm0
    
    movsd   xmm0, qword [from]
    movsd   xmm1, qword [end]
    mov     rdi, qword [n]
    mov     rsi, function
    call    parabolas
    call    .print_xmm0
    
    movsd   xmm0, qword [from]
    movsd   xmm1, qword [end]
    mov     rdi, qword [n]
    mov     rsi, function
    call    kortes_6
    call    .print_xmm0

    ret

    .print_xmm0:        
        mov     rdi, format_double
        mov     eax, 1
        call    printf wrt ..plt
        ret

    .print_rax: 
        mov     rdi, format_int
        mov     rsi, rax
        mov     eax, 0
        call    printf wrt ..plt
        ret

section .rodata
    message:
        db  "Hello, world", 0
    format:
        db  "<%s>", 10, 0
    format_double:
        db  "xmm0 is %lf", 10, 0
    format_int:
        db  "rax is %d", 10, 0
    num:
        dq  2.4
    error:
        dq  0.001
    from:
        dq  -1.4
    end: 
        dq  4.3
    n:  
        dq  15
