#### Framework for PHYLOGENOMICS, using Anvio

# rename fasta according to header
for fname in *.fna; do
mv -- "$fname" \
"$(awk 'NR==1{printf("%s_%s_%s\n",$2,$3,substr($1,2));exit}' "$fname")".fna
done

for i in `ls *fna | awk 'BEGIN{FS=".fna"}{print $1}'`
do
    anvi-script-reformat-fasta $i.fna -o $i-fixed.fa -l 0 --simplify-names
    mv $i.fna FASTA
    anvi-gen-contigs-database -f $i-fixed.fa -o $i.db -T 10
    anvi-run-hmms -c $i.db
    rm $i-fixed.fa
done

# make external-genomes.txt
find *fna.gz > external-genomes.txt
# open vim/nano/excel and make rest....


##
anvi-get-sequences-for-hmm-hits --external-genomes external-genomes.txt \
                                -o concatenated-proteins.fa \
                                --hmm-source Bacteria_71 \
                                --gene-names Ribosomal_L1,Ribosomal_L2,Ribosomal_L3,Ribosomal_L4,Ribosomal_L5,Ribosomal_L6 \
                                --return-best-hit \
                                --get-aa-sequences \
                                --concatenate
###
anvi-gen-phylogenomic-tree -f concatenated-proteins.fa \
                           -o phylogenomic-tree.txt
###
anvi-interactive -p phylogenomic-profile.db \
                 -t phylogenomic-tree.txt \
                 --manual \
                 --server-only
