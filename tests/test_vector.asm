%include "common.asm"

extern vector_new
extern vector_len
extern vector_free

section .bss

    vec resq 1

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
    call vector_free
    add rsp, 8

    mov rbx, 0
    jmp exit

err:
    mov rbx, rax

exit:
    mov rax, SYS_EXIT
    int LINUX
