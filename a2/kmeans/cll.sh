#!/bin/bash

## Descriptive job name
#PBS -N cll

## Output and error files
#PBS -o /home/parallel/parlab20/a2/kmeans/cll/out/cll.out
#PBS -e /home/parallel/parlab20/a2/kmeans/cll/err/cll.err

#PBS -l nodes=1:ppn=8

#PBS -l walltime=00:05:00

## Change to the appropriate directory
cd /home/parallel/parlab20/a2/kmeans

getconf -a | grep CACHE
