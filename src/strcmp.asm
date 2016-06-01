%include "common.asm"

section .data

    left  db "Greetings!", 0
    right db "Greetings!", 0

section .text

global _start
_start:
    push left
    push right
    call strcmp
    add rsp, 16
    mov rbx, rax

    mov rax, SYS_EXIT
    int LINUX

global strcmp
strcmp:
    push rbp
    mov rbp, rsp

; Set char index
    mov rcx, 0

; Put the input strings in rbx and rdx
    mov rbx, [rbp + 16]
    mov rdx, [rbp + 24]

strcmp_loop_start:
; Load the byte to be compared from both strings into al and ah
    mov al, [rbx + rcx]
    mov ah, [rdx + rcx]

; Compare the chars, any chars unmatching = no match
    cmp al, ah
    jne strcmp_no_match

; If they match but one is a null, string ends, it's a match
    cmp al, 0
    je strcmp_match

    cmp ah, 0
    je strcmp_match

; Match but neither is a null, increment char index and loop again
    inc rcx
    jmp strcmp_loop_start

strcmp_no_match:
    mov rax, 0
    jmp strcmp_ret

strcmp_match:
    mov rax, 1

strcmp_ret:
    mov rsp, rbp
    pop rbp
    ret
