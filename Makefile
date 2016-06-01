all: build

build:
	mkdir -p obj bin
	nasm -f elf64 -isrc/ src/int_to_str.asm -o obj/int_to_str.o
#	nasm -f elf64 -isrc/ src/mem.asm -o obj/mem.o
	nasm -f elf64 -isrc/ src/prompt.asm -o obj/prompt.o
#	nasm -f elf64 -isrc/ src/strcmp.asm -o obj/strcmp.o
	nasm -f elf64 -isrc/ src/strcpy.asm -o obj/strcpy.o
#	nasm -f elf64 -isrc/ src/strdebug.asm -o obj/strdebug.o
	nasm -f elf64 -isrc/ src/strlen.asm -o obj/strlen.o
#	nasm -f elf64 -isrc/ src/strrev.asm -o obj/strrev.o
	nasm -f elf64 -isrc/ src/strstr.asm -o obj/strstr.o
	nasm -f elf64 -isrc/ src/str_to_int.asm -o obj/str_to_int.o
	ld -shared -o bin/libbasm.so obj/int_to_str.o obj/prompt.o obj/strcpy.o \
		obj/strlen.o obj/strstr.o obj/str_to_int.o

tests: build
	nasm -f elf64 -isrc/ tests/test_int_to_str.asm -o obj/test_int_to_str.o
	ld -o bin/test_int_to_str obj/test_int_to_str.o obj/int_to_str.o
#	nasm -f elf64 -isrc/ tests/test_mem.asm -o obj/test_mem.o
#	ld -o bin/test_mem obj/test_mem.o obj/mem.o
#	nasm -f elf64 -isrc/ tests/test_prompt.asm -o obj/test_prompt.o
#	ld -o bin/test_prompt obj/test_prompt.o obj/prompt.o
#	nasm -f elf64 -isrc/ tests/test_strcmp.asm -o obj/test_strcmp.o
#	ld -o bin/test_strcmp obj/test_strcmp.o obj/strcmp.o
	nasm -f elf64 -isrc/ tests/test_strcpy.asm -o obj/test_strcpy.o
	ld -o bin/test_strcpy obj/test_strcpy.o obj/strcpy.o
#	nasm -f elf64 -isrc/ tests/test_strdebug.asm -o obj/test_strdebug.o
#	ld -o bin/test_strdebug obj/test_strdebug.o obj/strdebug.o
	nasm -f elf64 -isrc/ tests/test_strlen.asm -o obj/test_strlen.o
	ld -o bin/test_strlen obj/test_strlen.o obj/strlen.o
#	nasm -f elf64 -isrc/ tests/test_strrev.asm -o obj/test_strrev.o
#	ld -o bin/test_strrev obj/test_strrev.o obj/strrev.o
	nasm -f elf64 -isrc/ tests/test_strstr.asm -o obj/test_strstr.o
	ld -o bin/test_strstr obj/test_strstr.o obj/strstr.o
#	nasm -f elf64 -isrc/ tests/test_str_to_int.asm -o obj/test_str_to_int.o
#	ld -o bin/test_str_to_int obj/test_str_to_int.o obj/str_to_int.o

clean:
	rm -rf obj bin
