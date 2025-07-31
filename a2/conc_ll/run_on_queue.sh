#!/bin/bash

# Descriptive job name
#PBS -N cll

# Output and error files
#PBS -o /home/parallel/parlab20/a2/conc_ll/run/out/cll.out
#PBS -e /home/parallel/parlab20/a2/conc_ll/run/err/cll.err

## How many machines should we get?
#PBS -l nodes=sandman:ppn=64

##How long should the job run for?
#PBS -l walltime=03:00:00

# Change to the appropriate directory
cd /home/parallel/parlab20/a2/conc_ll

# Arrays for experimental parameters
executables=("x.cgl" "x.fgl" "x.opt" "x.lazy" "x.nb")  # Executables from Makefile
thread_counts=(1 2 4 8 16 32 64 128)  # Number of threads
operation_percentages=("100-0-0" "80-10-10" "20-40-40" "0-50-50")  # Operation percentages
list_sizes=(1024 8192)                # List sizes

# NUMA node CPU affinity mapping
# Each NUMA node has 16 CPUs: 8 physical cores and 8 hyperthreads
numa_node_cpus=(
    "0 1 2 3 4 5 6 7 32 33 34 35 36 37 38 39"    # NUMA node 0
    "8 9 10 11 12 13 14 15 40 41 42 43 44 45 46 47"   # NUMA node 1
    "16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55"  # NUMA node 2
    "24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63"  # NUMA node 3

)

# Combine all CPUs into a single array
cores=()
for node_cpus in "${numa_node_cpus[@]}"; do
    for cpu in $node_cpus; do
        cores+=("$cpu")
    done
done

# Define output directories
out_dir="/home/parallel/parlab20/a2/conc_ll/run/out"
err_dir="/home/parallel/parlab20/a2/conc_ll/run/err"

# Run the serial implementation separately
serial_executable="x.serial"
echo "Running the serial executable $serial_executable"
for list_size in "${list_sizes[@]}"; do
    for op_percent in "${operation_percentages[@]}"; do
        # Parse operation percentages
        IFS='-' read -r lookup_pct insert_pct delete_pct <<< "$op_percent"

        # Output file names
        out_file="$out_dir/${serial_executable}_1_${lookup_pct}_${insert_pct}_${delete_pct}_${list_size}.out"
        err_file="$err_dir/${serial_executable}_1_${lookup_pct}_${insert_pct}_${delete_pct}_${list_size}.err"

        # Run the serial executable with the given parameters
        echo "Running $serial_executable with list size $list_size, operations $lookup_pct-$insert_pct-$delete_pct"
        ./"$serial_executable" $list_size $lookup_pct $insert_pct $delete_pct > "$out_file" 2> "$err_file"
    done
done

# Loop over each executable
for exe in "${executables[@]}"; do
    # Loop over thread counts
    for threads in "${thread_counts[@]}"; do
        total_cores=${#cores[@]}

        # Generate MT_CONF based on the number of threads
        if [ "$threads" -le "$total_cores" ]; then
            # Select first N cores
            MT_CONF=$(printf "%s," "${cores[@]:0:$threads}")
            MT_CONF=${MT_CONF%,}  # Remove trailing comma
        else
            # For threads > total_cores, duplicate cores to utilize hyperthreading and oversubscription
            times=$(( (threads + total_cores - 1) / total_cores ))
            MT_CONF=""
            for ((i=0; i<$times; i++)); do
                MT_CONF+=$(printf "%s," "${cores[@]}")
            done
            MT_CONF=${MT_CONF%,}  # Remove trailing comma
            # Trim to the number of threads
            IFS=',' read -r -a MT_CONF_ARRAY <<< "$MT_CONF"
            MT_CONF_ARRAY=("${MT_CONF_ARRAY[@]:0:$threads}")
            MT_CONF=$(printf "%s," "${MT_CONF_ARRAY[@]}")
            MT_CONF=${MT_CONF%,}
        fi

        export MT_CONF  # Set the environment variable

        # Loop over list sizes
        for list_size in "${list_sizes[@]}"; do
            # Loop over operation percentages
            for op_percent in "${operation_percentages[@]}"; do
                # Parse operation percentages
                IFS='-' read -r lookup_pct insert_pct delete_pct <<< "$op_percent"

                # Output file names
                out_file="$out_dir/${exe}_${threads}_${lookup_pct}_${insert_pct}_${delete_pct}_${list_size}.out"
                err_file="$err_dir/${exe}_${threads}_${lookup_pct}_${insert_pct}_${delete_pct}_${list_size}.err"

                # Run the executable with the given parameters
                echo "Running $exe with $threads threads, list size $list_size, operations $lookup_pct-$insert_pct-$delete_pct"
                ./"$exe" $list_size $lookup_pct $insert_pct $delete_pct > "$out_file" 2> "$err_file"
            done
        done
    done
done
