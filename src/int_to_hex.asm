; Function int_to_hex
;     Convert an integer to an ASCII hex string
;
; Inputs:
;     rdi: The integer to convert to hex
;     rsi: The string to write the hex to. Must contain enough bytes to store
;          the entire output (max 17).
;
; Outputs:
;     rax: The number of characters written to rsi

extern byte_to_hex

section .text

global int_to_hex:function
int_to_hex:

; rbx tracks number of bytes written to rsi (output string)
; r12 is the loop counter, keeping track of number of bytes on/off stack
; r13 stores original value of rsi (output string)
; r14 tracks whether the input (rdi) was negative

    push rbx
    push r12
    push r13
    push r14

    xor rbx, rbx
    xor r12, r12
    mov r13, rsi
    xor r14, r14

; Check if input integer is negative
    cmp rdi, 0
    jge input_positive
; Yes, it's negative. r14=1, rdi=abs(rdi) and prepend a dash to output string
    imul rdi, -1
    mov r14, 1
    mov byte [r13], '-'
    inc r13
input_positive:

; Copy bytes from input integer onto the stack to reverse them

reverse_start:
    mov al, dil
    push rax
    shr rdi, 8
    inc r12
    test rdi, rdi
    jne reverse_start

; Pop bytes back off the stack in reverse order and convert to hex

loop_start:
    test r12, r12
    je loop_done

    pop rdi
    mov rsi, r13
    add rsi, rbx
    mov rdx, rbx
    call byte_to_hex
    add rbx, rax

    dec r12
    jmp loop_start

loop_done:

; Return number of characters written
    mov rax, rbx

; If a dash was prepended to the output, increment return value
    test r14, r14
    je return_not_negative
    inc rax
return_not_negative:

    pop r14
    pop r13
    pop r12
    pop rbx

    ret
