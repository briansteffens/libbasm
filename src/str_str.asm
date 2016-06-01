%include "common.asm"

section .text

global str_str:function
str_str:
    push rbp
    mov rbp, rsp

    sub rsp, 8                     ; Reserve local storage
    mov qword [rbp - 8], -1        ; Haystack loop iterator

    mov rdx, 0                     ; Haystack iterator

str_str_haystack_loop_start:
    mov rcx, [rbp - 8]             ; Grab haystack iterator
    inc rcx                        ; Next haystack char
    mov [rbp - 8], rcx             ; Save haystack iterator for next loop
    mov rdx, 0                     ; Reset needle iterator

str_str_needle_loop_start:
    mov rbx, [rbp + 24]            ; Load haystack
    mov al, [rbx + rcx]            ; Get haystack byte

    cmp al, 0                      ; End of haystack => no match
    je str_str_end_no_match

    mov rbx, [rbp + 16]            ; Load needle
    mov ah, [rbx + rdx]            ; Get needle byte

    cmp ah, 0                      ; End of needle => match
    je str_str_end_match

    inc rcx                        ; Next char
    inc rdx

    cmp al, ah
    je str_str_needle_loop_start   ; Matching so far, keep checking this offset

    jmp str_str_haystack_loop_start; No match, try next haystack offset

str_str_end_match:
    mov rax, [rbp - 8]             ; Return haystack iterator
    jmp str_str_ret

str_str_end_no_match:
    mov rax, -1                    ; Return -1
    jmp str_str_ret

str_str_ret:
    mov rsp, rbp
    pop rbp
    ret
