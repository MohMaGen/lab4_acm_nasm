extern malloc
extern free
extern printf
extern fopen
extern fscanf
extern fclose
extern colors_ansi
extern mul_str
extern concat_str
extern copy_str
global alloc_table
global read_column_from_file
global print_table

;
; table (size 24 + ...)
;       columns count (size 8) [0 7] &
;       rows count (size 8) [8 15] &
;       last filled column (size 8) [16 23] &
;       data [columns count * rows count * 8] [24 (23 + cc*rc * 8)]    


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
    mov     rax, qword 0
    mov     [rbx + 16], qword rax

    mov     rax, rbx

    add     rsp, 32
    pop     rbp
    ret

print_table:
    push    rbp 
    push    rax
    push    rbx
    mov     rbp, rsp
    sub     rsp, 64

    mov     [rbp - 16], rdi ; pointer to table

    mov     rax, qword [rbp - 16]
    mov     rbx, qword [rax]
    mov     [rbp - 24], rbx ; columns count
    mov     rbx, qword [rax + 8]
    mov     [rbp - 32], rbx ; rows count

    mov     rbx, qword 24
    add     rax, rbx
    mov     [rbp - 56], rax ; data start
    
    call    .init_buffers

    call    .print_line

    
    mov     rax, qword 0
    mov     [rbp - 40], qword rax ; row iter
    mov     [rbp - 48], qword rax ; column iter

    .rows_loop:
        cmp     rax, qword [rbp - 32]
        jnl     .end_rows_loop

        mov     rax, qword 0 
        mov     [rbp - 48], rax
        .column_loop:
            cmp     rax, qword [rbp - 24]
            jnl     .end_column_loop

            mov     rbx, qword [rbp - 32]
            mul     rbx
            mov     rbx, qword [rbp - 40]
            add     rax, rbx
            mov     rbx, qword 8
            mul     rbx
            mov     rbx, qword [rbp - 56]
            add     rax, rbx

            push    rbp
            lea     rdi, [rel cell_format]
            mov     rsi, qword [rax]
            call    printf
            pop     rbp

            mov     rax, qword [rbp - 48]
            inc     rax
            mov     [rbp - 48], qword rax

            jmp     .column_loop
        .end_column_loop:
        
        push    rbp
        lea     rdi, [rel end_line]
        call    printf
        pop     rbp

        call    .print_line

        mov     rax, qword [rbp - 40]
        inc     rax
        mov     [rbp - 40], qword rax

        jmp     .rows_loop
    .end_rows_loop:

    add     rsp, 64
    pop     rbx
    pop     rax
    pop     rbp
    ret

    .init_buffers: 
        lea     rdi, [rel line_buffer]
        lea     rsi, [rel cell_line]
        mov     rax, qword [rbp - 24]
        mov     rdx, rax
        call    mul_str

        lea     rdi, [rel line_buffer]
        lea     rsi, [rel end_border_line]
        call    concat_str
        ret

    .print_line:
        push    rbp 
        sub     rsp, 8
        lea     rdi, [rel line_buffer]
        mov     rax,0
        call    printf
        add     rsp, 8
        pop     rbp
        ret

section .rodata
    endl:
        db 10,0
    cell_format:
        db  "| %8.4lf ",0
    end_line:
        db  "|",10,0
    end_border_line:
        db  "+",10,0
    cell_line:
        db  "+----------",0
section .bss
    buffer: resb 1024
    line_buffer: resb 1024


section .text
read_column_from_file:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 96

    mov     [rbp - 16], rdi ; point to table 
    mov     [rbp - 24], rsi ; pointer to file name string
    

    lea     rsi, [rel open_mode]
    mov     rsi, [rbp - 24]
    call    fopen
    mov     [rbp - 32], rax ; fd

    mov     rax, [rbp - 16]
    mov     rbx, qword [rax]
    mov     [rbp - 40], rbx ; columns count
    mov     rbx, qword [rax + 8]
    mov     [rbp - 48], rbx ; rows count
    mov     rbx, qword [rax + 16]
    mov     [rbp - 56], rbx ; last filled column

    mov     rax, [rbp - 16]
    mov     rbx, 24
    add     rax, rbx
    mov     [rbp - 80], rax

    
    cmp     rbx, [rbp - 40]
    jnl     .columns_overflow

    
    mov     rax, 0 ; iter
    .read_loop:
        cmp     rax, [rbp - 48]
        jnl     .end_read_loop

        
        push    rax
        push    rbp
        mov     rdi, [rbp - 32]
        lea     rsi, [rel scan_format]
        mov     rbi, [rbp - 64] ; x
        mov     rcx, [rbp - 72] ; f(x ...)
        mov     rax, 0
        call    fscanf
        pop     rbp
        pop     rax
       
        push    rax
        mov     [rbp - 88], rax ; idx

        mov     rax, [rbp - 56]
        mov     rbx, [rbp - 48]
        mul     rbx
        add     rax, [rbp - 88]
        add     rax, [rbp - 80]

        push    rax
        mov     rax, [rbp - 56] 
        cmp     rax, 0
        pop     rax

        je      .write_y 

        .write_x:
            mov     rbx, qword [rbp - 64]
            mov     [rax], rbx

            jmp     .write_end

        .write_y:
            mov     rbx, qword [rbp - 72]
            mov     [rax], rbx

        .write_end:

        pop     rax 
        inc     rax
        
        jmp     .read_loop

    .end_read_loop:


    mov     rdi, [rbp - 32]
    call    fclose


    .return:
        add     rsp, 96
        pop     rbp
        ret

    .columns_overflow:
        push    rbp
        lea     rdi, [rel columns_overflow_error]
        mov     rax, 0
        call    printf
        pop     rbp
        mov     rax, 1
        jmp .return


section .rodata
    scan_format:
        db  "%lf %lf",0
    format:
        db  "%d",10,0
    open_mode:
        db  "r",0
    columns_overflow_error:
        db  ": [ \033[31moverflow error\033[0m ] : cant read column from file"
    

