%include "common.asm"

extern allocate
extern deallocate

%define HEADER_SIZE 24
%define HEADER_OFFSET_COUNT 0           ; Number of elements used
%define HEADER_OFFSET_ALLOCATED 8       ; Number of elements allocated
%define HEADER_OFFSET_ELEMENT_SIZE 16   ; Size of each element in bytes

section .text

;   Function vector_new
;       Create a new vector
;
;   Stack arguments:
;       ITEM_SIZE - The number of bytes per element in the vector
;
;   Return values:
;       rax       - The memory address of the first element in the vector
;                   Or a negative number if the operation failed

global vector_new:function
    %define ITEM_SIZE 16
vector_new:
    push rbp
    mov rbp, rsp

; Calculate the total bytes needed for header plus initial allocation
    mov rbx, [rbp + ITEM_SIZE]
    add rbx, HEADER_SIZE

; Allocate the memory
    push rbx
    call allocate
    add rsp, 8
    cmp rax, 0
    je vector_new_err

; Set up vector header
    mov qword [rax + HEADER_OFFSET_COUNT], 0
    mov qword [rax + HEADER_OFFSET_ALLOCATED], 1
    mov rbx, [rbp + ITEM_SIZE]
    mov [rax + HEADER_OFFSET_ELEMENT_SIZE], rbx

; Return the address of the first element
    add rax, HEADER_SIZE
    jmp vector_new_ret

vector_new_err:
    mov rax, -1

vector_new_ret:
    mov rsp, rbp
    pop rbp
    ret


;   Function vector_len
;       Get the number of items in the vector
;
;   Stack arguments:
;       LEN_VECTOR_ADDR - The address of the vector
;
;   Return values:
;       rax - The number of items in the vector

global vector_len:function
    %define LEN_VECTOR_ADDR 16
vector_len:
    push rbp
    mov rbp, rsp

; Get the start of the vector header
    mov rbx, [rbp + LEN_VECTOR_ADDR]
    sub rbx, HEADER_SIZE

; Return the count
    mov rax, [rbx + HEADER_OFFSET_COUNT]

    mov rsp, rbp
    pop rbp
    ret


;   Function vector_free
;       Frees memory associated with a vector created with vector_new
;
;   Stack arguments:
;       VECTOR_ADDR - The address of the vector to free

global vector_free:function
    %define VECTOR_ADDR 16
vector_free:
    push rbp
    mov rbp, rsp

; Get the start of the vector header
    mov rbx, [rbp + VECTOR_ADDR]
    sub rbx, HEADER_SIZE

; Free the vector including header
    push rbx
    call deallocate
    add rsp, 8

    mov rsp, rbp
    pop rbp
    ret
