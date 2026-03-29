#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_mpi_kmeans

## Output and error files
#PBS -o /home/parallel/parlab20/a4/kmeans/run_mpi_kmeans.out
#PBS -e /home/parallel/parlab20/a4/kmeans/run_mpi_kmeans.err

## How many machines should we get? 
#PBS -l nodes=2:ppn=8

## Load required modules
module load openmpi/1.8.3

## Change directory to the k-means source folder
cd /home/parallel/parlab20/a4/kmeans

## Run kmeans_mpi for different numbers of processes
for np in 1 2 4 8 16 32 64 ; do
    echo "Running with $np processes"
    mpirun --mca btl tcp,self -np $np ./kmeans_mpi -c 16 -s 256 -n 32 -l 10
done

