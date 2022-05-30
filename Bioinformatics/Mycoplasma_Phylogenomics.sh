########################################################################################################################################################
####################                                        MYCOPLASMA PAN- AND PHYLOGENOMICS                                       ####################
########################################################################################################################################################

### Create Anvio DB's for each genome
for i in *fa
do
	anvi-script-FASTA-to-contigs-db $i
done


### Create HMMs for a DB's
for a in *CONTIGS.db
  do
    anvi-run-hmms -c ./"$a"
done

### create protein allignment
anvi-get-sequences-for-hmm-hits --external-genomes external-genomes_2.txt \
                                -o concatenated-proteins.fa \
                                --hmm-source Bacteria_71 \
                                --return-best-hit \
                                --get-aa-sequences \
                                --concatenate

# Log: 2477 hits for 1 source(s) / 2464 hits remain after removing weak hits for multiple hits

### Generate phylogenomic tree
anvi-gen-phylogenomic-tree -f concatenated-proteins.fa \
                           -o phylogenomic-tree.txt

## Alignment sequence length ....................: 16,768


###
anvi-interactive -p phylogenomic-profile.db \
                 -t phylogenomic-tree.txt \
                 --title "Phylogenomics of Mycoplasma" \
                 --manual \
                 --server-only \
                 -d view.txt

##
