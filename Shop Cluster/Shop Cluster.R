# Works on a pre-existing table drawn from Cooladata. 

library(devtools)
library(httr)
library(rJava)
library(cluster)
library(tibble)

z <- data[,-c(1,1)]
z[is.na(z)] <- 0
m <- apply(z,2,mean)
s <- apply(z,2,sd)
z <- scale(z,m,s)

kc <- kmeans(z,5)

users_cluster <- 
  as.data.frame.matrix(table(data$shop_name_full,kc$cluster)) 

users_cluster <-
  rownames_to_column(users_cluster, "shop_name_full")

users_cluster <-
  cbind(users_cluster[1], cluster = max.col(users_cluster[-1], 'first'))

# marge the clusters with the data we calcluate for each user
users_cluster_marge <-
  merge(users_cluster, data, by, 1, 1, sort = TRUE)


# Results must be in table format. Save your result to coolaResult:
coolaResult <- users_cluster_marge