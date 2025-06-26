#!/bin/bash
#SBATCH -N 1
#SBATCH --time=10:00:00
#SBATCH --exclusive
#SBATCH --partition cpu
#SBATCH --nodelist sorgan-cpu[1-4]
#SBATCH --qos=highprio
#SBATCH --out=sim-compare.log

export APPTAINER_UNSHARE_IPC=1
export CC=clang
export CXX=clang++
export OMP_NUM_THREADS=16 # should we set this?
export LIBOMP_NUM_HIDDEN_HELPER_THREADS=16 # should we set this?

module purge

hosts=$(scontrol show hostnames $SLURM_JOB_NODELIST | tr '\n' ',' | sed 's/,$//')

echo "Running benchmark on hosts: $hosts"

source .venv/bin/activate


spinner run sim-compare.yaml \
    -o pkl/sim-compare.pkl