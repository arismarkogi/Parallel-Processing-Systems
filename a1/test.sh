!/bin/bash

## Give the Job a descriptive name
#PBS -N test

## Output and error files
#PBS -o test.out
#PBS -e test.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=8

##How long should the job run for?
#PBS -l walltime=00:10:00
lscpu

echo "\n\nTest is completed successfully\n\n"
