#!/bin/bash
#SBATCH -N 10
#SBATCH --time=20:00:00
#SBATCH --exclusive
#SBATCH --partition=par480-i
#SBATCH --out=tb-compare-coaraci.log

export APPTAINER_UNSHARE_IPC=1
export CC=clang
export CXX=clang++
export OMP_NUM_THREADS=16 # should we set this?
export LIBOMP_NUM_HIDDEN_HELPER_THREADS=16 # should we set this?

module purge
module load mpich/4.2.2-ucx
module load singularity/3.7.1

hosts=$(scontrol show hostnames $SLURM_JOB_NODELIST | tr '\n' ',' | sed 's/,$//')

echo "Running benchmark on hosts: $hosts"

source .venv/bin/activate

echo "Launching.."

spinner -vv run tb-compare-coaraci.yaml \
    --extra-args "hosts=$hosts" \
    -o pkl/tb-compare-coaraci-${SLURM_JOB_ID}.pkl
