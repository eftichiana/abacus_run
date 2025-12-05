#!/bin/bash

RESULTS_DIR="/proj/nobackup/sens2025035/abacus_results"
BAM_DIR="/proj/sens2025035/ONT_project/BAM"

mkdir -p "${RESULTS_DIR}"

# Δημιουργούμε τη λίστα με όλα τα BAM αρχεία
find "${BAM_DIR}" -maxdepth 1 -name "*.bam" > bam_list.txt

# Μετράμε πόσα BAM αρχεία υπάρχουν
NUM_BAM=$(wc -l < bam_list.txt)

# Δημιουργούμε το SLURM script με τον σωστό αριθμό jobs
cat > run_abacus_array.sbatch << EOF
#!/bin/bash
#SBATCH --job-name=abacus
#SBATCH --output=${RESULTS_DIR}/slurm-%A_%a.out
#SBATCH --error=${RESULTS_DIR}/slurm-%A_%a.err
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH -A sens2025035
#SBATCH --array=1-${NUM_BAM}

module purge

CONTAINER="/proj/sens2025035/containers/abacus-image.sif"
RESULTS_DIR="${RESULTS_DIR}"

BAM_FILE=\$(sed -n "\${SLURM_ARRAY_TASK_ID}p" bam_list.txt)

bash run_abacus_in_container.sh "\${BAM_FILE}"
EOF

# Στέλνουμε το SLURM job array
sbatch run_abacus_array.sbatch
