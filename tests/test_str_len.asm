%include "common.asm"

extern str_len

section .data

    input db "Greetings!\0"

section .text

global _start
_start:
    push input
    call str_len
    add rsp, 8
    mov rbx, 0
    mov bl, al

    mov rax, SYS_EXIT
    int LINUX
