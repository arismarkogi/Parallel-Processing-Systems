!/bin/bash

## Give the Job a descriptive name
#PBS -N run_Game_Of_Life

## Output and error files
#PBS -o run_Game_Of_Life.out
#PBS -e run_Game_Of_Life.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=8

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab20/a1
mkdir -p out err

# Arrays of core counts and array sizes to test
core_counts=(1 2 4 6 8)
array_sizes=(64)

# Loop through each array size
for size in "${array_sizes[@]}"
do
   
    # Loop through each core count
    for cores in "${core_counts[@]}"
    do
        # Set the number of OpenMP threads
        export OMP_NUM_THREADS=$cores

        # Run the Game of Life simulation
        ./Game_Of_Life $size 1000 >> "out/run_Game_Of_Life_${cores}cores_${size}ArrSize.out" 2>> "err/run_Game_Of_Life_${cores}cores_${size}ArrSize.err"

    done
done

echo "All simulations completed"
