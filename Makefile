all: exit numbers memory mov-reg add

exit: build build/exit
numbers: build build/numbers.lst
memory: build build/memory
mov-reg: build build/mov-reg
add: build build/add

build:
	mkdir build

build/exit: src/01_04-exit.s
	as -o build/exit.o src/01_04-exit.s
	ld -o build/exit build/exit.o
build/numbers.lst: src/02_04-numbers.s
	as -al -o build/numbers.o src/02_04-numbers.s\
		> build/numbers.lst
build/memory: src/03_03-memory.s
	as -al -o build/memory.o src/03_03-memory.s\
		> build/memory.lst
	gcc -o build/memory build/memory.o
build/mov-reg: src/05_02-mov-reg.s
	as -o build/mov-reg.o src/05_02-mov-reg.s
	gcc -no-pie -o build/mov-reg build/mov-reg.o
build/add: src/06_02-add.s
	as -o build/add.o src/06_02-add.s
	gcc -no-pie -o build/add build/add.o

.PHONY: clean
clean:
	-rm -rf build

test-exit:
	build/exit; echo $$?
test-numbers:
	cat build/numbers.lst
test-memory:
	cat build/memory.lst
	build/memory; echo $$?
test-mov-reg:
	build/mov-reg; echo $$?
test-add:
	build/add; echo $$?

