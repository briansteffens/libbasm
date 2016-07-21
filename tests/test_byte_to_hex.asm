extern byte_to_hex

section .bss

    buffer: resb 2

section .text

global _start
_start:

    mov rdi, 239
    mov rsi, buffer
    call byte_to_hex

    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 2
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
