; Function str_n_cpy
;     Copy n bytes of data from one string to another.
;
; Inputs:
;     rdi: input string
;     rsi: output string
;     rdx: the number of bytes to write

section .text

global str_n_cpy:function
str_n_cpy:

loop_start:
    test rdx, rdx
    jl loop_end

    mov al, [rdi + rdx]
    mov [rsi + rdx], al

    dec rdx
    jmp loop_start

loop_end:
    ret
