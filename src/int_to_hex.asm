; Function int_to_hex
;     Convert an integer to an ASCII hex string
;
; Inputs:
;     rdi: The integer to convert to hex
;     rsi: The string to write the hex to. Must contain enough bytes to store
;          the entire output (max 16).
;
; Outputs:
;     rax: 0 on success, -1 on failure
;     rdx: The number of characters written to rsi

extern byte_to_hex

section .text

global int_to_hex:function
int_to_hex:

    push rbx
    push r12
    push r13

    xor rbx, rbx
    xor r12, r12
    mov r13, rsi

; Copy bytes from input integer onto the stack to reverse them

reverse_start:
    mov al, dil
    push rax
    shr rdi, 8
    inc r12
    test rdi, rdi
    jne reverse_start

loop_start:
    test r12, r12
    je loop_done

    pop rdi
    mov rsi, r13
    add rsi, rbx
    mov rdx, rbx
    call byte_to_hex
    test rax, rax
    jne err
    add rbx, rdx

    dec r12
    jmp loop_start

err:
    mov rax, -1
    jmp return

loop_done:
    mov rax, 0
    mov rdx, rbx

return:
    pop r13
    pop r12
    pop rbx

    ret
