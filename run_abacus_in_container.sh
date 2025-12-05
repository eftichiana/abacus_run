#!/bin/bash
set -e

BAM_FILE=$1

CONTAINER="/proj/sens2025035/containers/abacus-image.sif"
RESULTS_DIR="/proj/nobackup/sens2025035/abacus_results"
REF_DIR="/home/eftih/reference"
STR_CATALOG="/app/str_catalouges/abacus_catalog.json"

BAM_BASENAME=$(basename "${BAM_FILE}" .bam)
OUT_DIR="${RESULTS_DIR}/${BAM_BASENAME}"
mkdir -p "${OUT_DIR}"

apptainer exec --bind "${BAM_FILE}":"${BAM_FILE}",${OUT_DIR}":"${OUT_DIR}",${REF_DIR}":"${REF_DIR}" ${CONTAINER} bash -c "\
source /opt/conda/etc/profile.d/conda.sh && \
conda activate abacus && \
abacus --bam ${BAM_FILE} \
       --ref ${REF_DIR}/hg38.fa \
       --str-catalog ${STR_CATALOG} \
       --report ${OUT_DIR}/${BAM_BASENAME}.html \
       --vcf ${OUT_DIR}/${BAM_BASENAME}.vcf \
       --sample-id ${BAM_BASENAME} \
       > ${OUT_DIR}/abacus.log 2>&1
"
