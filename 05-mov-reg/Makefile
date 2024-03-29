all:
	mkdir -p build
	as -o build/mov-reg.o mov-reg.s
	gcc -no-pie -o build/mov-reg build/mov-reg.o

test:
	build/mov-reg; echo $$?

