#!/bin/sh
###Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku-cbd -A ku-cbd
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N NWS_Assembly
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=40
### Memory
#PBS -l mem=100gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 12 hours)
#PBS -l walltime=7:00:00:00
###
## code start from below
module load megahit/1.1.1 anaconda2/4.4.0
FASTA_DIR='/path/to/fastq'
ASSEM_DIR='/path/to/assembly/wd'
FASTA=$(ls $FASTA_DIR/*.fastq.gz | python -c 'import sys; print ",".join([x.strip() for x in sys.stdin.readlines()])')
megahit -r $FASTA --min-contig-len 1000 -t 40 --presets meta-sensitive -o $ASSEM_DIR
