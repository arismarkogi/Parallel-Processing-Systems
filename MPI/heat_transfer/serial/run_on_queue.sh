#!/bin/bash

## Give the Job a descriptive name
#PBS -N runjob

## Output and error files
#PBS -o /home/parallel/parlab20/a4/heat_transfer/serial/run/serial_with_conv.out
#PBS -e /home/parallel/parlab20/a4/heat_transfer/serial/run/serial_with_conv.err

## How many machines should we get?
#PBS -l nodes=1:ppn=1

#PBS -l walltime=00:15:00

## Start 
## Run make in the src folder (modify properly)
cd /home/parallel/parlab20/a4/heat_transfer/serial
./jacobi  >> "/home/parallel/parlab20/a4/heat_transfer/serial/run/jacobi_serial_with_conv.out" 2>> 
"/home/parallel/parlab20/a4/heat_transfer/serial/run/jacobi_serial_with_conv.err"
./seidelsor 512 >> "/home/parallel/parlab20/a4/heat_transfer/serial/run/seidelsor_serial_with_conv.out" 2>> "/home/parallel/parlab20/a4/heat_transfer/serial/run/seidelsor_serial_with_conv.err"
./redblacksor 512 >> "/home/parallel/parlab20/a4/heat_transfer/serial/run/redblacksor_serial_with_conv.out" 2>> "/home/parallel/parlab20/a4/heat_transfer/serial/run/redblacksor_serial_with_conv.err"
