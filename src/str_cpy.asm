%include "common.asm"

section .text

global str_cpy:function
str_cpy:
    push rbp
    mov rbp, rsp

; Set char index
    mov rcx, 0

; Put the input buffer in ebx
    mov rbx, [rbp + 24]

; Put the output buffer in edx
    mov rdx, [rbp + 16]

str_cpy_loop_start:
; Load the next byte from source into al
    mov al, [rbx + rcx]

; Save the byte into the target
    mov [rdx + rcx], al

; Increment character index
    inc rcx

; Check for null char and end copy if so
    cmp al, 0
    jne str_cpy_loop_start

; Copy bytes written to eax for return value
    mov rax, rcx

    mov rsp, rbp
    pop rbp
    ret
