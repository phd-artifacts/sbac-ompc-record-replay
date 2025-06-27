#!/bin/bash
#SBATCH -N 10
#SBATCH --time=10:10:00
#SBATCH --exclusive
#SBATCH --partition all
#SBATCH --nodelist sorgan-cpu[1-6],sorgan-gpu[1-4]
#SBATCH --qos=highprio
#SBATCH --out=tb-compare.log
#SBATCH --reservation=remy_sbac
#SBATCH --time=10-99:00:00

export APPTAINER_UNSHARE_IPC=1
export CC=clang
export CXX=clang++
export OMP_NUM_THREADS=16 # should we set this?
export LIBOMP_NUM_HIDDEN_HELPER_THREADS=16 # should we set this?

module purge
module load mpich/4.2.3-ucx

hosts=$(scontrol show hostnames $SLURM_JOB_NODELIST | tr '\n' ',' | sed 's/,$//')

echo "Running benchmark on hosts: $hosts"

source .venv/bin/activate


spinner run tb-compare-sorgan.yaml \
    --extra-args "hosts=$hosts" \
    -o "pkl/tb-compare-sorgan-$SLURM_JOB_ID.pkl"
