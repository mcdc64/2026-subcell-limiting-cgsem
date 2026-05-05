#!/bin/bash
#SBATCH --job-name=mms_solve
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=80
#SBATCH --gres=gpu:1
#SBATCH --chdir=.
#SBATCH --output=mms_logs_%J.out
#SBATCH --error=mms_logs_%J.err
#SBATCH --partition=standard-gpu 

# Edit the SLURM details above as necessary, e.g. partition, qos, to request a GPU.

# path to the EXECUTABLE of your SOD2D build
SOD2D_SRC_DIR=/path/to/sod2d/executable

# path to FOLDERS of C/Fortran compilers and libs used in the SOD2D build
COMPILERS_DIR=/path/to/compilers
COMPILERS_LIB=/path/to/compilers/lib

# path to FOLDER of HDF5 library (compiled with the same compilers used in COMPILERS_DIR)
HDF5_DIR=/path/to/HDF5/installation

# path to script that binds GPUs (at top level of this repo)
GPUBIND_DIR=/path/to/X_bind.sh

########## USER INPUT ENDS HERE ##########

# add compilers
export PATH=$COMPILERS_DIR:$PATH
export LD_LIBRARY_PATH=$COMPILERS_LIB:$LD_LIBRARY_PATH

# add HDF5 module
export PATH=$HDF5_DIR/bin:$PATH
export LD_LIBRARY_PATH=$HDF5_DIR/lib:LD_LIBRARY_PATH
export LIBRARY_PATH=$HDF5_DIR/lib:LIBRARY_PATH

export SLURM_CPU_BIND=none

mpirun -np 1 --bind-to none --map-by ppr:4:node:PE=20 --report-bindings $GPUBIND_DIR $SOD2D_SRC_DIR MMSSolver.json

