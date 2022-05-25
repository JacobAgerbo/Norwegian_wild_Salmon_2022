setwd("~/XLSX/")


my_files <- list.files(pattern = "*.xlsx")

df.list = lapply(my_files, function(i){
  x = read_excel(i, sheet = "abundance.databases")
  x = x[,c(2,3,4)]
  x$file = i
  x
})

do <- as.data.frame(do.call(rbind, lapply(df.list, as.vector)))
df <- cbind(my.var=rownames(do), do)
df[df == "NULL"] <- NA

# Basic box plot
df$database <- factor(df$database, levels=c("notPhiX","Unmapped","Human","Vertebrates_mammals","Vertebrates_other", "Invertebrates", "Fungi"))
df.database <- df[df$database != "notPhiX",]
df.database <- df.database[df.database$database != "Unmapped",]
df.database <- df.database[df.database$database != "Vertebrates_other",]
#
df.Vertebrate <- df[df$database == "Vertebrates_other",]
#
p1 <- ggplot(df.Vertebrate, aes(x=database, y=Percentage)) + 
  geom_boxplot(width=0.8) + theme_minimal() +
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=1)) + xlab("")

p2 <- ggplot(df.database, aes(x=database, y=Percentage)) + 
  geom_boxplot(width=0.8) + theme_minimal() +
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=1)) + xlab("") + ylab("")

#
df.read <- df[df$database == "notPhiX" | df$database == "Unmapped",]
#
library(dplyr)
library(forcats)
library(stringr)
library(wesanderson)
library(cowplot)
mean.databases = df %>%
  group_by(database) %>%
  summarize(Mean = mean(`Number of reads mapped`, na.rm=TRUE),
            Q75 = quantile(`Number of reads mapped`, na.rm=TRUE,  probs = 0.75),
            Q25 = quantile(`Number of reads mapped`, na.rm=TRUE,  probs = 0.25),
            SD = sd(`Number of reads mapped`, na.rm=TRUE))


#
Unmapped.q75 = mean.databases$Q75[mean.databases$database == "Unmapped"]
Unmapped.mean = mean.databases$Mean[mean.databases$database == "Unmapped"]
Unmapped.q25 = mean.databases$Q25[mean.databases$database == "Unmapped"]
#
scientific_10 <- function(x) {
  parse(text=gsub("e\\+*", " %*% 10^", 
                  scales::scientific_format()(x))) }
#
p3 <- df.read %>%
  mutate(name = file %>% str_replace(".xlsx", "")) %>%
  mutate(name = fct_reorder(name, desc(`Number of reads mapped`))) %>%
  ggplot( aes(x=name, y=`Number of reads mapped`, fill=database)) +
  geom_bar(stat="identity", position=position_dodge(), alpha = 0.95, width = 0.75 ) +
  scale_fill_manual(values=wes_palette("Rushmore1")[4:5]) +
  scale_color_manual(values=wes_palette("Rushmore1")[4:5]) +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  geom_hline(yintercept=Unmapped.q75, linetype="dotdash", color = "darkgrey") +
  geom_hline(yintercept=Unmapped.mean, linetype="dashed", color = "black") +
  geom_hline(yintercept=Unmapped.q25, linetype="dotdash", color = "darkgrey") +
  scale_y_continuous(label=scientific_10)


plot1 <- plot_grid(p1, p2, nrow = 1, rel_widths = c(1, 3))
plot1 <- plot_grid(plot1,p3, ncol = 1, labels = "AUTO")
plot1

## Make some pie plots
df.list = lapply(my_files, function(i){
  x = read_excel(i, sheet = "positive.species.Invertebrates")
  x = x[,c("Reads","Genus")]
  x$file = i
  x
})

do <- as.data.frame(do.call(rbind, lapply(df.list, as.vector)))
df <- cbind(my.var=rownames(do), do)
df[df == "NULL"] <- NA



