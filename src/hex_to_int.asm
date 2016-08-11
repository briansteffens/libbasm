; Function hex_to_int
;     Convert an ASCII hex string into an int
;
; Inputs:
;     rdi: The string to parse
;     rsi: The number of characters in rdi to parse
;
; Outputs:
;     rax: 0 on success, -1 on failure
;     rdx: The parsed value

section .text

global hex_to_int:function
hex_to_int:

; Check if input has an even number of characters
    mov rax, rsi
    xor rdx, rdx
    mov r8, 2
    idiv r8
    test rdx, rdx
    je even_num_of_digits

; Odd number of characters: process the first character as one complete byte
    mov byte al, [rdi]
    call convert_digit
    mov dl, al
    inc rdi
    dec rsi
    jmp loop_start

even_num_of_digits:
    xor rdx, rdx

loop_start:
    cmp rsi, 0
    jle loop_end

; Shift running total left to make room for the next byte
    shl rdx, 8

; Process 2 characters (1 byte) at a time
    mov byte al, [rdi]
    call convert_digit
    imul rax, 16
    mov dl, al

    mov byte al, [rdi + 1]
    call convert_digit
    add dl, al

    add rdi, 2
    sub rsi, 2

    jmp loop_start

loop_end:
    mov rax, 0
    ret

convert_digit:

    cmp al, 'a'
    jge convert_digit_over_9

        sub al, '0'
        ret

    convert_digit_over_9:

        sub al, 'a' - 10
        ret
