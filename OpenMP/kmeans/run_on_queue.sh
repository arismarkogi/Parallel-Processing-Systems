#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_kmeans

## Output and error files
#PBS -o /home/parallel/parlab20/a2/kmeans/run/out/run_locks_kmeans.out
#PBS -e /home/parallel/parlab20/a2/kmeans/run/err/run_locks_kmeans.err

## How many machines should we get? 
#PBS -l nodes=sandman:ppn=64

##How long should the job run for?
#PBS -l walltime=00:40:00

## Start 
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab20/a2/kmeans

# Array of core counts
core_counts=(1 2 4 8 16 32 64)

# Array of lock implementations
lock_implementations=(
    "kmeans_omp_nosync_lock"
    "kmeans_omp_pthread_mutex_lock"
    "kmeans_omp_pthread_spin_lock"
    "kmeans_omp_tas_lock"
    "kmeans_omp_ttas_lock"
    "kmeans_omp_array_lock"
    "kmeans_omp_clh_lock"
    "kmeans_omp_critical"
)


# Define the CPU lists per NUMA node for GOMP_CPU_AFFINITY
numa_node_cpus=(
    "0-7,32-39"    # NUMA node 0
    "8-15,40-47"   # NUMA node 1
    "16-23,48-55"  # NUMA node 2
    "24-31,56-63"  # NUMA node 3
)

# Loop through each lock implementation
for impl in "${lock_implementations[@]}"
do
    # Loop through each core count
    for cores in "${core_counts[@]}"
    do
        # Set the number of OpenMP threads
        export OMP_NUM_THREADS=$cores

        # Choose the appropriate NUMA node CPUs based on the core count
        if [ $cores -le 16 ]; then
            export GOMP_CPU_AFFINITY="${numa_node_cpus[0]}"
        elif [ $cores -le 32 ]; then
            export GOMP_CPU_AFFINITY="${numa_node_cpus[0]},${numa_node_cpus[1]}"
        elif [ $cores -le 48 ]; then
            export GOMP_CPU_AFFINITY="${numa_node_cpus[0]},${numa_node_cpus[1]},${numa_node_cpus[2]}"
        else
            export GOMP_CPU_AFFINITY="${numa_node_cpus[0]},${numa_node_cpus[1]},${numa_node_cpus[2]},${numa_node_cpus[3]}"
        fi

        # Run the kmeans executable
        ./"$impl" -s 32 -n 16 -c 32 -l 10 >> "/home/parallel/parlab20/a2/kmeans/run/out/run_${impl}_${cores}.out" 2>> "/home/parallel/parlab20/a2/kmeans/run/err/run_${impl}_${cores}.err"
    done
done
