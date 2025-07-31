#!/bin/bash

## Give the Job a descriptive name
#PBS -N make_mpi_heat_transfer

## Output and error files
#PBS -o /home/parallel/parlab20/a4/heat_transfer/mpi/make/make.out
#PBS -e /home/parallel/parlab20/a4/heat_transfer/mpi/make/make.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=1

##How long should the job run for?
#PBS -l walltime=00:05:00

## Start 
## Run make in the src folder (modify properly)

module load openmpi/1.8.3
cd /home/parallel/parlab20/a4/heat_transfer/mpi
make

