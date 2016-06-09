%include "common.asm"

%define HEADER_SIZE 16
%define HDR_AVAIL_OFFSET 0
%define HDR_SIZE_OFFSET 8

%define UNAVAILABLE 0
%define AVAILABLE 1

default rel

section .bss

    heap_begin resq 1
    current_break resq 1

section .text

;   Function allocate_init
;       Initialize the memory management system.

global allocate_init:function
allocate_init:
    push rbp
    mov rbp, rsp

; Look up the current break
    mov rax, SYS_BRK
    mov rbx, 0
    int LINUX

; Store the first valid address
    inc rax
    mov [current_break], rax

; Same value is the heap_begin
    mov [heap_begin], rax

    mov rsp, rbp
    pop rbp
    ret


;   Function allocate
;       Allocate a segment of memory on the heap.
;
;   Stack arguments:
;       MEM_SIZE  - The number of bytes to allocate
;
;   Return values:
;       rax       - 0 if failed, otherwise the address of the newly-allocated
;                   segment.

global allocate:function
    %define ST_MEM_SIZE 16         ; Stack position of memory size to allocate
allocate:
    push rbp
    mov rbp, rsp

; Call allocate_init if necessary
    mov rax, [heap_begin]
    cmp rax, 0
    jne allocate_init_done

    call allocate_init

allocate_init_done:

; Input parameter - bytes to allocate
    mov rcx, [rbp + ST_MEM_SIZE]

; Current search position, looking for a block to reuse
    mov rax, [heap_begin]

; Current break
    mov rbx, [current_break]


; Each iteration of this loop inspects a memory block looking for an available
; one with enough space to satisfy the request.
allocate_loop:

; If we get to the end of the allocated memory without finding a candidate,
; request more memory from the OS.
    cmp rax, rbx
    je allocate_more

; Get the size of this block
    mov rdx, [rax + HDR_SIZE_OFFSET]

; Continue if the block is unavailable
    cmp qword [rax + HDR_AVAIL_OFFSET], UNAVAILABLE
    je allocate_next_block

; Block is available. See if it's big enough for the request.
    cmp rcx, rdx
    jle allocate_here


allocate_next_block:

; Move the pointer past this block and to the next one.
    add rax, HEADER_SIZE
    add rax, rdx
    jmp allocate_loop


allocate_here:

; Mark the block as unavailable
    mov qword [rax + HDR_AVAIL_OFFSET], UNAVAILABLE

; Return the actual data, not the header
    add rax, HEADER_SIZE

    jmp allocate_ret


allocate_more:

; Move past the last block
    add rbx, HEADER_SIZE
    add rbx, rcx

    push rax
    push rcx
    push rbx

; Request more memory from OS
    mov rax, SYS_BRK
    int LINUX

; If 0, OS is out of memory or just hates us, something like that!
    cmp rax, 0
    je allocate_err

    pop rbx
    pop rcx
    pop rax

; Mark block as unavailable
    mov qword [rax + HDR_AVAIL_OFFSET], UNAVAILABLE

; Set memory size
    mov [rax + HDR_SIZE_OFFSET], rcx

; Move to start of actual memory
    add rax, HEADER_SIZE

; Save new break point
    mov [current_break], rbx

    jmp allocate_ret


allocate_err:
    mov rax, 0


allocate_ret:
    mov rsp, rbp
    pop rbp
    ret


;   Function reallocate
;       Reallocate a segment of memory with a new size.
;
;   Stack arguments:
;       SEGMENT_ADDR - The memory address to reallocate. Must have been
;                      previously allocated by the allocate function.
;       NEW_SIZE     - The new size in bytes to resize the segment to.
;
;   Return values:
;       rax          - 0 if failed, otherwise the new address of the segment.

global reallocate:function
    %define SEGMENT_ADDR 24
    %define NEW_SIZE 16
reallocate:
    push rbp
    mov rbp, rsp

; Don't bother reallocating if the size won't change
    mov rax, [rsp + NEW_SIZE]
    mov rbx, [rsp + SEGMENT_ADDR]
    sub rbx, HEADER_SIZE
    cmp [rbx + HDR_SIZE_OFFSET], rax
    jne reallocate_size_change

; Size wouldn't change, return original address
    mov rax, [rsp + SEGMENT_ADDR]
    jmp reallocate_ret

reallocate_size_change:

; Allocate a new segment of the requested size
    push qword [rsp + NEW_SIZE]
    call allocate
    add rsp, 8
    cmp rax, 0
    je reallocate_ret

; Figure out if the segment grew or shrunk
    mov rbx, [rsp + SEGMENT_ADDR]
    sub rbx, HEADER_SIZE
    mov rcx, [rbx + HDR_SIZE_OFFSET]
    mov rdx, [rsp + NEW_SIZE]
    cmp rdx, rcx
    jg reallocate_size_increased

; Segment shrunk, only copy NEW_SIZE bytes
    mov rcx, rdx

; Segment grew, copy the original number of bytes
reallocate_size_increased:

; Copy bytes from old segment to new
    add rbx, HEADER_SIZE

reallocate_copy_loop:
    dec rcx
    cmp rcx, 0
    jl reallocate_copy_loop_done

    mov byte dl, [rbx + rcx]
    mov byte [rbx + rcx], dl

    jmp reallocate_copy_loop

reallocate_copy_loop_done:

; Mark the original segment available
    sub rbx, HEADER_SIZE
    mov qword [rbx + HDR_AVAIL_OFFSET], AVAILABLE

reallocate_ret:
    mov rsp, rbp
    pop rbp
    ret


;   Function deallocate
;       Free a segment of memory previously allocated by the allocate function
;
;   Stack arguments:
;       MEMORY_ADDR - The address of the segment to free.

global deallocate:function
    %define ST_MEMORY_ADDR 8
deallocate:

; Grab input parameter (address of block to free)
    mov rax, [rsp + ST_MEMORY_ADDR]

; Rewind the pointer to the block's header
    sub rax, HEADER_SIZE

; Mark segment available
    mov qword [rax + HDR_AVAIL_OFFSET], AVAILABLE

    ret
