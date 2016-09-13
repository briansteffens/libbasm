; Function str_str
;     Find the location of the first needle within haystack.
;
; Inputs:
;     rdi: haystack (the string to search)
;     rsi: needle (the string to search for)
;
; Outputs:
;     rax: The index of the beginning of needle within haystack. Negative if
;          not found.

section .text

global str_str:function
str_str:

; Store original rdi
    mov rdx, rdi

haystack_loop_start:
    cmp byte [rdi], 0
    je end_no_match

; Needle indexer
    xor rcx, rcx

needle_loop_start:

; End of needle -> match
    cmp byte [rsi + rcx], 0
    je end_match

; End of haystack -> no match
    mov al, [rdi + rcx]
    cmp al, 0
    je end_no_match

; Unmatching, non-null chars -> needle not found here
    cmp al, [rsi + rcx]
    jne next_haystack

    inc rcx
    jmp needle_loop_start

next_haystack:
    inc rdi
    jmp haystack_loop_start

end_match:
    mov rax, rdi
    sub rax, rdx
    ret

end_no_match:
    mov rax, -1
    ret
