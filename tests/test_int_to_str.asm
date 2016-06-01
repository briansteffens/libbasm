%include "common.asm"

extern int_to_str

section .bss

    BUFFER_LEN equ 16
    BUFFER resb BUFFER_LEN

    counter resq 0

section .text

global _start
_start:
    mov rbp, rsp

    push 33278
    push BUFFER
    call int_to_str
    add rsp, 16

    cmp rax, 0
    jne err

    mov rdx, rbx
    mov rax, SYS_FILE_WRITE
    mov rbx, STDOUT
    mov rcx, BUFFER
    int LINUX
    cmp rax, 0
    jl err

    jmp exit

err:
    mov rbx, rax

exit:
    mov rax, SYS_EXIT
    int LINUX
