library(DBI)
library(tidyverse)
library(igraph)
library(ggplot2)
library(pracma)


l = factor(c("2021-01-02",
      "2021-03-04",
      "2021-05-06",
      "2021-07-08",
      "2021-09-10",
      "2021-11-12",
      "2022-01-02",
      "2022-03-04",
      "2022-05-06",
      "2022-07-08",
      "2022-09-10",
      "2022-11-12",
      "2023-01-02",
      "2023-03-04",
      "2023-05-06",
      "2023-07-08",
      "2023-09-10",
      "2023-11-12",
      "2024-01-02",
      "2024-03-04",
      "2024-05-06",
      "2024-07-08",
      "2024-09-10",
      "2024-11-12",
      "2025-01-02",
      "2025-03-04",
      "2025-05-06"), ordered = TRUE)

SECTION_QUERY = 'SELECT
        ano_mes,
        unicode(atividade_a)-63 as no1,
        unicode(atividade_b)-63 as no2,
        total from grafo_secao_bimestre'

load_data <- function(banco="database.db", query = SECTION_QUERY) {
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dt <-as_tibble(
    dbGetQuery(
      mydb,
      query
    )
  )
  dbDisconnect(mydb)
  return(dt)
}

load_graph <-function(data) {
  graphs <- list()
  year_months <- sort(unique(data %>% pull(ano_mes)))
  for (i in 1:length(year_months)) {
    year_month = year_months[i]
    graph_data <- data %>%
      filter(ano_mes==year_month) %>%
      select(no1,no2)
    graphs[[i]] <- make_graph(
      edges = as.vector(
        apply(graph_data,
              1,
              function(row) c(row[[1]],row[[2]]))),
      directed = FALSE)
    graphs[[i]] <- delete_vertices(graphs[[i]], which(degree(graphs[[i]])==0))
  }
  names(graphs) <- year_months
  return(graphs)
}

assortativity_graph <- function(lambda = 1600, d = 2) {
  graph_df <- tibble(x = l, y= sapply(load_graph(load_data()), function(g) { assortativity_degree(g, directed = FALSE)}))
  graph_df$smooth <- whittaker(graph_df$y,lambda = lambda, d = d)
  p <- graph_df %>%
    ggplot(aes(x=x,y=y)) +
    geom_point(shape = 4, size = 3) +
    geom_line(linetype="dotted", group=1) +
    xlab(NULL) + 
    ylab("Assortativity") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  return(p)
}

topologgy_graph <- function(lambda = 1600, d = 2) {
  graph_df <- tibble(x = l, y= c(6.783804  , 0.5564224 , 5.2426314 , 9.463509  , 1.1814182 ,
                                     7.7811723 , 8.706693  , 9.844009  , 3.5528314 , 6.368406  ,
                                     7.125939  , 1.8042295 , 8.207121  , 8.984817  , 5.733421  ,
                                     1.5861781 , 7.4313054 , 2.1586685 , 1.4198954 , 9.587272  ,
                                     0.38229093, 6.021061  , 1.03722   , 8.532234  , 7.998845  ,
                                     9.1163645 , 0.8344608))
  graph_df$smooth <- whittaker(graph_df$y,lambda = lambda, d = d)
  p <- graph_df %>%
    ggplot(aes(x=x,y=y)) +
    geom_point(shape = 4, size = 3) +
    geom_line(linetype="dotted", group=1) +
    xlab(NULL) + 
    ylab("1D Embedding Space") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  return(p)
}

ggsave("assortativity.pdf", plot = assortativity_graph())
ggsave("time_struct.pdf", plot = topologgy_graph())
