#!/bin/bash
#SBATCH --time 24:00:00
#SBATCH --mem=2000M # Should be adjusted based on how much memory you need
#SBATCH -o /scratch/log/manual-raredisease-%j.log # %j is the slurmjob id
#SBATCH --account=slurmrunner # We want to run the sbatch scripts as slurmrunner
#SBATCH --uid=6666 # Slurm runners user id
#SBATCH --job-name=raredisease-manual
#SBATCH --partition=sched # update to the dev partition
#SBATCH --priority=1 

# --- Input ---
# 
RUN_FOLDER="/data/test/57/raredisease_test/test_data/240318_A01268_0362_BH3K3HDRX5/"
# REF_GENOME="/data/reference/IGSR/genome/HumanG1Kv37/human_g1k_v37.fasta"
# DBSNP_DB="/data/test/574/input/dbsnp/dbsnp_138.b37.vcf.gz"
# INPUT_LIST="${RUN_FOLDER}/test_run1_blacklist.csv"
# INPUT_DIR=/data/test/57/input/


# --- Output ---
OUTPUT_FOLDER="/data/test/57/raredisease_test/output_240318_A01268_0362_BH3K3HDRX5"
# RESULT_FOLDER=${RUN_ROOT}/results



# --- General ---
PIPELINE_IMAGE=registry.mgmlab.net/docker-images/nextflow-slurm:v3.1.1
PIPELINE_URL=https://github.com/irliampa/raredisease.git
PIPELINE_REVISION="setting_up_dev"
SCRATCH_ROOT=/scratch/$(basename $PIPELINE_URL)
RUN_ROOT=${SCRATCH_ROOT}/${SLURM_JOB_ID}


# --- Command ---
docker run --rm \
    -v /data/test/574/:/data/test/574/ \
    -v /data/reference/:/data/reference/:ro \
    -v /etc/slurm-llnl/:/etc/slurm-llnl/:ro \
    -v /etc/munge/:/etc/munge/:ro \
    -v /run/munge/:/run/munge/:ro \
    -v /scratch/:/scratch/ \
    -e NXF_WORK="${RUN_ROOT}/work" \
    -e NXF_HOME="${RUN_ROOT}/.nextflow" \
    -e NXF_SCM_FILE="/next/.nextflow/scm" \
    -w ${RUN_ROOT} \
    --network host $PIPELINE_IMAGE \
    nextflow run ${PIPELINE_URL} \
    -profile test,singularity \
    #docker \
    -process.executor=slurm \
    -process.queue='low' \
    -r ${PIPELINE_REVISION} \
    --outdir ${OUTPUT_FOLDER} \
    --input ${INPUT_LIST} \
    -params.file ${PIPELINE_URL}/assets/test_parameters.yaml