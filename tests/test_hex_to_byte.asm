extern hex_to_byte

section .data

    input: dd "44"

section .text

global _start
_start:

    mov rdi, input
    call hex_to_byte

    mov rax, 60
    mov rdi, rdx
    syscall
