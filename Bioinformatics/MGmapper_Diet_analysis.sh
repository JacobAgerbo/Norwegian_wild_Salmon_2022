#!/bin/sh
###Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku_00012 -A ku_00012
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N NWS_MGmapper
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=40
### Memory
#PBS -l mem=20gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 12 hours)
#PBS -l walltime=10:00:00:00

# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

# Load all required modules for the job
module load perl mgmapper/2.8
WORK_DIR='/home/projects/ku-cbd/data/jacras/3-NWS/05_MG_Filtering'
DATA='/home/projects/ku-cbd/data/jacras/3-NWS/03_MapToRef'
cd $DATA
find *.fq.gz > list
sed 's/_metaG_[1-2].fq.gz//g' list > list2
uniq list2 > sample_list
rm -f list*
sample_list=$(cat sample_list)
cd $WORK_DIR

for i in $sample_list
  do
    MGmapper_PE.pl -P $WORK_DIR/databases.txt -Q $WORK_DIR/adapter.txt -i $DATA/"$i"_metaG_1.fq.gz -j $DATA/"$i"_metaG_2.fq.gz -d $WORK_DIR/"$i" -m 50 -C 7,15,14,9 -c 40  -p -n "$i"
done
