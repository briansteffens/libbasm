%include "common.asm"

%define PARAM_INPUT 24
%define PARAM_OUTPUT 16
%define ASCII_DIGIT_0 48

section .text

;   Function int_to_str
;       Convert an integer to an ASCII string representation.
;
;   Stack arguments:
;       INPUT     - The integer to convert
;       OUTPUT    - The output buffer. It should have enough space to
;                   accommodate the number of digits in INPUT + 1 for the null
;                   termination character.
;
;   Return values:
;       rax       - 0 if success, otherwise failure
;       rbx       - The number of digits written to OUTPUT (not including null)

global int_to_str:function
int_to_str:
    push rbp
    mov rbp, rsp

; Load input variable
    mov rax, [rbp + PARAM_INPUT]

; Load divisor
    mov rbx, 10

; Digit counter
    xor rcx, rcx


int_to_str_convert_loop:
    xor rdx, rdx
    div rbx

; Convert remainder (digit) to ASCII and push onto the stack
    add rdx, ASCII_DIGIT_0
    push rdx

; Count the new digit
    inc rcx

    cmp rax, 0
    jg int_to_str_convert_loop

; Store digit count for return
    mov rbx, rcx


; Load buffer output
    mov rdx, [rbp + PARAM_OUTPUT]

int_to_str_reverse_loop:

; Pop ASCII digits off the stack in reverse order and write to output
    pop rax
    mov [rdx], al

; Move output pointer ahead
    inc rdx

; Decrement counter
    dec rcx

; Loop while counter > 0
    cmp rcx, 0
    jge int_to_str_reverse_loop


; Null-terminate the output
    mov byte [rdx], 0


; Successful return code
    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret
