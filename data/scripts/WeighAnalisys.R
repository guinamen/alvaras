library(DBI)
library(tidyverse)
library(hash)

GAPH_TABLE="grafo_divisao"
GRUPPING_TABLE="agrupamento"

load_data <- function(banco="database.db", table=GAPH_TABLE) {
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dt <-as_tibble(
    dbGetQuery(
      mydb,
      paste('select total from',table)
    )
  )
  dbDisconnect(mydb)
  return(dt)
}

elboow <- function(totals, max_k=15, nstart=50,iter.max = 15 ) {
  scaled_data = as.vector(scale(totals %>% pull(total)))                  
  data <- scaled_data
  # Step 1: Compute WSS for k = 1 to max_k
  wss <- sapply(1:max_k,
    function(k){kmeans(data, k, nstart=nstart, iter.max = iter.max )$tot.withinss})

  # Step 2: Create a line from point 1 to point max_k
  k_vals <- 1:max_k
  line <- cbind(c(1, max_k), c(wss[1], wss[max_k]))

  # Function to compute perpendicular distance from point to line
  distance_point_to_line <- function(x0, y0, x1, y1, x2, y2) {
    abs((y2 - y1)*x0 - (x2 - x1)*y0 + x2*y1 - y2*x1) /
      sqrt((y2 - y1)^2 + (x2 - x1)^2)
  }

  # Step 3: Compute distances to the baseline
  distances <- sapply(1:max_k, function(i) {
    distance_point_to_line(k_vals[i], wss[i],
                           line[1,1], line[1,2],
                           line[2,1], line[2,2])
  })

  # Step 4: Find the index of the maximum distance
  elbow_k <- which.max(distances)

  clusters <- kmeans(scaled_data, elbow_k, nstart=nstart, iter.max = iter.max)$cluster
  totals$cluster = clusters

  return(totals)
}

save_clusters <- function(banco="database.db", table=GRUPPING_TABLE) {
  dataset <- elboow(load_data()) %>% group_by(cluster) %>% summarise(min=min(total), max=max(total)) %>% arrange(min) %>% select(min,max)
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dbSendQuery(mydb, paste('INSERT INTO',table, '(min, max) VALUES (:min, :max);'), dataset)
  dbDisconnect(mydb)
  
}

