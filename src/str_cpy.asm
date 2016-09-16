; Function str_cpy
;     Copy data from one string to another.
;
; Inputs:
;     rdi: input string
;     rsi: output string
;
; Outputs:
;     rax: number of bytes written to output

extern str_len
extern str_n_cpy

section .text

global str_cpy:function
str_cpy:

; Get input length
    call str_len
    mov rcx, rax

; Char index counter. Start one higher to include null-termination character.
    mov rdx, rcx
    inc rdx

; Call copy function
    call str_n_cpy

    mov rax, rcx

    ret
