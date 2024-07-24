#!/bin/bash
#SBATCH --time 240:00:00
#SBATCH --mem=2000M # Should be adjusted based on how much memory you need
#SBATCH -o /scratch/log/manual-raredisease-%j.log # %j is the slurmjob id
#SBATCH --account=slurmrunner # We want to run the sbatch scripts as slurmrunner
#SBATCH --uid=6666 # Slurm runners user id
#SBATCH --job-name=raredisease-manual
#SBATCH --partition=sched # update to the dev partition
#SBATCH --priority=1 

# --- Input ---
INPUT_SAMPLESHEET="/persistent/Eirini_Data_transfer/test_full_data/ref_input/raredisease_test_samplesheet.csv"
PARAMS_FILE="/persistent/Eirini_Data_transfer/test_full_data/ref_input/test_parameters.yaml"

# --- Output ---
OUTPUT_FOLDER="/persistent/Eirini_Data_transfer/test_full_data/output_040424_A00001_0002_VFDB1BGVCF"
# RESULT_FOLDER=${RUN_ROOT}/results



# --- General ---
PIPELINE_IMAGE=registry.mgmlab.net/docker-images/nextflow-slurm:v3.1.1
PIPELINE_URL=https://github.com/irliampa/raredisease.git
PIPELINE_REVISION="setting_up_dev"
SCRATCH_ROOT=/scratch/raredisease
# to resume an analysis set run root to the JobID directory of the job to be resumed
# and add the -resume flag to the nextflow run command
RUN_ROOT=${SCRATCH_ROOT}/363622


# --- Command ---
docker run --rm \
    -v /data/test/574/input/dbsnp/:/data/test/574/input/dbsnp/ \
    -v /data/test/574/ref_files_to_compare/HumanG1Kv37:/data/test/574/ref_files_to_compare/HumanG1Kv37/ \
    -v /persistent/diagnostic/reference/g1k_v37/:/persistent/diagnostic/reference/g1k_v37/:ro \
    -v /persistent/Eirini_Data_transfer/test_full_data/:/persistent/Eirini_Data_transfer/test_full_data/ \
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
    -profile docker \
    -process.executor=slurm \
    -process.queue='low' \
    -r ${PIPELINE_REVISION} \
    -params-file ${PARAMS_FILE} \
    --outdir ${OUTPUT_FOLDER} \
    --input ${INPUT_SAMPLESHEET} \
    -resume