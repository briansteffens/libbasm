%include "common.asm"

extern str_cmp

section .data

    left  db "Greetings!", 0
    right db "Greetings!", 0

section .text
global _start
_start:
    mov rdi, left
    mov rsi, right
    call str_cmp
    mov rdi, rax

    mov rax, 60
    syscall
