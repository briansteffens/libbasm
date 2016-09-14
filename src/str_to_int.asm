; Function str_to_int
;     Convert a number in ASCII string format to an integer.
;
; Inputs:
;     rdi: The string to parse
;     rsi: The number of characters to consider part of the string
;
; Outputs:
;     rax: The parsed integer

section .text

global str_to_int:function
str_to_int:

    ; Check for a negative sign at the beginning of the input string
    xor r9, r9
    cmp byte [rdi], '-'
    jne positive

        ; Negative string found: record this fact and skip first character
        mov r9, 1
        dec rsi
        inc rdi

    positive:

    ; Initialize scale
    mov r8, 1

    ; Initialize return value
    xor rax, rax

    loop_start:

        ; Loop until rsi (input_len) has decremented to 0
        cmp rsi, 0
        jle loop_end

        ; Decrement character index
        dec rsi

        xor rdx, rdx
        ; Load a char from input (in reverse order)
        mov dl, [rdi + rsi]

        ; Convert ASCII digit to integer
        sub rdx, '0'

        ; Multiply digit by scale
        imul rdx, r8

        ; Add scaled digit to return value
        add rax, rdx

        ; Multiply scale by 10 for next iteration (1 -> 10 -> 100 -> 1000)
        imul r8, 10

        jmp loop_start

    loop_end:

        ; If the number is negative, multiply the result by -1
        cmp r9, 1
        jne return
        imul rax, -1

    return:
        ret
