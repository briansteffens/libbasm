%include "common.asm"

default rel

section .text

; Function str_cmp
;     Compare two strings for equality.
;
; Inputs:
;     rdi: The first string to compare
;     rsi: The second string to compare
;
; Outputs:
;     rax: 1 if the strings match, 0 otherwise

global str_cmp
str_cmp:

; Set char index
    mov rcx, 0

loop_start:

; Load left character into a register
    mov al, [rdi + rcx]

; Compare the chars, any chars unmatching = no match
    cmp [rsi + rcx], al
    jne no_match

; If the chars match but it's a null (string ends) it's a match
    cmp al, 0
    je match

; Chars match but not null: increment char index and loop again
    inc rcx
    jmp loop_start

no_match:
    mov rax, 0
    ret

match:
    mov rax, 1
    ret
