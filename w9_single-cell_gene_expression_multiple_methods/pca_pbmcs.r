# The first step to take in RStudio is to load and transform your data.
# Be sure to download the raw data file, and set your working directory
# appropriately before you enter the following code.

A_table = read.table("pbmcs.txt", header=TRUE, row.names =1, sep = "", dec = ".")

#convert the dataframe into a matrix
A_matrix = as.matrix(A_table)

#transform the data
A_log = log(A_matrix+1)


# Now that the normalized data are transformed, you can run a PCA on them.
# Note that in R there are additional arguments in the prcomp() function,
# however, you will omit those arguments and return the rotated variables
#with the following command.

A_pc = prcomp(A_log, retx = T)

# This line of code returns an prcomp object A_pc that contains a vector
# of the standard deviations of the principal components (sdev), the matrix
# of the variable loadings (rotation), and the coordinates of the observations
# on the principal components (x).

str(A_pc) # list of 5 with $x, $sdev, $rotation, $center and $scale

dim(A_pc$rotation)

# A_pc contains (among other things) a vector of all the standard deviations
# of the principal components, so it follows that the length of this vector
# is equal to the number of the principal components. Running length(A_pc$sdev)
# returns 1838, the number of principal components.

# Let's calculate the amount of variance each principal component explains.
# You can compute the variance by using the standard deviation given for each
# principal component as part of the output of the analysis by the following code:

pr_var = (A_pc$sdev)^2
percent_varex = pr_var/sum(pr_var)*100

# percent variation explained by the first principal component?
percent_varex[1]

# percent variation explained by the last principal component?
percent_varex[length(percent_varex)]


# Next, you are going to visualize the outputs of the two dimensionality
# reduction techniques covered earlier. Start by plotting the first two
# principal components
plot(A_pc$x[,1], A_pc$x[,2], pch="*")

# And then install `install.packages("Rtsne")`, run, and visualize the output
# of the t-SNE method. This will take a little bit of time to run. Note that
# you are suppressing an argument to first run a PCA before the t-SNE method
is employed, since you will use the first 50 principal components computed
# previously as your input.

library("Rtsne")

A_tsne <- Rtsne(A_pc$x[,1:50], pca=F)
plot(A_tsne$Y, pch='*')
# When t-SNE is run multiple times the same local relationships are preserved
# on the same scale, however, the location of the observations in the reduced
# dimensions changes each time.


# Finally, run a k-means clustering method to group the observations based on
# their gene expression profiles, and visualize the output. First, define the
# output of the clustering method as the cluster assignment per cell generated
# from the first 50 principal components. Then overlay those assignments onto
# the t-SNE plot.
cluster_labels = kmeans(A_pc$x[,1:50], 6, iter.max = 10000, nstart = 1)

plot(A_tsne$Y, col=cluster_labels$cluster, pch="*")

# Even though t-SNE is non-deterministic, the code used in the k-means methods
# is only using t-SNE to visualize, the clustering method is drawing upon the
# principal components instead. Since k-means uses random centroids for each run,
# there will be different cluster assignments each time.
