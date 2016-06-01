%include "common.asm"

section .data

    PARAM_PROMPT equ 40
    PARAM_PROMPT_LEN equ 32
    PARAM_BUFFER equ 24
    PARAM_BUFFER_LEN equ 16

section .text

;   Function prompt
;       Accepts input from STDIN with bounds-checking and a prompt on STDOUT.
;
;   Stack arguments:
;       PROMPT     - The text to print on STDOUT to prompt the user
;       PROMPT_LEN - The number of chars to print from PROMPT
;       BUFFER     - The buffer to write user input to. Must have at least one
;                    more byte available than indicated by BUFFER_LEN to
;                    accommodate newline from STDIN.
;       BUFFER_LEN - The max number of chars to accept from STDIN.
;
;   Return values:
;       rax        - If non-negative, the number of characters read into BUFFER
;                    If -1, the user entered too many characters
;                    If < -1, unknown (probably IO related) error

global prompt:function
prompt:
    push rbp
    mov rbp, rsp

; Write prompt text
    mov rax, SYS_FILE_WRITE
    mov rbx, STDOUT
    mov rcx, [rbp + PARAM_PROMPT]
    mov rdx, [rbp + PARAM_PROMPT_LEN]
    int LINUX

; Error check
    cmp rax, 0
    jl prompt_ret

; Read from STDIN
    mov rax, SYS_FILE_READ
    mov rbx, STDIN
    mov rcx, [rbp + PARAM_BUFFER]
    mov rdx, [rbp + PARAM_BUFFER_LEN]
    inc rdx
    int LINUX

; Check for error code
    cmp rax, 0
    jl prompt_ret

; Check last character read. Should be a newline, otherwise user entered
; too many characters.
    dec rax
    mov rbx, [rbp + PARAM_BUFFER]
    mov rdx, 0
    mov dl, [rbx + rax]
    cmp dl, 10
    jne prompt_err_out_of_bounds

; Blank newline
    mov byte [rbx + rax], 0

    jmp prompt_ret

prompt_err_out_of_bounds:
    mov rax, -1

prompt_ret:
    mov rsp, rbp
    pop rbp
    ret
