%include "common.asm"

default rel

section .text

global str_cmp
str_cmp:
    push rbp
    mov rbp, rsp

; Set char index
    mov rcx, 0

; Put the input strings in rbx and rdx
    mov rbx, [rbp + 16]
    mov rdx, [rbp + 24]

str_cmp_loop_start:
; Load the byte to be compared from both strings into al and ah
    mov al, [rbx + rcx]
    mov ah, [rdx + rcx]

; Compare the chars, any chars unmatching = no match
    cmp al, ah
    jne str_cmp_no_match

; If they match but one is a null, string ends, it's a match
    cmp al, 0
    je str_cmp_match

    cmp ah, 0
    je str_cmp_match

; Match but neither is a null, increment char index and loop again
    inc rcx
    jmp str_cmp_loop_start

str_cmp_no_match:
    mov rax, 0
    jmp str_cmp_ret

str_cmp_match:
    mov rax, 1

str_cmp_ret:
    mov rsp, rbp
    pop rbp
    ret
