CC=gcc
CFLAGS=-O3 -lm -Wall
RES=-DPRINT_RESULTS
CONV=-DTEST_CONV

all: jacobi_noconv seidelsor_noconv redblacksor_noconv

jacobi_noconv: Jacobi_serial.c utils.c
	$(CC) $(CFLAGS) $(RES)  Jacobi_serial.c utils.c -o jacobi_noconv

seidelsor_noconv: GaussSeidelSOR_serial.c utils.c
	$(CC) $(CFLAGS) $(RES)  GaussSeidelSOR_serial.c utils.c -o seidelsor_noconv

redblacksor_noconv: RedBlackSOR_serial.c utils.c 
	$(CC) $(CFLAGS) $(RES)  RedBlackSOR_serial.c utils.c -o redblacksor_noconv

clean:
	rm jacobi_noconv seidelsor_noconv redblacksor_noconv

