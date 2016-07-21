; Function byte_to_hex
;     Convert a byte to an ASCII hex representation.
;
; Inputs:
;     rdi: The byte to convert
;     rsi: The string to write the output to, must be at least 2 bytes
;
; Outputs:
;     rax: 0 on success, -1 on failure

section .text

global byte_to_hex:function
byte_to_hex:

    mov rax, rdi
    xor rdx, rdx

    mov rcx, 16
    idiv rcx

    call convert_digit
    mov byte [rsi], al

    mov rax, rdx
    call convert_digit
    mov byte [rsi + 1], al

    ret

convert_digit:

    cmp rax, 10
    jg convert_digit_over_10

        add rax, '0'
        ret

    convert_digit_over_10:

        add rax, 'a' - 10
        ret
