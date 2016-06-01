%include "common.asm"

extern allocate
extern reallocate
extern deallocate

section .bss

    string resq 0

section .text

global _start
_start:
    mov rbp, rsp

; Allocate a string
    push 4
    call allocate
    add rsp, 8
    cmp rax, 0
    je err
    mov [string], rax

; Write some text to the string
    mov rbx, string
    mov rcx, 0
    mov byte [rbx + rcx], 72
    inc rcx
    mov byte [rbx + rcx], 105
    inc rcx
    mov byte [rbx + rcx], 10
    inc rcx
    mov byte [rbx + rcx], 0

; Write string to stdout
    mov rax, SYS_FILE_WRITE
    mov rbx, STDOUT
    mov rcx, string
    mov rdx, 3
    int LINUX
    cmp rax, 0
    jl err

; Increase segment size
    push string
    push 7
    call reallocate
    add rsp, 16
    cmp rax, 0
    jl err
    mov [string], rax

; Add more text to string
    mov rbx, string
    mov rcx, 3
    mov byte [rbx + rcx], 58
    inc rcx
    mov byte [rbx + rcx], 68
    inc rcx
    mov byte [rbx + rcx], 10
    inc rcx
    mov byte [rbx + rcx], 0

; Write string to stdout
    mov rax, SYS_FILE_WRITE
    mov rbx, STDOUT
    mov rcx, string
    mov rdx, 6
    int LINUX
    cmp rax, 0
    jl err

; Free the string
    push string
    call deallocate
    add rsp, 8

    mov rbx, 0
    jmp exit

err:
    mov rbx, rax

exit:
    mov rax, SYS_EXIT
    int LINUX
