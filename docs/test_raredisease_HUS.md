# Preparation to test nf-core/raredisease with inhouse data

# Creation of the appropriate reference files.
Most of the reaference input files are already available. The 2 .interval_list filed corresponding to the whole reference genome (autosomes, sex chromosomes and mitochondria) and the Y chromosome separately where created using the same gatk 4.5.0.0 biocontainer that is implemented in the included modules to this pipeline.
From inside the container which was created using the command
```
docker run --rm -it -v /data/test/574/:/data/ quay.io/biocontainers/gatk4:4.5.0.0--py36hdfd78af_0 bash
```
the following commands were run in bash:
```
gatk BedToIntervalList I=human_g1k_v37.bed O=human_g1k_v37.interval_list SD=human_g1k_v37.dict
gatk BedToIntervalList I=human_g1k_v37_Y.bed O=human_g1k_v37_Y.interval_list SD=human_g1k_v37.dict
```
The reference genome copy is in a directory included in the 574 test data.
The files were copied over to the assets directory of this repository.