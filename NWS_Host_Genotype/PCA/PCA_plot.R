setwd("~/NWS_Host_Genotype/PCA")

library(ggfortify)
library(ggplot2)
library(readr)
library(readxl)
library(dplyr)
library(RColorBrewer)
library(vegan)
library(ggpubr)
library(factoextra)
library(cluster)
library(plotly)

#setwd("~/Dropbox/Arbejde/PhD/HappyFish/Writing/NWS/Host_Genotype/PCA")
#d <- as.matrix(read_excel("Myco_MAG_covMat.xlsx"))
#rownames(d) <- d[,1]
#d <- d[,-c(1)]
#class(d) <- "numeric"

d <- read.table("all.covMat")
labels <- read.table("sample_info.txt")
md <- read.table("sample_info.txt")
rownames(d) <- labels$V1
colnames(d) <- labels$V1
#md <- read_excel("Metadata.xlsx")

d <- d[match(md$V1, rownames(d)),]
d <- t(d)
d <- d[match(md$V1, rownames(d)),]
d <- t(d)

#
library(fpc)
pamk.best <- pamk(d)
cat("number of clusters estimated by optimum average silhouette width:", pamk.best$nc, "\n")
plot(pam(d, pamk.best$nc))

#
asw <- numeric(45)
for (k in 2:45){
  asw[[k]] <- pam(d, k) $ silinfo $ avg.width
}
k.best <- which.max(asw)
cat("silhouette-optimal number of clusters:", k.best, "\n")
# still 2


res.pca <- prcomp(d)
PCA.plot <- autoplot(prcomp(d), data =md, colour = 'Location', label = TRUE, size = 5) + 
  theme_classic() + 
  scale_color_brewer(palette = "Set2")

fviz_eig(res.pca)

PCA.individuals <- fviz_pca_ind(res.pca,
             col.ind = "cos2", # Color by the quality of representation
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = FALSE)     # Avoid text overlapping


NWSHC <- hclust(dist(d),method = "ward.D2")
plot(NWSHC)

NWS_cluster <- cutree(NWSHC,k=3)
names <- names(NWS_cluster)

PCA.genoGroups <- fviz_pca_ind(res.pca, label="none", habillage=NWS_cluster,
                  addEllipses=TRUE, ellipse.level=0.5)

#pdf("PCA_individuals.pdf", height = 12, width = 12)
PCA.individuals
#dev.off()

#pdf("PCA_genoGroups.pdf", height = 12, width = 12)
PCA.genoGroups
#dev.off()

Clusters <- paste("Cluster",NWS_cluster)

cluster_data <- data.frame(names,Clusters)
write_csv(x = cluster_data, "Genotype_Clusters.csv")

