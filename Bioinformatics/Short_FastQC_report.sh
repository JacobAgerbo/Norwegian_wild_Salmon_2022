#-----------------------------------------------------------------#
#							           -QC	Report from FASTQC-  	     				  #
#-----------------------------------------------------------------#
module load java/1.8.0  fastqc/0.11.8
mkdir FastQC_initial
cd FastQC_initial


#!/bin/sh
###Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku-cbd -A ku-cbd
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N jacras_SG01_trim
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=21
### Memory
#PBS -l mem=120gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 12 hours)
#PBS -l walltime=7:00:00:00

# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

### CODE starts from here
# Load all required modules for the job
module load perl/5.24.0 java/1.8.0  fastqc/0.11.8
fastqc -o . ../*.fq.gz

### Create short report for all samples
unzip '*fastqc.zip'
FASTA_DIR='path/to/FastQC_initial'
WORK_DIR='path/to/FastQC_initial'

cd $FASTA_DIR/
find *_fastqc.zip > temp
sed 's/_fastqc.zip//g' temp > temp2
uniq temp2 > sample_list.txt
rm -f temp*
sample_list=$(cat sample_list.txt)
cd $WORK_DIR
for a in $sample_list
  do
  cd "$a"_fastqc
    total_seqs=`cat fastqc_data.txt | grep 'Total Sequences' | cut -f 2`
    gc_percent=`cat fastqc_data.txt | grep '%GC' | cut -f 2`
    seq_length=`cat fastqc_data.txt | grep -A1 '#Length' | tail -n +2 | cut -f 1`
    seq_qual=`cat fastqc_data.txt | awk '/>>Per base sequence quality/,/>>END_MODULE/' | tail -n +3 | head -n -1 | awk '{total+=$2} END {print total/NR}'`
    n_count=`cat fastqc_data.txt | awk '/>>Per base N content/,/>>END_MODULE/' | tail -n +3 | head -n -1 | awk '{total+=$2} END {print total/NR}'`
    echo -e "File Name:\t"$a"\nNumber of Sequences:\t${total_seqs}\nGC%:\t${gc_percent}\nSequence Length:\t${seq_length}\nAverage per base sequence quality:\t${seq_qual}\nN%\t${n_count}" > ../"$a"_short.txt
    cd ..
    rm -r "$a"_fastqc
done
cat *.txt > initial_report.txt
rm *_short.txt
