; Function hex_to_byte
;     Convert an ASCII hex representation of a byte into an int
;
; Inputs:
;     rdi: The string to parse. Must have at least 2 characters.
;
; Outputs:
;     rax: The parsed value

section .text

global hex_to_byte:function
hex_to_byte:

    mov byte dl, [rdi]
    call convert_digit
    imul rdx, 16
    mov al, dl

    mov byte dl, [rdi + 1]
    call convert_digit
    add al, dl

    ret

convert_digit:

    cmp dl, 'a'
    jge convert_digit_over_9

        sub dl, '0'
        ret

    convert_digit_over_9:

        sub dl, 'a' - 10
        ret
