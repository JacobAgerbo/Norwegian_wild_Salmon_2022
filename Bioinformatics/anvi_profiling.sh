#!/bin/sh
###Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku_00012 -A ku_00012
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N NWS_Profiling
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=40
### Memory
#PBS -l mem=20gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 12 hours)
#PBS -l walltime=5:00:00:00

## CODE STARTS FROM BELOW
module load ngs tools htslib/1.9 samtools/1.9 bedtools/2.26.0 bwa anvio/7.1

DATA='/path/to/data/03_MapToRef'
BAM='/path/to/data/BAMs'
CON='/path/to/contigs/db'

cd $DATA
find *.fq.gz > list
sed 's/_metaG_[1-2].fq.gz//g' list > list2
uniq list2 > sample_list
rm -f list*
sample_list=$(cat sample_list)
echo ${sample_list[@]}

THREADS='40'
for a in $sample_list
  do
  echo "$a"
  bwa mem -t "$THREADS" $CON/10K_contigs-fixed.fa $DATA/"$a"_metaG_1.fq.gz $DATA/"$a"_metaG_2.fq.gz > $BAM/"$a"_aln_pe.sam
		samtools view -@ "$THREADS" -bS $BAM/"$a"_aln_pe.sam > $BAM/"$a"_aln_pe.bam
        		anvi-init-bam $BAM/"$a"_aln_pe.bam -o $BAM/"$a"_out.bam
          			anvi-profile -i $BAM/"$a"_out.bam -c $CON/10K_CONTIGS.db -o $CON/Profiles/"$a" -T "$THREADS" --cluster-contigs --profile-SCVs -M 500 --write-buffer-size 1000
done
