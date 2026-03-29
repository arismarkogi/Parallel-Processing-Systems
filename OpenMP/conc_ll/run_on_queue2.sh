#!/bin/bash

# Descriptive job name
#PBS -N cll

# Output and error files
#PBS -o /home/parallel/parlab20/a2/conc_ll/run/out/cll.out
#PBS -e /home/parallel/parlab20/a2/conc_ll/run/err/cll.err

#PBS -l nodes=1:ppn=1

#PBS -l walltime=05:00:00

# Change to the appropriate directory
cd /home/parallel/parlab20/a2/conc_ll

echo "lalallalalalal"

./x.cgl 1024 100 0 0 >> "/home/parallel/parlab20/a2/conc_ll/run/out/cll.out"


