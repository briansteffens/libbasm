section .data
    LINUX equ 0x80

    SYS_EXIT equ 1

    SYS_FILE_READ   equ 3
    SYS_FILE_WRITE  equ 4
    SYS_FILE_OPEN   equ 5
    SYS_FILE_CLOSE  equ 6
    SYS_FILE_SEEK   equ 19
    SYS_BRK         equ 45

    SYS_FILE_PERM_READ      equ 0
    SYS_FILE_PERM_WRITE     equ 03101
    SYS_FILE_PERM_READWRITE equ 2

    SYS_FILE_SEEK_SET equ 0
    SYS_FILE_SEEK_CUR equ 1
    SYS_FILE_SEEK_END equ 2

    STDIN  equ 0
    STDOUT equ 1
    STDERR equ 2
