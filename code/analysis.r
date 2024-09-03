#Set the working directory to the directory of the file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Library for cluster analysis
library(cluster)
library(stringdist)
library(gplots)

#Load the vocab data from the merged data file
vocab_data <- read.csv("../data/merged_data_4_clean.csv")

#Set the rownames to be the English equivalents
rownames(vocab_data) <- vocab_data$English
View(vocab_data)

#Calculate the Levenshtein distance for all languages
distances_matrix <- stringdistmatrix(vocab_data, vocab_data, method = "lv")
rownames(distances_matrix) <- names(vocab_data)
colnames(distances_matrix) <- names(vocab_data)
View(distances_matrix)

#Cluster the languages based on the distance matrix
vocab_distances <- as.dist(distances_matrix)
vocab_cluster <- hclust(vocab_distances,method="complete")
plot(vocab_cluster)

heatmap(as.matrix(vocab_distances),
          Rowv = as.dendrogram(vocab_cluster),  # Row clustering
          Colv = as.dendrogram(vocab_cluster),  # Column clustering
          trace = "none",            # No trace lines inside the heatmap
          dendrogram = "both",        # Add dendrograms to both axes
          margins = c(10, 10),        # Margins for axis labels
          labRow = names(vocab_data),    # Row labels (vocabulary)
          labCol = names(vocab_data),    # Column labels (vocabulary)
          main = "Heatmap of Levenshtein Distances with Clustering")

#Load the grammar data from the merged data file
grammar_data <- read.csv("../data/merged_grammar_5.csv")
rownames(grammar_data) <- grammar_data$Feature.ID
grammar_data <- grammar_data[c(3, 4, 5, 6, 7)]

grammar_data.transposed <- data.frame(t(grammar_data))
View(grammar_data.transposed)

grammar_distances <- daisy(grammar_data.transposed, metric = "gower",type = list(symm = c(1:5)))
grammar_cluster <- hclust(grammar_distances,method="complete")
plot(grammar_cluster)

heatmap(as.matrix(grammar_distances),
        Rowv = as.dendrogram(grammar_cluster),  # Row clustering
        Colv = as.dendrogram(grammar_cluster),  # Column clustering
        trace = "none",            # No trace lines inside the heatmap
        dendrogram = "both",        # Add dendrograms to both axes
        margins = c(10, 10),        # Margins for axis labels
        labRow = names(grammar_data),    # Row labels (vocabulary)
        labCol = names(grammar_data),    # Column labels (vocabulary)
        main = "Heatmap of Levenshtein Distances with Clustering")
