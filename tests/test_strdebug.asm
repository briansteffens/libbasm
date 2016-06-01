%include "common.asm"

extern strdebug

section .data

    input db "Greetings!", 0
    input_len equ $-input

section .text

global _start
_start:
    push input
    push input_len
    call strdebug
    add rsp, 16
    mov rbx, 0

    mov rax, SYS_EXIT
    int LINUX
