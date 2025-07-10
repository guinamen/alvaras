library(DBI)
library(tidyverse)
library(igraph)

SECTION_QUERY = 'SELECT
        ano_mes,
        unicode(atividade_a)-63 as no1,
        unicode(atividade_b)-63 as no2,
        total from grafo_secao'

SECTION_QUERY_2_MONTH = 'SELECT
        ano_mes,
        unicode(atividade_a)-63 as no1,
        unicode(atividade_b)-63 as no2,
        total from grafo_secao_bimestre'

SECTION_QUERY_3_MONTH = 'SELECT
        ano_mes,
        unicode(atividade_a)-63 as no1,
        unicode(atividade_b)-63 as no2,
        total from grafo_secao_trimestre'

SECTION_QUERY_4_MONTH = 'SELECT
        ano_mes,
        unicode(atividade_a)-63 as no1,
        unicode(atividade_b)-63 as no2,
        total from grafo_secao_quadrimestre'

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

graph_metrics <- function(g) {
  deg <- mean(degree(g))
  path <- mean_distance(g, directed = FALSE)
  assort <- assortativity_degree(g, directed = FALSE)
  tr <- transitivity(g, type = "average")
  return(c(degree=deg, path=path, assortativity=assort, transitivity=tr))
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

  r1_wilcox <- sapply(c("transitivity","path","assortativity"), function(x) {
    wilcox.test(
      summary_graphs[x,],
      summary_of_random_graphs[x,,] %>% as.vector(),
      alternative = "two.sided"
    )$p.value
  })
  
  r2_wilcox <- sapply(c("transitivity","path","assortativity"), function(x) {
    wilcox.test(
      summary_graphs[x,],
      summary_of_random_graphs2[x,,] %>% as.vector(),
      alternative = "two.sided"
    )$p.value
  })
  table <- as.data.frame(rbind( r1_wilcox,r2_wilcox))
  table$Model = c("Erdos-Renyi", "Random Graph")
  table <- table[,c(4,1,2,3)]
  colnames(table) <- c("Random Graph Model", "Transitivity", "Shortest Path", "Assortativity")
  rownames(table) <- NULL
  return(table)
}

realize_experiment <- function (method = "bonferroni") {
  section = test_groups_clustres()
  section_2_month = test_groups_clustres(SECTION_QUERY_2_MONTH)
  section_3_month = test_groups_clustres(SECTION_QUERY_3_MONTH)
  section_4_month = test_groups_clustres(SECTION_QUERY_4_MONTH)
  
  division = test_groups_clustres(DIVISION_QUERY)
  group = test_groups_clustres(GROUP_QUERY)
  class = test_groups_clustres(CLASS_QUERY)
  
  all_data <- bind_rows(
    mutate(section, Grouping = "1 Month"),
    mutate(section_2_month, Grouping = "2 Month"),
    mutate(section_3_month, Grouping = "3 Month"),
    mutate(section_4_month, Grouping = "4 Month"),
    mutate(division, Grouping = "Division"),
    mutate(group, Grouping = "Group"),
    mutate(class, Grouping = "Class")
  )
  all_data <- all_data[,c(5,1,2,3,4)]
  all_data[,c(3,4,5)] <- matrix(
    p.adjust(
      as.vector(
        as.matrix(
          all_data[,c(3,4,5)])), method = method),
    nrow=7*2, ncol=3)
  return(all_data)
}
x <- realize_experiment()
x$Transitivity <- formatC(x$Transitivity, format = "e", digits = 2)
x$`Shortest Path` <- formatC(x$`Shortest Path`, format = "e", digits = 2)
x$Assortativity <- formatC(x$Assortativity, format = "e", digits = 2)
print(x)
