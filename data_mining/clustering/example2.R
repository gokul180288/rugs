##Time-stamp: <2015-08-04 Teckpor>
##Example data sets inspired by:
##http://stats.stackexchange.com/questions/79741/data-sets-suitable-for-k-means
library(ggplot2)

set.seed(2)
n <- 800
n3 <- 3*n
fConst <- 0.25
fConstNoise <- 1.8
fDisplacement <- 1.2

#Generation of data (1st group)
vecRho <- sqrt(runif(n))
vecTheta <- runif(n, 0, 2*pi)
vecXNoise <- fConstNoise*rnorm(n)
vecYNoise <- fConstNoise*rnorm(n)
matGroup1 <- cbind(fConst*(vecRho*cos(vecTheta) + vecXNoise), fConst*(vecRho*sin(vecTheta) + vecYNoise))

#Generation of data (2nd group)
vecRho <- sqrt(runif(n))
vecTheta <- runif(n, 0, 2*pi)
matGroup2 <- cbind(fConst*vecRho*cos(vecTheta) - fDisplacement, fConst*vecRho*sin(vecTheta) - fDisplacement)

#Generation of data (3rd group)
vecRho <- sqrt(runif(n))
vecTheta <- runif(n, 0, 2*pi)
matGroup3 <- cbind(fConst*vecRho*cos(vecTheta) + fDisplacement, fConst*vecRho*sin(vecTheta) - fDisplacement)

matGroups <- rbind(matGroup1, matGroup2, matGroup3)
#Actual code to cluster data
listKmeans <- kmeans(matGroups, centers = 3, algorithm = "Lloyd")

vecColour <- factor(c(rep(0, n3), listKmeans$cluster))
levels(vecColour) <- c("#222222", "#1b9e77", "#d95f02", "#7570b3")

vecPanel <- factor(c(rep(1, n3), rep(2, n3)))
levels(vecPanel) <- c("Original Data", "Clustering Results")

dfPlot <- data.frame(x = c(matGroups[, 1], matGroups[, 1]), y = c(matGroups[, 2], matGroups[, 2]), colour = vecColour, panel = vecPanel)
#Plot generation using ggplot2
plotOut <- ggplot(dfPlot, aes(x, y, colour = colour)) +
  geom_point() +
  scale_colour_manual(values = c("#222222", "#1b9e77", "#d95f02", "#7570b3"), name = "Legend", labels = c("Data", "Cluster 1", "Cluster 2", "Cluster 3")) +
  labs(x = "x", y = "y", shape = "", colour = "Legend") +
  theme_bw() +
  facet_grid(panel ~ .) +
  ggtitle("Example 2")
print(plotOut)
ggsave(filename = "example2.pdf", plot = plotOut, width = 11.2, height = 7.77, units = "in")
