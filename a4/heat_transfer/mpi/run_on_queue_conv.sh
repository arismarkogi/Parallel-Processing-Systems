#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_mpi_helloworld

## Output and error files
#PBS -o /home/parallel/parlab20/a4/heat_transfer/mpi/run_conv/run_mpi_with_conv.out
#PBS -e /home/parallel/parlab20/a4/heat_transfer/mpi/run_conv/run_mpi_with_conv.err

## How many machines should we get? 
#PBS -l nodes=8:ppn=8

## Start 

module load openmpi/1.8.3
cd /home/parallel/parlab20/a4/heat_transfer/mpi

for execfile in jacobi_conv seidelsor_conv redblacksor_conv
do
    mpirun -np 64 --mca btl self,tcp ${execfile} 512 512 8 8 >> "/home/parallel/parlab20/a4/heat_transfer/mpi/run_conv/${execfile}.out" 2>> "/home/parallel/parlab20/a4/heat_transfer/mpi/run_conv/${execfile}.err"
done

