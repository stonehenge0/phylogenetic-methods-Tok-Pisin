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

#Transpose data for distance calculation
grammar_data.transposed <- data.frame(t(grammar_data))
View(grammar_data.transposed)

#Calculate distances and cluster the results
grammar_distances <- daisy(grammar_data.transposed, metric = "gower",type = list(symm = c(1:5)))
grammar_cluster <- hclust(grammar_distances,method="complete")
plot(grammar_cluster)

heatmap(as.matrix(grammar_distances),
        Rowv = as.dendrogram(grammar_cluster),  # Row clustering
        Colv = as.dendrogram(grammar_cluster),  # Column clustering
        trace = "none",            # No trace lines inside the heatmap
        dendrogram = "both",        # Add dendrograms to both axes
        margins = c(10, 10),        # Margins for axis labels
        labRow = names(grammar_data),    # Row labels (grammar)
        labCol = names(grammar_data),    # Column labels (grammar)
        main = "Heatmap of Levenshtein Distances with Clustering")

### Manual calculation of the Levenshtein distance using the uncleaned data and loops
vocab_data_uc <- read.csv("../data/merged_data_4.csv")

#Set the rownames to be the English equivalents
rownames(vocab_data_uc) <- vocab_data_uc$English
View(vocab_data_uc)
library(data.table)

#Loop through all rows of the data manually
total_distance_matrix <- matrix(0, 5, 5)
for (x in 1:nrow(vocab_data_uc)) {
#for (x in 12:12) {
  row = vocab_data_uc[x,]
  #Loop through all entries in a line manually
  current_row_vocab <- c()
  for (l in 1:ncol(row)) {
    #Split up the entries separated by the '/' symbol
    strings <- strsplit(row[,l], split='/', fixed = TRUE)
    current_row_vocab <- append(current_row_vocab, strings)
  }
  #Replace all empty entries with empty strings to avoid self destruction of program
  current_row_vocab[lengths(current_row_vocab) == 0] <- ""
  #Expand the data frame to contain all possible combinations
  frame <- expand.grid(current_row_vocab)
  #Placeholder variables for finding the smallest distance matrix
  smallest_distance_matrix <- c()
  smallest_sum <- 1000
  #Calculating the distance matrix for all data combinations
  for (d in 1:nrow(frame)) {
    local_row <- unlist(frame[d,], use.names=FALSE)
    local_distances <- stringdistmatrix(local_row, local_row, method = "lv")
    #If the new distance matrix is smaller than the previous one, update it
    if (sum(local_distances) <= smallest_sum) {
      smallest_sum <- sum(local_distances)
      smallest_distance_matrix <- local_distances
    }
  }
  #Adding the current distances to the kumulative total distance matrix
  total_distance_matrix <- total_distance_matrix + smallest_distance_matrix
}
#Preparing the total distance matrix to be viewed
rownames(total_distance_matrix) <- names(vocab_data_uc)
colnames(total_distance_matrix) <- names(vocab_data_uc)
View(total_distance_matrix)

