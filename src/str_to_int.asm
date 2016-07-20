; Function str_to_int
;     Convert a number in ASCII string format to an integer.
;
; Inputs:
;     rdi: The string to parse
;     rsi: The number of characters to consider part of the string
;
; Outputs:
;     rax: 0 on success, -1 on failure
;     rcx: The parsed integer

section .text

global str_to_int:function
str_to_int:

    ; Check for a negative sign at the beginning of the input string
    xor r9, r9
    cmp byte [rdi], '-'
    jne str_to_int_positive

        ; Negative string found: record this fact and skip first character
        mov r9, 1
        dec rsi
        inc rdi

    str_to_int_positive:

    ; Initialize scale
    mov r8, 1

    ; Initialize return value
    mov rcx, 0

    str_to_int_loop:

        ; Loop until rsi (input_len) has decremented to 0
        cmp rsi, 0
        jle str_to_int_loop_end

        ; Decrement character index
        dec rsi

        ; Load a char from input (in reverse order)
        mov al, [rdi + rsi]

        ; Char must be >= ASCII 0
        cmp al, '0'
        jl str_to_int_err_non_digit

        ; Char must be <= ASCII 9
        cmp al, '9'
        jg str_to_int_err_non_digit

        ; Convert ASCII digit to integer
        sub rax, '0'

        ; Multiply digit by scale
        imul rax, r8

        ; Add scaled digit to return value
        add rcx, rax

        ; Multiply scale by 10 for next iteration (1 -> 10 -> 100 -> 1000)
        imul r8, 10

    jmp str_to_int_loop

    str_to_int_loop_end:

        ; If the number is negative, multiply the result by -1
        cmp r9, 1
        jne str_to_int_no_sign
        imul rcx, -1

    str_to_int_no_sign:

        ; Successful return
        mov rax, 0
        jmp str_to_int_ret

    str_to_int_err_non_digit:
        mov rax, -1

    str_to_int_ret:
        ret
