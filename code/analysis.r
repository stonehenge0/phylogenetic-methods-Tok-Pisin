#Set the working directory to the directory of the file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Library for cluster analysis
library(cluster)
library(stringdist)
library(gplots)

#Load the data from the merged data file
data <- read.csv("../data/merged_data_4_clean.csv")
View(data)

#Set the rownames to be the English equivalents
rownames(data) <- data$English
View(data)

#Remove English from the rows that are analyzed
#data <- data[,c("Bislama", "Pijin", "Tok.Pisin", "Torres.Creole")]
#View(data)

#Transpose the data
#data.transposed <- data.frame(t(data))
#View(data.transposed)
#colnames(data.transposed)

#Calculate the Levenshtein distance for all languages
distances <- stringdistmatrix(data, data, method = "lv")
rownames(distances) <- names(data)
colnames(distances) <- names(data)
View(distances)

#Cluster the languages based on the distance matrix
distances <- as.dist(distances)
cluster <- hclust(distances,method="complete")
plot(cluster)

heatmap(as.matrix(distances),
          Rowv = as.dendrogram(cluster),  # Row clustering
          Colv = as.dendrogram(cluster),  # Column clustering
          trace = "none",            # No trace lines inside the heatmap
          dendrogram = "both",        # Add dendrograms to both axes
          margins = c(10, 10),        # Margins for axis labels
          labRow = names(data),    # Row labels (vocabulary)
          labCol = names(data),    # Column labels (vocabulary)
          main = "Heatmap of Levenshtein Distances with Clustering")
