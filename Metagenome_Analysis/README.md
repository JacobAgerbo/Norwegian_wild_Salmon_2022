# Hologenomics reveal co-evolution of an intestinal Mycoplasma and its salmonid host
This Github repository includes the analytical framework to generate results that are reported in Rasmunssen et al. 2022 (unpublished) and are central to its main claims.

**Analytical Background**
For analysis of the metagenome we carried several analysis and though we spent quite some time on this,
these datasets are just huge and there is always another thing to be analysed around the corner.
Therefore i have made a small bullet list with the overall stuff we have done, but please reach out if you have any questions.

• We started by making rarefaction-curves to evaluate the sequencing depth
• We estimated the bacterial comprehensiveness of our metagenome, using SCGs for bacteria, protista, and archaea
• Prior our analysis of MAGs, we normalised coverage of MAGs based on sum of coverage (sequencing depth) and genome length, basically like [TMP normalisation](https://www.rna-seqblog.com/rpkm-fpkm-and-tpm-clearly-explained/)
• Read recruitment of MAGs were used for following classical ecological measurements for diversity, like:
    - Richness, using Hill diversity (quite a nice and transparent framework - compared to Shannon and Simpson)
    - Composition, PCoA with weigthed UniFrac.


## Bioinformatics
• All underlying repositories includes a walk through of bioinformatic code and descriptions to increase reproducibility

## Analysis
• All underlying repositories includes datasets needed for result generation and a respective R markdown file.
