all:
	mkdir -p build
	as -o build/add.o add.s
	gcc -no-pie -o build/add build/add.o

test:
	build/add; echo $$?

