.phony: all clean

all: fw fw_sr_aris fw_tiled_aris

CC=gcc
CFLAGS= -Wall -O3 -Wno-unused-variable -fopenmp

HDEPS+=%.h

OBJS=util.o

fw: $(OBJS) fw.c 
	$(CC) $(OBJS) fw.c -o fw $(CFLAGS)
fw_sr_aris: fw_sr_aris.c 
	$(CC) $(OBJS) fw_sr_aris.c -o fw_sr_aris $(CFLAGS)
fw_tiled_aris: fw_tiled_aris.c 
	$(CC) $(OBJS) fw_tiled_aris.c -o fw_tiled_aris $(CFLAGS)

%.o: %.c $(HDEPS)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o fw fw_sr fw_tiled 

