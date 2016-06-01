%include "common.asm"

extern prompt

section .bss

    BUFFER_LEN equ 5
    BUFFER resb BUFFER_LEN

section .data

    PROMPT db "Enter some text: ", 0
    PROMPT_LEN equ $-PROMPT

    NEWLINE db 10
    NEWLINE_LEN equ $-NEWLINE

section .text

global _start
_start:
    mov rbp, rsp

    push PROMPT
    push PROMPT_LEN
    push BUFFER
    push BUFFER_LEN
    call prompt
    add rsp, 32

    cmp rax, 0
    jl err

; Print result
    mov rdx, rax
    mov rax, SYS_FILE_WRITE
    mov rbx, STDOUT
    mov rcx, BUFFER
    int LINUX

; Print newline
    mov rax, SYS_FILE_WRITE
    mov rbx, STDOUT
    mov rcx, NEWLINE
    mov rdx, NEWLINE_LEN
    int LINUX

    mov rbx, 0
    jmp exit

err:
    mov rbx, rax

exit:
    mov rax, SYS_EXIT
    int LINUX
