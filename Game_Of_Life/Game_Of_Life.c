/****************************************************** 
 ************* Conway's game of life ******************
 ******************************************************

 Usage: ./exec ArraySize TimeSteps                   

 Compile with -DOUTPUT to print output in output.gif 
 (You will need ImageMagick for that - Install with
 sudo apt-get install imagemagick)
 WARNING: Do not print output for large array sizes!
 or multiple time steps!
 ******************************************************/


#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>

#define FINALIZE "\
convert -delay 20 `ls -1 out*.pgm | sort -V` output.gif\n\
rm *pgm\n\
"

int ** allocate_array(int N);
void free_array(int ** array, int N);
void init_random(int ** array1, int ** array2, int N);
void print_to_pgm( int ** array, int N, int t );

void init_blinker(int ** array1, int ** array2, int N) {
    if (N < 5) {  // Blinker needs at least 5x5 grid to fit.
        fprintf(stderr, "Grid size too small for Blinker. Use N >= 5.\n");
        exit(-1);
    }

    int mid = N / 2;  // Center of the grid

    // Set the Blinker pattern in the middle
    array1[mid][mid - 1] = 1;
    array1[mid][mid] = 1;
    array1[mid][mid + 1] = 1;

    // Initialize the previous array the same way
    array2[mid][mid - 1] = 1;
    array2[mid][mid] = 1;
    array2[mid][mid + 1] = 1;
}

void init_pentadecathlon(int ** array1, int ** array2, int N) {
    if (N < 16) {  // Pentadecathlon needs at least 10x16 grid.
        fprintf(stderr, "Grid size too small for Pentadecathlon. Use N >= 16.\n");
        exit(-1);
    }

    int mid = N / 2;  // Center of the grid
    int i;
    // Place the Pentadecathlon pattern in the middle of the grid.
    for (i = -4; i <= 5; i++) {
        if (i == -4 || i == -3 || i == 4 || i == 5) {
            // The two ends of the Pentadecathlon have a vertical arrangement of 3 cells
            array1[mid + i][mid - 1] = 1;
            array1[mid + i][mid] = 1;
            array1[mid + i][mid + 1] = 1;

            array2[mid + i][mid - 1] = 1;
            array2[mid + i][mid] = 1;
            array2[mid + i][mid + 1] = 1;
        } else {
            // The middle of the Pentadecathlon has a single horizontal row
            array1[mid + i][mid] = 1;
            array2[mid + i][mid] = 1;
        }
    }
}

void init_worker_bee(int ** array1, int ** array2, int N) {
    if (N < 16) {  // Worker Bee needs at least 16x11 grid.
        fprintf(stderr, "Grid size too small for Worker Bee. Use N >= 16.\n");
        exit(-1);
    }

    // Worker Bee pattern coordinates
    int worker_bee_pattern[34][2] = {
        {0, 1}, {0, 2}, {0, 3}, {0, 4}, {0, 5}, {0, 6}, 
        {1, 0}, {1, 6}, {1, 8}, {1, 9}, 
        {2, 0}, {2, 2}, {2, 6}, {2, 8}, {2, 10}, 
        {3, 1}, {3, 6}, 
        {4, 2}, {4, 6}, 
        {5, 0}, {5, 6}, {5, 8}, 
        {6, 0}, {6, 2}, {6, 4}, {6, 6}, {6, 8}, {6, 10}, 
        {7, 6}, 
        {8, 6}, 
        {9, 2}, {9, 6}, 
        {10, 1}, {10, 6}
    };

    // Center the pattern in the grid
    int offset_x = (N - 16) / 2;
    int offset_y = (N - 11) / 2;
    int i;
    // Place the Worker Bee pattern in the middle of the grid
    for (i = 0; i < 34; i++) {
        int x = worker_bee_pattern[i][0] + offset_y;  // Adjust for center
        int y = worker_bee_pattern[i][1] + offset_x;  // Adjust for center
        array1[x][y] = 1;
        array2[x][y] = 1;
    }
}




void init_pulsar(int ** array1, int ** array2, int N) {
    if (N < 17) {  // Pulsar needs at least 17x17 grid to fit.
        fprintf(stderr, "Grid size too small for Pulsar. Use N >= 17.\n");
        exit(-1);
    }

    int mid = N / 2;  // Center of the grid

    // Coordinates relative to the center for one quadrant of the pulsar.
    int pulsar_pattern[12][2] = {
        {0, 2}, {0, 3}, {0, 4},
        {5, 2}, {5, 3}, {5, 4},
        {2, 0}, {3, 0}, {4, 0},
        {2, 5}, {3, 5}, {4, 5}
    };
    int i;
    // Set the pulsar pattern in all four quadrants symmetrically.
    for ( i = 0; i < 12; i++) {
        int x = pulsar_pattern[i][0];
        int y = pulsar_pattern[i][1];

        // Upper-left quadrant
        array1[mid - x][mid - y] = 1;
        array2[mid - x][mid - y] = 1;

        // Upper-right quadrant
        array1[mid - x][mid + y] = 1;
        array2[mid - x][mid + y] = 1;

        // Lower-left quadrant
        array1[mid + x][mid - y] = 1;
        array2[mid + x][mid - y] = 1;

        // Lower-right quadrant
        array1[mid + x][mid + y] = 1;
        array2[mid + x][mid + y] = 1;
    }
}

void init_glider(int ** array1, int ** array2, int N) {
    if (N < 5) {  // Glider needs at least 5x5 grid.
        fprintf(stderr, "Grid size too small for Glider. Use N >= 5.\n");
        exit(-1);
    }

    // Glider pattern relative to top-left corner
    int glider_pattern[5][2] = {
        {1, 0}, {2, 1}, {0, 2}, {1, 2}, {2, 2}
    };

    // Place the glider in the upper-left corner
    int i;
    for (i = 0; i < 5; i++) {
        int x = glider_pattern[i][0];
        int y = glider_pattern[i][1];
        array1[x][y] = 1;
        array2[x][y] = 1;
    }
}

void init_lwss(int ** array1, int ** array2, int N) {
    if (N < 6) {  // LWSS needs at least 6x6 grid.
        fprintf(stderr, "Grid size too small for LWSS. Use N >= 6.\n");
        exit(-1);
    }

    // LWSS pattern relative to top-left corner
    int lwss_pattern[9][2] = {
        {1, 0}, {1, 3}, {2, 4}, {3, 0}, {3, 4},
        {4, 1}, {4, 2}, {4, 3}, {4, 4}
    };

    // Place the LWSS in the upper-left corner
    int i;
    for (i = 0; i < 9; i++) {
        int x = lwss_pattern[i][0];
        int y = lwss_pattern[i][1];
        array1[x][y] = 1;
        array2[x][y] = 1;
    }
}





int main (int argc, char * argv[]) {
	int N;	 			//array dimensions
	int T; 				//time steps
	int ** current, ** previous; 	//arrays - one for current timestep, one for previous timestep
	int ** swap;			//array pointer
	int t, i, j, nbrs;		//helper variables

	double time;			//variables for timing
	struct timeval ts,tf;

	/*Read input arguments*/
	if ( argc != 3 ) {
		fprintf(stderr, "Usage: ./exec ArraySize TimeSteps\n");
		exit(-1);
	}
	else {
		N = atoi(argv[1]);
		T = atoi(argv[2]);
	}

	/*Allocate and initialize matrices*/
	current = allocate_array(N);			//allocate array for current time step
	previous = allocate_array(N); 			//allocate array for previous time step

	init_random(previous, current, N);	//initialize previous array with pattern

	#ifdef OUTPUT
	print_to_pgm(previous, N, 0);
	#endif

	/*Game of Life*/

	gettimeofday(&ts,NULL);
	for ( t = 0 ; t < T ; t++ ) {
        #pragma omp parallel for collapse(2) private(nbrs)
		for ( i = 1 ; i < N-1 ; i++ )
			for ( j = 1 ; j < N-1 ; j++ ) {
				nbrs = previous[i+1][j+1] + previous[i+1][j] + previous[i+1][j-1] \
				       + previous[i][j-1] + previous[i][j+1] \
				       + previous[i-1][j-1] + previous[i-1][j] + previous[i-1][j+1];
				if ( nbrs == 3 || ( previous[i][j]+nbrs ==3 ) )
					current[i][j]=1;
				else 
					current[i][j]=0;
			}

		#ifdef OUTPUT
		print_to_pgm(current, N, t+1);
		#endif
		//Swap current array with previous array 
		swap=current;
		current=previous;
		previous=swap;

	}
	gettimeofday(&tf,NULL);
	time=(tf.tv_sec-ts.tv_sec)+(tf.tv_usec-ts.tv_usec)*0.000001;

	free_array(current, N);
	free_array(previous, N);
	printf("GameOfLife: Size %d Steps %d Time %lf\n", N, T, time);
	#ifdef OUTPUT
	system(FINALIZE);
	#endif
}

int ** allocate_array(int N) {
	int ** array;
	int i,j;
	array = malloc(N * sizeof(int*));
	for ( i = 0; i < N ; i++ ) 
		array[i] = malloc( N * sizeof(int));
	for ( i = 0; i < N ; i++ )
		for ( j = 0; j < N ; j++ )
			array[i][j] = 0;
	return array;
}

void free_array(int ** array, int N) {
	int i;
	for ( i = 0 ; i < N ; i++ )
		free(array[i]);
	free(array);
}

void init_random(int ** array1, int ** array2, int N) {
	int i,pos,x,y;

	for ( i = 0 ; i < (N * N)/10 ; i++ ) {
		pos = rand() % ((N-2)*(N-2));
		array1[pos%(N-2)+1][pos/(N-2)+1] = 1;
		array2[pos%(N-2)+1][pos/(N-2)+1] = 1;

	}
}

void print_to_pgm(int ** array, int N, int t) {
	int i,j;
	char * s = malloc(30*sizeof(char));
	sprintf(s,"out%d.pgm",t);
	FILE * f = fopen(s,"wb");
	fprintf(f, "P5\n%d %d 1\n", N,N);
	for ( i = 0; i < N ; i++ ) 
		for ( j = 0; j < N ; j++)
			if ( array[i][j]==1 )
				fputc(1,f);
			else
				fputc(0,f);
	fclose(f);
	free(s);
}

