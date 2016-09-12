; Function str_len
;     Count the number of characters in a null-terminated string.
;
; Inputs:
;     rdi: string to count
;
; Outputs:
;     rax: length of string

section .text

global str_len:function
str_len:

    xor rax, rax

loop_start:
    cmp byte [rdi + rax], 0
    je loop_end

    inc rax
    jmp loop_start

loop_end:
    ret
