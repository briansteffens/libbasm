; Function byte_to_hex
;     Convert a byte to an ASCII hex representation.
;
; Inputs:
;     rdi: The byte to convert
;     rsi: The string to write the output to, must be large enough to contain
;          the output (1 or 2 bytes)
;     rdx: Zero-padding: if 1, the output will always be 2 digits (03, 0f, etc)
;
; Outputs:
;     rax: Number of characters written to rsi (1 or 2)

section .text

global byte_to_hex:function
byte_to_hex:

    xor r8, r8

    mov rax, rdi
    mov r9, rdx
    xor rdx, rdx

    mov rcx, 16
    idiv rcx

; If zero-padding was requested, always do the first digit
    test r9, r9
    jne first_digit

; Skip the first digit if it would be a 0 anyway
    test al, al
    je second_digit

first_digit:
    call convert_digit
    mov byte [rsi], al
    mov r8, 1

second_digit:
    mov rax, rdx
    call convert_digit
    mov byte [rsi + r8], al
    inc r8

    mov rax, r8
    ret


convert_digit:

    cmp rax, 9
    jg convert_digit_over_9

        add rax, '0'
        ret

    convert_digit_over_9:

        add rax, 'a' - 10
        ret
