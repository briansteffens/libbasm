extern int_to_hex

section .bss

    output: resb 16

section .text

global _start
_start:

    mov rdi, 0x3210123
    mov rsi, output
    call int_to_hex

    mov rax, 1
    mov rdi, 1
    mov rsi, output
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
