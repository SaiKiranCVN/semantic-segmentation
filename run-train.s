#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --time=60:00:00
#SBATCH --mem=64GB
#SBATCH --gres=gpu:2
#SBATCH --job-name=semsegtrain

module purge

singularity exec --nv \
	    --overlay /scratch/vc2118/ins/pytorch1.8.0-cuda11.1.ext3:ro \
	    /scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif \
	    /bin/bash -c "source /ext3/env.sh; sh train_cmd.sh"
