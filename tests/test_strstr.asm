%include "common.asm"

extern strstr

section .data

    haystack db "Greetings!", 0
    needle db "ing", 0

section .text

global _start
_start:
    push haystack          ; String to search
    push needle            ; String to search for
    call strstr
    add rsp, 16

    mov rbx, rax
    mov rax, SYS_EXIT
    int LINUX
