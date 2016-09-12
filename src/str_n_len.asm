; Function str_n_len
;     Count the number of characters in a null-terminated string, up to a
;     configurable limit.
;
; Inputs:
;     rdi: string to count
;     rsi: maximum characters to check
;
; Outputs:
;     rax: length of string

section .text

global str_n_len:function
str_n_len:
    mov rax, 0

loop_start:
    cmp rax, rsi
    jge loop_end

    cmp byte [rdi + rax], 0
    je loop_end

    inc rax
    jmp loop_start

loop_end:
    ret
