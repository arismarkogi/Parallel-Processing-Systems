#!/bin/bash

## Give the Job a descriptive name
#PBS -N makejob

## Output and error files
#PBS -o /home/parallel/parlab20/a4/heat_transfer/serial/make/serial_with_conv.out
#PBS -e /home/parallel/parlab20/a4/heat_transfer/serial/make/serial_with_conv.err

## How many machines should we get?
#PBS -l nodes=1:ppn=1

#PBS -l walltime=00:05:00

## Start 
## Run make in the src folder (modify properly)
cd /home/parallel/parlab20/a4/heat_transfer/serial
make
