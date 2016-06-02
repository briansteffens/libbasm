%define LINUX 0x80

%define SYS_EXIT 1

%define SYS_FILE_READ   3
%define SYS_FILE_WRITE  4
%define SYS_FILE_OPEN   5
%define SYS_FILE_CLOSE  6
%define SYS_FILE_SEEK   19
%define SYS_BRK         45

%define SYS_FILE_PERM_READ      0
%define SYS_FILE_PERM_WRITE     03101
%define SYS_FILE_PERM_READWRITE 2

%define SYS_FILE_SEEK_SET 0
%define SYS_FILE_SEEK_CUR 1
%define SYS_FILE_SEEK_END 2

%define STDIN  0
%define STDOUT 1
%define STDERR 2
