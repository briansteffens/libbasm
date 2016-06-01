%include "common.asm"

section .text

global strlen:function
strlen:
    push rbp
    mov rbp, rsp

    mov rcx, -1
    mov rbx, [rbp + 16]

strlen_loop_start:
    inc rcx
    mov al, [rbx + rcx]
    cmp al, 0
    jne strlen_loop_start

    mov rax, rcx

    mov rsp, rbp
    pop rbp
    ret
