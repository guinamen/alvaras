library(DBI)
library(tidyverse)
library(igraph)

SECTION_QUERY = 'SELECT
        ano_mes,
        unicode(atividade_a)-63 as no1,
        unicode(atividade_b)-63 as no2,
        total from grafo_secao'

DIVISION_QUERY = 'select ano_mes, dv1.id as no1, dv2.id as no2, total
        from grafo_divisao
        inner JOIN divisao as dv1 on dv1.codigo = atividade_a
        INNER join divisao as dv2 on dv2.codigo = atividade_b'

GROUP_QUERY='select ano_mes, dv1.id as no1, dv2.id as no2, total
        from grafo_grupo
        inner JOIN grupo as dv1 on dv1.codigo = atividade_a
        INNER join grupo as dv2 on dv2.codigo = atividade_b'

CLASS_QUERY='select ano_mes, dv1.id as no1, dv2.id as no2, total
        from grafo_classe
        inner JOIN classe as dv1 on dv1.codigo = atividade_a
        INNER join classe as dv2 on dv2.codigo = atividade_b'

load_data <- function(banco="/home/guilherme/Repo/alvaras/data/database.db", query = SECTION_QUERY) {
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
  year_months <-  sort(unique(load_data() %>% pull(ano_mes)))
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

graph_metrics <- function(g) {
  deg <- mean(degree(g))
  clust <- transitivity(g, type = "average")
  path <- mean_distance(g, directed = FALSE)
  assort <- assortativity_degree(g, directed = FALSE)
  tr <- transitivity(g, type = "average")
  return(c(degree=deg, cluster=clust, path=path, assortativity=assort, transitivity=tr))
}

generate_random_graphs <- function(graphs, n=100) {
  random_graphs <- replicate(
    n=n,
    expr = sapply(
      lapply(
        graphs,
        function(x) sample_gnm(vcount(x), ecount(x), directed = FALSE)),
      graph_metrics))
  return(random_graphs)
}

generate_randomized_sequence <- function(graphs, n=100) {
  random_graphs <- replicate(
    n=n,
    expr = sapply(
      lapply(graphs, function(g) {
        degree_seq <- degree(g)
        sample_degseq(degree_seq) # modelo de configuração
      }),
      graph_metrics))
  return(random_graphs)
}

test_groups_clustres <- function (query=SECTION_QUERY) {

  list_of_graphs <- load_graph(load_data(query=query))
  summary_graphs <- sapply(list_of_graphs, graph_metrics)
  
  summary_of_random_graphs <- generate_random_graphs(list_of_graphs)
  summary_of_random_graphs2 <- generate_randomized_sequence(list_of_graphs)

  r1_wilcox <- sapply(c("cluster","transitivity","path","assortativity"), function(x) {
    wilcox.test(
      summary_graphs[x,],
      summary_of_random_graphs[x,,] %>% as.vector(),
      alternative = "two.sided"
    )$p.value
  })
  
  r2_wilcox <- sapply(c("cluster","transitivity","path","assortativity"), function(x) {
    wilcox.test(
      summary_graphs[x,],
      summary_of_random_graphs2[x,,] %>% as.vector(),
      alternative = "two.sided"
    )$p.value
  })
  return(rbind(r1_wilcox,r2_wilcox))
}

section = test_groups_clustres()
division = test_groups_clustres(DIVISION_QUERY)
group = test_groups_clustres(GROUP_QUERY)
class = test_groups_clustres(CLASS_QUERY)