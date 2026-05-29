#!/bin/bash
#SBATCH --job-name=hub
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --array=1-50
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=2G
#SBATCH --partition=short
#SBATCH --output=logs/hub_%A_%a.log

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

file=hubbard.py

task_id=$SLURM_ARRAY_TASK_ID

L=32
U0=10.0
filling=0.5
n_jobs=10

id=$(((task_id - 1) % 10 + 1))

if [ $task_id -le 10 ]; then
    A0=1.0
    omega=2.0
elif [ $task_id -le 20 ]; then
    A0=2.0
    omega=2.0
elif [ $task_id -le 30 ]; then
    A0=3.0
    omega=2.0
elif [ $task_id -le 40 ]; then
    A0=4.0
    omega=2.0
else
    A0=5.0
    omega=2.0
fi

results_dir="results_L${L}_U${U0}_A${A0}_w${omega}_n${filling}"
mkdir -p $results_dir

omega_dir="${results_dir}/omegas"
mkdir -p $omega_dir

correlation_dir="${results_dir}/correlations"
mkdir -p $correlation_dir

conda run -p /home/l.silveira/project_venv python3 "$file" \
    "$id" "$n_jobs" "$omega_dir" "$correlation_dir" "$L" "$U0" "$A0" "$omega" "$filling"