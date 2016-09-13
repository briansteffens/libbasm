all: build

build:
	mkdir -p obj bin
	nasm -f elf64 -isrc/ src/byte_to_hex.asm -o obj/byte_to_hex.o
	nasm -f elf64 -isrc/ src/hex_to_byte.asm -o obj/hex_to_byte.o
	nasm -f elf64 -isrc/ src/hex_to_int.asm -o obj/hex_to_int.o
	nasm -f elf64 -isrc/ src/int_to_str.asm -o obj/int_to_str.o
	nasm -f elf64 -isrc/ src/int_to_hex.asm -o obj/int_to_hex.o
	nasm -f elf64 -isrc/ src/mem.asm -o obj/mem.o
	nasm -f elf64 -isrc/ src/str_cmp.asm -o obj/str_cmp.o
	nasm -f elf64 -isrc/ src/str_cpy.asm -o obj/str_cpy.o
	nasm -f elf64 -isrc/ src/str_len.asm -o obj/str_len.o
	nasm -f elf64 -isrc/ src/str_n_len.asm -o obj/str_n_len.o
	nasm -f elf64 -isrc/ src/str_rev.asm -o obj/str_rev.o
	nasm -f elf64 -isrc/ src/str_str.asm -o obj/str_str.o
	nasm -f elf64 -isrc/ src/str_to_int.asm -o obj/str_to_int.o
	ld -shared -o bin/libbasm.so obj/int_to_str.o obj/str_len.o \
		obj/str_cpy.o obj/str_str.o obj/str_to_int.o

tests: build
	nasm -f elf64 -isrc/ tests/test_mem.asm -o obj/test_mem.o
	ld -o bin/test_mem obj/test_mem.o obj/mem.o
	nasm -f elf64 -isrc/ tests/test_str_rev.asm -o obj/test_str_rev.o
	ld -o bin/test_str_rev obj/test_str_rev.o obj/str_rev.o
	nasm -f elf64 -isrc/ tests/test_str_to_int.asm -o obj/test_str_to_int.o
	ld -o bin/test_str_to_int obj/test_str_to_int.o obj/str_to_int.o

clean:
	rm -rf obj bin
