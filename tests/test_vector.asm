%include "common.asm"

extern vector_new
extern vector_len
extern vector_resize
extern vector_get
extern vector_free

extern allocate

section .bss

    vec resq 1
    temp resq 1

section .text

global _start
_start:
    mov rbp, rsp

    push 8
    call vector_new
    add rsp, 8
    cmp rax, 0
    jl err
    mov [vec], rax

    push qword [vec]
    call vector_len
    add rsp, 8
    cmp rax, 0
    jl err

    push qword [vec]
    push 1
    call vector_resize
    add rsp, 16
    cmp rax, 0
    jl err
    mov [vec], rax

    push 3
    call allocate
    cmp rax, 0
    jl err
    mov [temp], rax

    mov rcx, 0
    mov byte [rax + rcx], 'H'
    inc rcx
    mov byte [rax + rcx], 'i'
    inc rcx
    mov byte [rax + rcx], 0

    push qword [vec]
    push 0
    call vector_get
    add rsp, 16
    cmp rax, 0
    jl err
    mov rbx, temp
    mov qword [rax], rbx

    push qword [vec]
    call vector_free
    add rsp, 8

    mov rbx, 0
    jmp exit

err:
    mov rbx, rax

exit:
    mov rax, SYS_EXIT
    int LINUX
