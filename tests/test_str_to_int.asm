%define sys_exit 60

extern str_to_int

section .data

    input: db "123"
    input_len: equ $-input

section .text

global _start
_start:
    mov rdi, input
    mov rsi, input_len
    call str_to_int

    cmp rax, 0
    jne err

    mov rdi, rcx
    jmp exit

err:
    mov rdi, rax

exit:
    mov rax, sys_exit
    syscall
