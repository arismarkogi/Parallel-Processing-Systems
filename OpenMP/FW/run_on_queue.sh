#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_fw

## Error file
#PBS -e err/run_fw.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=8

## How long should the job run for?
#PBS -l walltime=03:00:00

## Start 
module load openmp
cd /home/parallel/parlab20/a2/FW

# Define the parameters
sizes=(4096)
bsizes=(64 128 256)
threads_list=()

# Run the command for each combination of threads, size, and bsize
for size in "${sizes[@]}"
do
  for bsize in "${bsizes[@]}"
  do
    for threads in "${threads_list[@]}"
    do
      export OMP_NUM_THREADS=${threads}
      output_file="out/sr/run_fw_tiled_${size}_${bsize}_${threads}.out"
      ./fw_tiled_aris "$size" "$bsize" > "$output_file"
    done
  done
done

