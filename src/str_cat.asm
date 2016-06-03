%include "common.asm"

section .text

global str_cat:function
    %define source  24
    %define dest    16
str_cat:
    push rbp
    mov rbp, rsp

; Find end of dest string (first null char)
    mov rbx, [rbp + dest]
str_cat_find_end:
    mov dl, [rbx]
    inc rbx
    cmp dl, 0
    jne str_cat_find_end
    dec rbx

; Copy source to destination
    mov rax, [rbp + source]
str_cat_copy:
    mov dl, [rax]
    mov [rbx], dl
    inc rax
    inc rbx
    cmp dl, 0
    jne str_cat_copy

    mov rsp, rbp
    pop rbp
    ret
