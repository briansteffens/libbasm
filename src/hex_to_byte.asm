; Function hex_to_byte
;     Convert an ASCII hex representation of a byte into an int
;
; Inputs:
;     rdi: The string to parse. Must have at least 2 characters.
;
; Outputs:
;     rax: 0 on success, -1 on failure
;     rdx: The parsed value

section .text

global hex_to_byte:function
hex_to_byte:

    mov byte al, [rdi]
    call convert_digit
    imul rax, 16
    mov dl, al

    mov byte al, [rdi + 1]
    call convert_digit
    add dl, al

    ret

convert_digit:

    cmp al, 'a'
    jge convert_digit_over_9

        sub al, '0'
        ret

    convert_digit_over_9:

        sub al, 'a' - 10
        ret
