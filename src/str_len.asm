%include "common.asm"

section .text

global str_len:function
str_len:
    push rbp
    mov rbp, rsp

    mov rcx, -1
    mov rbx, [rbp + 16]

str_len_loop_start:
    inc rcx
    mov al, [rbx + rcx]
    cmp al, 0
    jne str_len_loop_start

    mov rax, rcx

    mov rsp, rbp
    pop rbp
    ret
