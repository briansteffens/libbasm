extern hex_to_int

section .data

    input: db "4af7"
    input_len equ $-input

section .text

global _start
_start:

    mov rdi, input
    mov rsi, input_len
    call hex_to_int

    mov rax, 60
    mov rdi, rdx
    syscall
