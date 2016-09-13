; Function str_rev
;     Reverse string in-place in memory.
;
; Inputs:
;     rdi: The string to reverse.
;     rsi: The number of characters to include in the reversal.

section .text

global str_rev
str_rev:

; Get the mid-point in the string
    mov rax, rsi
    xor rdx, rdx
    mov rcx, 2
    idiv rcx

; Start the end pointer
    add rsi, rdi
    dec rsi

loop_start:
    test rax, rax
    je loop_end

; Swap a character
    mov dl, [rsi]
    mov cl, [rdi]
    mov [rdi], dl
    mov [rsi], cl

; Next
    dec rax
    inc rdi
    dec rsi
    jmp loop_start

loop_end:
    ret
