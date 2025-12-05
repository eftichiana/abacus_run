#!/bin/bash
#SBATCH --job-name=abacus
#SBATCH --output=/proj/nobackup/sens2025035/abacus_results/slurm-%A_%a.out
#SBATCH --error=/proj/nobackup/sens2025035/abacus_results/slurm-%A_%a.err
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH -A sens2025035
#SBATCH --array=1-$(cat bam_list.txt | wc -l)

module purge

CONTAINER="/proj/sens2025035/containers/abacus-image.sif"
RESULTS_DIR="/proj/nobackup/sens2025035/abacus_results"

BAM_FILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" bam_list.txt)

bash run_abacus_in_container.sh "${BAM_FILE}"
