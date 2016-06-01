%include "common.asm"

extern strcpy

section .bss

    target: resb 255

section .data

    source db "Greetings!", 0

section .text

global _start
_start:
    push source
    push target
    call strcpy
    add rsp, 16

    mov rdx, rax
    mov rax, SYS_FILE_WRITE
    mov rbx, STDOUT
    mov rcx, target
    int LINUX

    mov rbx, rdx
    mov rax, SYS_EXIT
    int LINUX
