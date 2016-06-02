%include "common.asm"

extern str_rev

section .data

    string db "Greetings!", 0
    ;string db "Farewell!", 0

section .text

global _start
_start:
    push string                     ; String to reverse
    push 9                          ; Number of chars to include
    call str_rev
    add rsp, 16

    mov rax, SYS_FILE_WRITE
    mov rbx, STDOUT
    mov rcx, string
    mov rdx, 12                     ; Number of chars to print
    int LINUX

    mov rbx, 0
    mov rax, SYS_EXIT
    int LINUX
