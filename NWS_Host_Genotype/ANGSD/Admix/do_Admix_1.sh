#!/bin/sh
###Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku-cbd -A ku-cbd
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N NWS_Admix_1
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
#PBS -j oe
#PBS -k oe
### Number of nodes
#PBS -l nodes=1:ppn=40
### Memory
#PBS -l mem=20gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 12 hours)
#PBS -l walltime=2:00:00:00

# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

# Load all required modules for the job
module load htslib/1.7 angsd/0.921 ngsadmix/32
bash run_admixture_1.sh
