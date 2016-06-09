%include "common.asm"

extern allocate
extern reallocate
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


;   Function vector_resize
;       Change the size of the vector, reallocating if necessary
;
;   Stack arguments:
;       VECTOR_ADDR - The address of the vector to resize
;       NEW_COUNT   - The new element count
;
;   Return arguments:
;       rax - The new address of the vector (if it changed)
;             If < 0, there was an error

global vector_resize:function
    %define RESIZE_VECTOR_ADDR 24
    %define RESIZE_NEW_COUNT 16
vector_resize:
    push rbp
    mov rbp, rsp

; Get the start of the vector header
    mov rbx, [rbp + RESIZE_VECTOR_ADDR]
    sub rbx, HEADER_SIZE

; If the new size will not grow the array, this is a no-op
    mov rcx, [rbp + RESIZE_NEW_COUNT]
    cmp rcx, [rbx + HEADER_OFFSET_COUNT]
    jle vector_resize_no_op

; If enough room has been previously allocated, we don't need to reallocate
    cmp rcx, [rbx + HEADER_OFFSET_ALLOCATED]
    jle vector_resize_no_reallocate

; Pre-allocate twice what is requested
; TODO: consider other allocation strategies
    imul rcx, 2
    push rcx

; Calculate new size in bytes
    mov rcx, rdx
    imul rcx, [rbx + HEADER_OFFSET_ELEMENT_SIZE]
    add rcx, HEADER_SIZE

; Allocate more space
    push rbx
    push rcx
    call reallocate
    add rsp, 16
    cmp rax, 0
    jl vector_resize_ret
    mov rbx, rax

; Save new allocated count to vector header
    pop rcx
    mov [rbx + HEADER_OFFSET_ALLOCATED], rcx

vector_resize_no_reallocate:

; Update count in header
    mov rcx, [rbp + RESIZE_NEW_COUNT]
    mov [rbx + HEADER_OFFSET_COUNT], rcx

; Return first element of vector
    add rbx, HEADER_SIZE
    mov rax, rbx

    jmp vector_resize_ret

vector_resize_no_op:
    mov rax, [rbp + RESIZE_VECTOR_ADDR]
    jmp vector_resize_ret

vector_resize_ret:
    mov rsp, rbp
    pop rbp
    ret


;   Function vector_get
;       Get the address of an element in a vector by index
;
;   Stack arguments:
;       VECTOR_ADDR - The address of the vector
;       INDEX       - The 0-based index of the element
;
;   Return values:
;       rax - If > 0, the address of the element. Otherwise, error.

global vector_get:function
    %define GET_VECTOR_ADDR 24
    %define GET_INDEX 16
vector_get:
    push rbp
    mov rbp, rsp

; Get vector element size
    mov rbx, [rbp + GET_VECTOR_ADDR]
    sub rbx, HEADER_SIZE
    mov rax, [rbx + HEADER_OFFSET_ELEMENT_SIZE]

; Multiply by index to get starting offset from first element
    imul rax, [rbp + GET_INDEX]

; Add vector header start and vector header size to get actual address
    add rax, rbx
    add rax, HEADER_SIZE

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
