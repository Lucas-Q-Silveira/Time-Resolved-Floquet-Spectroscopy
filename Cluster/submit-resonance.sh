#!/bin/bash
#SBATCH --job-name=hub
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --array=1-40
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=4G
#SBATCH --partition=short
#SBATCH --output=logs/hub_%A_%a.log

export OMP_NUM_THREADS=1

file=hubbard.py

task_id=$SLURM_ARRAY_TASK_ID
job_id=$SLURM_ARRAY_JOB_ID

L=32
U0=10.0
filling=1.0
n_jobs=10

# Explicit per-combo (V0, A0, omega) lists. Four combinations:
#   0: V=5, A=1.5, omega=7.0
#   1: V=5, A=1.5, omega=5.0
#   2: V=5, A=3.0, omega=7.0
#   3: V=5, A=3.0, omega=5.0
V0_combo=(5.0    5.0     5.0    5.0)
A0_combo=(1.5  1.5   3.0  3.0)
omega_combo=(7.0  5.0  7.0  5.0)

# Each block of n_jobs (10) consecutive task_ids handles one (V0, A0, omega) combo.
# Within a block, id runs 1..n_jobs to partition the energy array in the .py.
combo=$(((task_id - 1) / n_jobs))      # 0..3   -> which (V0, A0, omega) combination
id=$(((task_id - 1) % n_jobs + 1))     # 1..10  -> energy-array partition index

V0=${V0_combo[$combo]}
A0=${A0_combo[$combo]}
omega=${omega_combo[$combo]}

global_dir="results_id${job_id}"
mkdir -p $global_dir

results_dir="${global_dir}/results_L${L}_U${U0}_V${V0}_A${A0}_w${omega}_n${filling}"
mkdir -p $results_dir

omega_dir="${results_dir}/omegas"
mkdir -p $omega_dir

correlation_dir="${results_dir}/correlations"
mkdir -p $correlation_dir

conda run -p /home/l.silveira/project_venv python3 "$file" \
    "$id" "$n_jobs" "$omega_dir" "$correlation_dir" "$L" "$U0" "$V0" "$A0" "$omega" "$filling"