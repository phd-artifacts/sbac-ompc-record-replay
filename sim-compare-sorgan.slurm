#!/bin/bash
#SBATCH -N 1
#SBATCH --time=10:00:00
#SBATCH --exclusive
#SBATCH --qos=highprio
#SBATCH --out=sim-compare.log
#SBATCH --partition all
#SBATCH --nodelist sorgan-cpu[1-6],sorgan-gpu[1-4]
#SBATCH --reservation=remy_sbac
#SBATCH --time=10-99:00:00

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