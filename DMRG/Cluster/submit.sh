#!/bin/bash
#SBATCH --job-name=hubbard
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --array=1-10
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=2G
#SBATCH --partition=short
#SBATCH --output=logs/hubbard_%A_%a.log

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

file=hubbard.py

task_id=$SLURM_ARRAY_TASK_ID
n_jobs=$SLURM_ARRAY_TASK_COUNT

L=64
U0=5.0
V0=0.0
A0=0.0
omega=5.0
t_probe=5.0

results_dir="results_L${L}_U${U0}_V${V0}_A${A0}_w${omega}_tp${t_probe}"
mkdir -p $results_dir

omega_dir="${results_dir}/omegas"
mkdir -p $omega_dir

correlation_dir="${results_dir}/correlations"
mkdir -p $correlation_dir

python3 $file $task_id $n_jobs $omega_dir $correlation_dir $L $U0 $V0 $A0 $omega $t_probe 