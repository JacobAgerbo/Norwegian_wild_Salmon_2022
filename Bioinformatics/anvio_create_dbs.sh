CONTIGS='path/to/contigs/db'
PROFILES='path/to/profiles/db'

anvi-script-reformat-fasta *contigs.fa -o contigs-fixed.fa -l 1000 --simplify-names
### Create contigs db
anvi-gen-contigs-database -f contigs-fixed.fa -o CONTIGS.db -n 'CONTIG DB of Norwegian Wild Salmon Samples'

# Merge Profiles
anvi-merge $PROFILES/*/PROFILE.db -o $PROFILES/MERGED_Profile --enforce-hierarchical-clustering -c $CONTIGS/CONTIGS.db

### Create hidden Markov models
for db in CONTIGS.db
  do
    anvi-run-hmms -c $CONTIGS/"$db" --num-threads 10
    # Make functional annotation
    echo "Doing COGs"
    anvi-run-ncbi-cogs -c $CONTIGS/"$db" --num-threads 10
    echo "Doing PFAMs"
    anvi-run-pfams -c $CONTIGS/"$db" --num-threads 10
done

## Assign Taxonomy with KAIJU
anvi-get-sequences-for-gene-calls -c $CONTIGS/CONTIGS.db -o gene_calls.fa

kaiju_path='path/to/kaiju/2020-05-25_nr_euk'

kaiju -t $kaiju_path/nodes.dmp \
      -f $kaiju_path/kaiju_db_nr_euk.fmi \
      -i gene_calls.fa \
      -o gene_calls_nr.out \
      -z 10 \
      -v
#
addTaxonNames -t $kaiju_path/nodes.dmp \
              -n $kaiju_path/names.dmp \
              -i gene_calls_nr.out \
              -o gene_calls_nr.names \
              -r superkingdom,phylum,order,class,family,genus,species
#
anvi-import-taxonomy-for-genes -i gene_calls_nr.names \
                                 -c $CONTIGS/CONTIGS.db \
                                 -p kaiju \
                                 --just-do-it

#
# Use CONCOCT
anvi-cluster-contigs -p $PROFILES/MERGED_Profile/PROFILE.db -c $CONTIGS/CONTIGS.db -C CONCOCT --driver concoct --just-do-it -T 10

# Make MAG calling
anvi-rename-bins -c $CONTIGS/CONTIGS.db \
               -p $PROFILES/PROFILE.db \
               --prefix NWS \
               --collection-to-read CONCOCT \
               --collection-to-write MAGs \
               --report-file rename.txt \
               --min-completion-for-MAG 50 \
               --max-redundancy-for-MAG 30 \
               --call-MAGs
