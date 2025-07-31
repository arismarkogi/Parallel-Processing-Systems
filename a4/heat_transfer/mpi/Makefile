CC=mpicc                                                                                                                                                                                                 
CFLAGS=-O3 -lm -Wall
RES=-DPRINT_RESULTS
CONV=-DTEST_CONV

all: jacobi_conv seidelsor_conv redblacksor_conv
 
jacobi_conv: mpi_jacobi.c utils.c
	$(CC) $(CFLAGS) $(CONV)  mpi_jacobi.c utils.c -o jacobi_conv
 
seidelsor_conv: mpi_gauss_seidel_sor.c utils.c
	$(CC) $(CFLAGS) $(CONV)  mpi_gauss_seidel_sor.c utils.c -o seidelsor_conv
 
redblacksor_conv: mpi_red_black_sor.c utils.c
	$(CC) $(CFLAGS) $(CONV)  mpi_red_black_sor.c utils.c -o redblacksor_conv

clean:
	rm jacobi_conv seidelsor_conv redblacksor_conv
