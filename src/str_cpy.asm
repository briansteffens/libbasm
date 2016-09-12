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

section .text

global str_cpy:function
str_cpy:

; Get input length
    call str_len

; Char index counter. Start one higher to include null-termination character.
    mov rcx, rax
    inc rcx

loop_start:
    test rcx, rcx
    jl loop_end

    mov dl, [rdi + rcx]
    mov [rsi + rcx], dl

    dec rcx
    jmp loop_start

loop_end:
    ret
