%include "common.asm"

section .data

    PARAM_INPUT equ 24
    PARAM_INPUT_LEN equ 16

    LOCAL_BYTES equ 16
    LOCAL_MULTIPLIER equ -8
    LOCAL_RET equ -16

    ASCII_DIGIT_0 equ 48
    ASCII_DIGIT_9 equ 57

section .text

;   Function str_to_int
;       Converts a number in ASCII string format to an integer.
;
;   Stack arguments:
;       INPUT     - The string to parse
;       INPUT_LEN - The number of characters in INPUT to consider part of the
;                   string
;
;   Return values:
;       rax       - 0 if success, otherwise failure
;                   -1 if any chars were not digits
;       rbx       - The parsed integer if successful

global str_to_int:function
str_to_int:
    push rbp
    mov rbp, rsp
    sub rsp, LOCAL_BYTES

    mov rbx, [rbp + PARAM_INPUT]
    mov rdx, [rbp + PARAM_INPUT_LEN]

; Initialize MULTIPLIER
    mov qword [rbp + LOCAL_MULTIPLIER], 1

; Initialize RET
    mov qword [rbp + LOCAL_RET], 0

str_to_int_loop:

; Decrement character index
    dec rdx

; Load a char from INPUT (in reverse order)
    mov rax, 0
    mov al, [rbx + rdx]

; Char must be >= ASCII 0
    cmp al, ASCII_DIGIT_0
    jl str_to_int_err_non_digit

; Char must be <= ASCII 9
    cmp al, ASCII_DIGIT_9
    jg str_to_int_err_non_digit

; Convert ASCII digit to integer
    sub rax, ASCII_DIGIT_0

; Scale digit by MULTIPLIER
    mov rcx, [rbp + LOCAL_MULTIPLIER]
    imul rax, rcx

; Add scaled digit to RET
    mov rcx, [rbp + LOCAL_RET]
    add rax, rcx
    mov [rbp + LOCAL_RET], rax

; Scale up multiplier for next iteration (1 -> 10 -> 100 -> 1000)
    mov rax, [rbp + LOCAL_MULTIPLIER]
    mov rcx, 10
    imul rax, rcx
    mov [rbp + LOCAL_MULTIPLIER], rax

; Loop until rdx (PARAM_INPUT_LEN) has decremented to zero
    cmp rdx, 0
    jg str_to_int_loop

; Successful return
    mov rax, 0
    mov rbx, [rbp + LOCAL_RET]
    jmp str_to_int_ret

str_to_int_err_non_digit:
    mov rax, -1

str_to_int_ret:
    mov rsp, rbp
    pop rbp
    ret
