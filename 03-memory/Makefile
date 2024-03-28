all:
	mkdir -p build
	as -al -o build/memory.o memory.s
	gcc -o build/memory build/memory.o

test:
	build/memory; echo $$?

