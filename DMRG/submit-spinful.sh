#!/bin/bash
#SBATCH --job-name=hub
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --array=1-50
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
V0=5.0
filling=0.5
n_jobs=10

# In-gap CDW scan (Osterkorn et al., arXiv:2205.09557), U=0, half filling.
# Fixed V=5.0. Per-combo (A0, omega) lists:
#   combos 0..4:   A0=(1.5) x omega=(1.0 3.0 4.0 5.0 8.0)
# Each combo run with n_jobs (10) partitions.
# Total array size = (1*5) * 10 = 5 * 10 = 50.

# Build the (A0, omega) combination lists.
A0_combo=()
omega_combo=()
for A0_val in 1.5; do
    for omega_val in 1.0 3.0 4.0 5.0 8.0; do
        A0_combo+=("$A0_val")
        omega_combo+=("$omega_val")
    done
done

# Each block of n_jobs (10) consecutive task_ids handles one (A0, omega) combo.
# Within a block, id runs 1..n_jobs to partition the energy array in the .py.
combo=$(((task_id - 1) / n_jobs))      # 0..4   -> which (A0, omega) combination
id=$(((task_id - 1) % n_jobs + 1))     # 1..10  -> energy-array partition index

A0=${A0_combo[$combo]}
omega=${omega_combo[$combo]}

global_dir="results_id${job_id}"
mkdir -p $global_dir

results_dir="${global_dir}/results_L${L}_V${V0}_A${A0}_w${omega}_n${filling}"
mkdir -p $results_dir

omega_dir="${results_dir}/omegas"
mkdir -p $omega_dir

correlation_dir="${results_dir}/correlations"
mkdir -p $correlation_dir

conda run -p /home/l.silveira/project_venv python3 "$file" \
    "$id" "$n_jobs" "$omega_dir" "$correlation_dir" "$L" "$V0" "$A0" "$omega" "$filling"
