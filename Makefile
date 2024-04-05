all: exit numbers memory mov-reg add\
	sub mult div cond-mov bit-ops\
	uncnd-jmp loop loop2 func recurse\
	array cl-param float syscall-32\
	syscall c-wrap struct stream\
	llist dllist

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
loop2: build build/loop2
func: build build/func
recurse: build build/recurse
array: build build/array
cl-param: build build/cl-param
float: build build/float.lst
syscall-32: build build/syscall-32
syscall: build build/syscall
c-wrap: build build/c-wrap
struct: build build/struct
stream: build build/stream.lst
llist: build build/llist
dllist: build build/dllist.lst

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
build/loop2: src/08_03-loop2.s
	as -o build/loop2.o src/08_03-loop2.s
	gcc -no-pie -o build/loop2 build/loop2.o
build/func: src/09_04-func.s
	as -o build/func.o src/09_04-func.s
	gcc -no-pie -o build/func build/func.o
build/recurse: src/09_05-recurse.s
	as -o build/recurse.o src/09_05-recurse.s
	gcc -no-pie -o build/recurse build/recurse.o
build/array: src/10_04-array.s
	as -o build/array.o src/10_04-array.s
	gcc -no-pie -o build/array build/array.o
build/cl-param: src/10_05-cl-param.s
	as -o build/cl-param.o src/10_05-cl-param.s
	gcc -no-pie -o build/cl-param build/cl-param.o
build/float.lst: src/11_09-float.s
	as -al -o build/float.o src/11_09-float.s\
		> build/float.lst
build/syscall-32: src/12_01-syscall-32.s
	as -o build/syscall-32.o src/12_01-syscall-32.s
	gcc -no-pie -o build/syscall-32 build/syscall-32.o
build/syscall: src/12_02-syscall.s
	as -o build/syscall.o src/12_02-syscall.s
	ld -o build/syscall build/syscall.o
build/c-wrap: src/12_03-c-wrap.s
	as -o build/c-wrap.o src/12_03-c-wrap.s
	gcc -no-pie -o build/c-wrap build/c-wrap.o
build/struct: src/13_01-struct.s
	as -o build/struct.o src/13_01-struct.s
	gcc -no-pie -o build/struct build/struct.o
build/stream.lst: src/14-stream.s
	as -al -o build/stream.o src/14-stream.s\
		> build/stream.lst
build/llist: src/15_01-llist.s
	as -o build/llist.o src/15_01-llist.s
	gcc -no-pie -o build/llist build/llist.o
build/dllist.lst: src/15_02-dllist.s
	as -al -o build/dllist.o src/15_02-dllist.s\
		> build/dllist.lst

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
test-loop2:
	build/loop2; echo $$?
test-func:
	build/func; echo $$?
test-recurse:
	build/recurse; echo $$?
test-array:
	build/array
	build/array 21
test-cl-param:
	build/cl-param a b c123
test-float:
	cat build/float.lst
test-syscall-32:
	build/syscall-32
test-syscall:
	build/syscall
test-c-wrap:
	build/c-wrap
test-struct:
	build/struct; echo $$?
test-stream:
	cat build/stream.lst
test-llist:
	build/llist
test-dllist:
	cat build/dllist.lst

