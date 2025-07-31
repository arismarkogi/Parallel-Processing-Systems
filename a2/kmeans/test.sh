#!/bin/bash 

## Give the Job a descriptive name
#PBS -N test

## Output and error files
#PBS -o /home/parallel/parlab20/a2/kmeans/test/out/CACHE_info.out
#PBS -e /home/parallel/parlab20/a2/kmeans/test/err/CACHE_info.err

## How many machines should we get?
#PBS -l nodes=sandman:ppn=64

##How long should the job run for?
#PBS -l walltime=00:03:00
cd /home/parallel/parlab20/a2/kmeans
getconf -a | grep CACHE
