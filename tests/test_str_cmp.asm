%include "common.asm"

extern str_cmp

section .data

    left  db "Greetings!", 0
    right db "Greetings!", 0

section .text
global _start
_start:
    push left
    push right
    call str_cmp
    add rsp, 16
    mov rbx, rax

    mov rax, SYS_EXIT
    int LINUX
