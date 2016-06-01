%include "common.asm"

section .data

    string db "Greetings!", 0
    ;string db "Farewell!", 0

section .text

global _start
_start:
    push string                     ; String to reverse
    push 9                          ; Number of chars to include
    call str_rev
    add rsp, 16

    mov rax, SYS_FILE_WRITE
    mov rbx, STDOUT
    mov rcx, string
    mov rdx, 12                     ; Number of chars to print
    int LINUX

    mov rbx, 0
    mov rax, SYS_EXIT
    int LINUX

global str_rev
str_rev:
    push rbp
    mov rbp, rsp

    sub rsp, 8                      ; Reserve 8 bytes for max bytesr

    mov rax, [rbp + 16]             ; Total count -> rax
    mov rbx, 2                      ; Dividing by 2 -> rbx
    idiv rbx                        ; Total count / 2 -> rax
    dec rax
    mov [rbp - 8], rax              ; Store max swaps to perform (-1)

    mov rcx, 0                      ; Start/left counter
    mov rdx, [rbp + 16]             ; End/right counter (len - 1)
    dec rdx

    mov rbx, [rbp + 24]             ; Buffer -> ebx

str_rev_loop_start:
    mov al, [rbx + rcx]             ; Grab char from left
    mov ah, [rbx + rdx]             ; Grab char from right

    mov [rbx + rcx], ah             ; Swap right -> left
    mov [rbx + rdx], al             ; Swap left -> right

    cmp [rbp - 8], rcx              ; Compare left counter to max swaps
    je str_rev_loop_end

    inc rcx                         ; Increment left counter
    dec rdx                         ; Decrement right counter

    jmp str_rev_loop_start

str_rev_loop_end:
    mov rsp, rbp
    pop rbp
    ret
