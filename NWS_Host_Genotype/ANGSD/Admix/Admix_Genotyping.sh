#!/bin/sh
###Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku-cbd -A ku-cbd
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N Admix_Host_genotype
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
module load ngs tools htslib/1.7 angsd/0.921
angsd -bam /home/projects/ku-cbd/data/jacras/3-NWS/08_Host_Genotype/sample_list.txt -nThreads 40 -minMapQ 30 -minQ 20 -doGlf 2  -GL 1 -out all -doMajorMinor 1 -doMaf 1 -SNP_pval 2e-6 -doIBS 1 -doCounts 1 -doCov 1 -makeMatrix 1 -minMaf 0.05 -minInd $((96*90/100))
