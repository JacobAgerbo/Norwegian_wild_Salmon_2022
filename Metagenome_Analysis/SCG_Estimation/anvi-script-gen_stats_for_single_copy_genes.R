#!/usr/bin/env Rscript
#
# visualizes stuff..
#
setwd("~/Dropbox/Arbejde/PhD/HappyFish/Writing/NWS/Analysis/Metagenome/")
suppressPackageStartupMessages(library(gtools))
suppressPackageStartupMessages(library(gridExtra))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(optparse))

e_value <- 1
genes_df <- data.frame(read.table("CONTIGS.db.genes", header = TRUE,sep="\t"))
hits_df <- data.frame(read.table("CONTIGS.db.hits", header = TRUE,sep="\t"))
hits_df <- hits_df[hits_df$e_value < e_value, ]
sources <- unique(factor(hits_df$source))

plots <- list()  # new empty list
i <- 1
for(source in sources){
  print(source)
  source_genes_df <- genes_df[genes_df$source == source, ]
  source_genes_df$source <- factor(source_genes_df$source)
  source_genes_df$gene <- factor(source_genes_df$gene)
  
  source_df <- hits_df[hits_df$source == source, ]
  source_df$source <- factor(source_df$source)
  source_df$gene <- factor(source_df$gene)
  
  x <- data.frame(gene = character(), count = numeric(), stringsAsFactors=FALSE)
  N <- 1
  for(gene in levels(source_genes_df$gene)){
    x[N, ] <- c(gene, nrow(source_df[source_df$gene == gene, ]))
    N <- N + 1
  }
  
  x$count <- as.numeric(x$count)
  
  frequencies <- as.data.frame(table(x$count))
  names(frequencies) <- c('num', 'freq')
  frequencies <- frequencies[with(frequencies, order(-freq)), ]
  
  num_genomes <- as.character(frequencies[1, ]$num)
  percent_agrees <- frequencies[1, ]$freq * 100 / sum(frequencies$freq)
  
  text = sprintf("%s:\n%.2f%% of %d genes\noccur %s times", source, percent_agrees, nrow(x), num_genomes)
  p <- ggplot() + annotate("text", x = 1, y = 1, size=7, label = text) + theme(line = element_blank(),
                                                                               text = element_blank(),
                                                                               title = element_blank())
  attach(x)
  q <- ggplot(x, aes(x=factor(0), y=count))
  q <- q + geom_violin()
  q <- q + geom_jitter(position = position_jitter(width = .2, height = 0), alpha=0.3)
  q <- q + theme_bw()
  q <- q + theme(axis.text.x = element_blank())
  q <- q + theme(axis.text.y = element_text(size = 12))
  q <- q + theme(axis.ticks.x = element_blank())
  q <- q + coord_cartesian(ylim = c(0, ifelse (max(`count`) > 0, max(`count`), 1)))
  q <- q + labs(x='', y='')
  
  r <- ggplot(x, aes(x=reorder(gene, -count), y=as.integer(count)))
  r <- r + geom_bar(stat='identity', width=.9)
  r <- r + theme_bw()
  r <- r + expand_limits(y=0)
  r <- r + coord_cartesian(ylim = c(0, ifelse (max(`count`) > 0, max(`count`), 1)))
  r <- r + theme(axis.text.y = element_text(size = 12))
  r <- r + theme(axis.text.x = element_blank())
  r <- r + geom_text(aes(x=gene, y=ifelse (max(`count`) > 0, max(`count`) * 0.001, 0.001), hjust = 0, vjust=0.5, label=gene), angle=90, size = 2.85)
  r <- r + labs(x='', y='')
  r <- r + scale_y_sqrt()
  
  plots[[i]] <- p
  i <- i + 1
  plots[[i]] <- q
  i <- i + 1
  plots[[i]] <- r
  i <- i + 1
  detach(x)
}

pdf("Analysis/SCG_estimation.pdf", width=25, height=3)
i <- 1
for(source in sources){
  grid.arrange(plots[[i]], plots[[i+1]], plots[[i+2]], widths = c(2, 1, 10))
  i=i+3
}
dev.off()
