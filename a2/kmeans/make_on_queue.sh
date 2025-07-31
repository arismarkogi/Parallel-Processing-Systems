#!/bin/bash

## Give the Job a descriptive name
#PBS -N make_locks_kmeans

## Output and error files
#PBS -o /home/parallel/parlab20/a2/kmeans/make/out/make_locks_kmeans.out
#PBS -e /home/parallel/parlab20/a2/kmeans/make/err/make_locks_kmeans.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=1

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab20/a2/kmeans
make clean
make all
