# https://unix.stackexchange.com/questions/463805/prevent-qemu-spice-from-grabbing-keys-that-are-bound-elsewhere

all: xigd.c
	cc -shared -ldl -Wall -W xigd.c -o xigd.so
