#!/bin/sh
module load htslib/1.8 angsd/0.921 ngsadmix/32
NGSadmix -likes /home/projects/ku-cbd/data/jacras/3-NWS/08_Host_Genotype/ANGSD/Admix/all.beagle.gz -seed $RANDOM -outfiles /home/projects/ku-cbd/data/jacras/3-NWS/08_Host_Genotype/ANGSD/Admix/NWS.K${1}.rep${2} -K {$1} -minMaf 0.05 -minInd $((90*76/100)) -P 10
