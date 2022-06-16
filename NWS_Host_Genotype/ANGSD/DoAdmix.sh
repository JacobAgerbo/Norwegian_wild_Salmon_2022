#!/bin/sh
###Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku-cbd -A ku-cbd
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N NWS_Admix
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
#PBS -j oe
#PBS -k oe
### Number of nodes
#PBS -l nodes=1:ppn=40
### Memory
#PBS -l mem=60gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 12 hours)
#PBS -l walltime=5:00:00:00

# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

# Load all required modules for the job
module load htslib/1.7 angsd/0.921 ngsadmix/32
angsd -bam /home/projects/ku-cbd/data/jacras/3-NWS/08_Host_Genotype/ANGSD/sample_list.txt -nThreads 40 -minMapQ 30 -minQ 20 -out ForAdmix -GL 1 -doGlf 2 -doMajorMinor 1 -SNP_pval 1e-6 -doMaf 1
#paste -d " " <( cut -f 5 -d"." sample_list.txt) <(cut -f 1 -d"." sample_list.txt | xargs -n1 basename) > pop.info
##
NGSadmix -likes ForAdmix.beagle.gz -K 3 -o NWS_K3 -P 40
NGSadmix -likes ForAdmix.beagle.gz -K 4 -o NWS_K4 -P 40
NGSadmix -likes ForAdmix.beagle.gz -K 5 -o NWS_K5 -P 40
NGSadmix -likes ForAdmix.beagle.gz -K 6 -o NWS_K6 -P 40
NGSadmix -likes ForAdmix.beagle.gz -K 7 -o NWS_K7 -P 40
NGSadmix -likes ForAdmix.beagle.gz -K 8 -o NWS_K8 -P 40
NGSadmix -likes ForAdmix.beagle.gz -K 9 -o NWS_K9 -P 40
NGSadmix -likes ForAdmix.beagle.gz -K 10 -o NWS_K10 -P 40
