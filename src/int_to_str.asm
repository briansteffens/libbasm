;   Function int_to_str
;       Convert an integer to an ASCII string representation.
;
;   Arguments:
;       rdi - The integer to convert.
;       rsi - The output buffer. It should have enough space to accommodate the
;             number of digits in rdi, plus 1 for a dash (if negative).
;
;   Return values:
;       rax - The number of digits written to rsi.

section .text

global int_to_str:function
int_to_str:

; Load input variable
    mov rax, rdi

; Load divisor
    mov r8, 10

; Digit counter
    xor rcx, rcx

; Negative flag
    xor r9, r9

; Check if negative
    test rax, rax
    jge not_negative

; Negative input. Prepend dash to output, rax=abs(rax), r9=1
    mov r9, 1
    mov byte [rsi], '-'
    inc rsi
    imul rax, -1

not_negative:


convert_loop:
    xor rdx, rdx
    div r8

; Convert remainder (digit) to ASCII and push onto the stack
    add rdx, '0'
    push rdx

; Count the new digit
    inc rcx

    test rax, rax
    jg convert_loop


; Store digit count for return
    mov rax, rcx

; Add 1 to return if negative to account for the dash
    test r9, r9
    je ret_positive
    inc rax
ret_positive:


reverse_loop:
    test rcx, rcx
    je reverse_loop_done

; Pop ASCII digits off the stack in reverse order and write to output
    pop rdx
    mov [rsi], dl

; Move output pointer ahead
    inc rsi

; Decrement counter
    dec rcx

    jmp reverse_loop

reverse_loop_done:


; Null-terminate the output
    mov byte [rsi], 0


    ret
