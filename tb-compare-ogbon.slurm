#!/bin/bash
#SBATCH -N 15
#SBATCH --time=10:10:00
#SBATCH --partition=gpulongd
#SBATCH --account=cenpes-unicamp
#SBATCH --exclusive
#SBATCH --out=tb-compare-ogbon.log
#SBATCH --time=10-99:00:00

export APPTAINER_UNSHARE_IPC=1
export CC=clang
export CXX=clang++
export OMP_NUM_THREADS=16 # should we set this?
export LIBOMP_NUM_HIDDEN_HELPER_THREADS=16 # should we set this?

# Load required modules
export MODULEPATH=/parceirosbr/cenpes-unicamp/spack/share/spack/modules/linux-rhel7-cascadelake:/usr/share/Modules/modulefiles:/etc/modulefiles:/opt/share/modulefiles:/opt/fast/modulefiles

# Load Spinner env
source .venv/bin/activate

module purge
module load mpich/4.2.3-ucx
module load apptainer

hosts=$(scontrol show hostnames $SLURM_JOB_NODELIST | tr '\n' ',' | sed 's/,$//')

echo "Running benchmark on hosts: $hosts"

source .venv/bin/activate


spinner run tb-compare-ogbon.yaml \
    --extra-args "hosts=$hosts" \
    -o tb-compare-ogbon.pkl
