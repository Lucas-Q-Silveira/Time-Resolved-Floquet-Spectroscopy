#!/bin/bash
#SBATCH --job-name=hub
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --array=1-60
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=4G
#SBATCH --partition=short
#SBATCH --output=logs/hub_%A_%a.log

export OMP_NUM_THREADS=1

file=spinful.py

task_id=$SLURM_ARRAY_TASK_ID
job_id=$SLURM_ARRAY_JOB_ID

L=32
n_jobs=10

# Undriven run: no Peierls drive.
A0=0.0
omega=0.0

# Half filling (particle-hole symmetric point, <Ntot>=1).
filling=1.0

# Parameter scan over (U0, V0), undriven (A0=0, omega=0), at half filling:
#   U0 = (0.0, 5.0)        -> 2 values
#   V0 = (0.0, 5.0, 10.0)  -> 3 values
# Each combo run with n_jobs (10) partitions.
# Total array size = (2 * 3) * 10 = 6 * 10 = 60.

# Build the (U0, V0) combination lists.
U0_combo=()
V0_combo=()
for U0_val in 0.0 5.0; do
    for V0_val in 0.0 5.0 10.0; do
        U0_combo+=("$U0_val")
        V0_combo+=("$V0_val")
    done
done

# Each block of n_jobs (10) consecutive task_ids handles one (U0, V0) combo.
# Within a block, id runs 1..n_jobs to partition the energy array in the .py.
combo=$(((task_id - 1) / n_jobs))      # 0..5   -> which (U0, V0) combination
id=$(((task_id - 1) % n_jobs + 1))     # 1..10  -> energy-array partition index

U0=${U0_combo[$combo]}
V0=${V0_combo[$combo]}

global_dir="results_id${job_id}"
mkdir -p $global_dir

results_dir="${global_dir}/results_L${L}_U${U0}_V${V0}_n${filling}"
mkdir -p $results_dir

omega_dir="${results_dir}/omegas"
mkdir -p $omega_dir

correlation_dir="${results_dir}/correlations"
mkdir -p $correlation_dir

conda run -p /home/l.silveira/project_venv python3 "$file" \
    "$id" "$n_jobs" "$omega_dir" "$correlation_dir" "$L" "$U0" "$V0" "$A0" "$omega" "$filling"