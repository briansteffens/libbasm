; Function str_len
;     Count the number of characters in a null-terminated string.
;
; Inputs:
;     rdi: string to count
;     rsi: max characters to check
;
; Outputs:
;     rax: length of string

section .text

global str_len:function
str_len:
    mov rax, 0

    strlen_loop:
        cmp byte [rdi + rax], 0
        je strlen_end

        cmp rax, rsi
        jge strlen_end

        inc rax
    jmp strlen_loop

    strlen_end:
        ret
