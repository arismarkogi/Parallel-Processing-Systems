#!/bin/bash

## Give the Job a descriptive name
#PBS -N runjob_noconv

## Output and error files
#PBS -o /home/parallel/parlab20/a4/heat_transfer/serial/run/serial_noconv.out
#PBS -e /home/parallel/parlab20/a4/heat_transfer/serial/run/serial_noconv.err

## How many machines should we get?
#PBS -l nodes=1:ppn=1

#PBS -l walltime=00:30:00

## Start 
cd /home/parallel/parlab20/a4/heat_transfer/serial

sizes=(2048 4096 6144)

for size in "${sizes[@]}"; do
    ./jacobi_noconv $size >> "/home/parallel/parlab20/a4/heat_transfer/serial/run/jacobi_noconv_${size}.out" 2>> "/home/parallel/parlab20/a4/heat_transfer/serial/run/jacobi_noconv_${size}.err"
    # ./seidelsor_noconv $size >> "/home/parallel/parlab20/a4/heat_transfer/serial/run/seidelsor_noconv_${size}.out" 2>> "/home/parallel/parlab20/a4/heat_transfer/serial/run/seidelsor_noconv_${size}.err"
   # ./redblacksor_noconv $size >> "/home/parallel/parlab20/a4/heat_transfer/serial/run/redblacksor_noconv_${size}.out" 2>> "/home/parallel/parlab20/a4/heat_transfer/serial/run/redblacksor_noconv_${size}.err"
done

