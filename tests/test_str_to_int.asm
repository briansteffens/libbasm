%include "common.asm"

extern str_to_int

section .data

    INPUT db "123"
    INPUT_LEN equ $-INPUT

section .text

global _start
_start:
    mov rbp, rsp

    push INPUT
    push INPUT_LEN
    call str_to_int
    add rsp, 16

    cmp rax, 0
    jne err

    jmp exit

err:
    mov rbx, rax

exit:
    mov rax, SYS_EXIT
    int LINUX
