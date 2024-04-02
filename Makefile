all: exit numbers memory mov-reg add\
	sub mult div cond-mov bit-ops\
	uncnd-jmp loop

exit: build build/exit
numbers: build build/numbers.lst
memory: build build/memory
mov-reg: build build/mov-reg
add: build build/add
sub: build build/sub
mult: build build/mult
div: build build/div
cond-mov: build build/cond-mov
bit-ops: build build/bit-ops
uncnd-jmp: build build/uncnd-jmp
loop: build build/loop

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
build/sub: src/06_03-sub.s
	as -o build/sub.o src/06_03-sub.s
	gcc -no-pie -o build/sub build/sub.o
build/mult: src/06_04-mult.s
	as -o build/mult.o src/06_04-mult.s
	gcc -no-pie -o build/mult build/mult.o
build/div: src/06_05-div.s
	as -o build/div.o src/06_05-div.s
	gcc -no-pie -o build/div build/div.o
build/cond-mov: src/06_06-cond-mov.s
	as -o build/cond-mov.o src/06_06-cond-mov.s
	gcc -no-pie -o build/cond-mov build/cond-mov.o
build/bit-ops: src/07-bit-ops.s
	as -o build/bit-ops.o src/07-bit-ops.s
	gcc -no-pie -o build/bit-ops build/bit-ops.o
build/uncnd-jmp: src/08_01-uncnd-jmp.s
	as -o build/uncnd-jmp.o src/08_01-uncnd-jmp.s
	gcc -no-pie -o build/uncnd-jmp build/uncnd-jmp.o
build/loop: src/08_03-loop.s
	as -o build/loop.o src/08_03-loop.s
	gcc -no-pie -o build/loop build/loop.o

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
test-sub:
	build/sub; echo $$?
test-mult:
	build/mult; echo $$?
test-div:
	build/div; echo $$?
test-cond-mov:
	build/cond-mov; echo $$?
test-bit-ops:
	build/bit-ops; echo $$?
test-uncnd-jmp:
	build/uncnd-jmp; echo $$?
test-loop:
	build/loop; echo $$?

