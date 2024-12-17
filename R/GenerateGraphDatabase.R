library(DBI)
library(tidyverse)
library(hash)

load_data <- function(banco="../data/database.db") {
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dt <-as_tibble(
    dbGetQuery(
      mydb,
      'select ano_mes, alvara, group_concat(distinct secao) as divisoes from
          (select DISTINCT alvara.ano_mes ,atividade.alvara, divisao.secao from atividade
             INNER JOIN divisao on substr(atividade, 1 ,2) = divisao.codigo
             INNER join alvara on alvara.codigo = atividade.alvara)
         group by ano_mes, alvara'
    )
  )
  dbDisconnect(mydb)
  return(dt)
}

generate_graph <- function(dados) {
  grafo = data.frame()
  tamanho = dim(dados)[1]
  for (i in 1:tamanho) {
    atividades = sort(unique(strsplit(dados[[i,'divisoes']], ',', fixed=T)[[1]]))
    carga = dados[[i, 'ano_mes']]
    if(length(atividades) > 1) {
      combinacoes = t(combn(atividades, 2))
      carga_col = rep(carga, dim(combinacoes)[1])
      combinacoes = cbind(carga_col, combinacoes)
      colnames(combinacoes) <- c('ano_mes','atividade_a','atividade_b')
      grafo = rbind(grafo, combinacoes)
    } else {
      grafo = rbind(
        grafo,
        data.frame(ano_mes = carga,
                   atividade_a=atividades[1], atividade_b=atividades[1]))
    }
  }
  return(as_tibble(grafo))
}


save_graph <- function(dataset, banco="../dynamic_graph/graph.db") {
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dbSendQuery(mydb, 'INSERT INTO secao (ano_mes, no1, no2, total) VALUES (:ano_mes, :atividade_a, :atividade_b, :total);', dataset)
  dbDisconnect(mydb)
  
}

save_graph_file <- function(banco="../dynamic_graph/graph.db", arquivo="../freq_subgraph/graphs.txt") {
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dados <-as_tibble(
    dbGetQuery(
      mydb,
      'select * from secao'
    )
  )
  dbDisconnect(mydb)
  dados$no1 <- factor(dados$no1,levels = c('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U'))
  dados$no2 <- factor(dados$no2,levels = c('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U'))
  dados$no1 <- as.numeric(dados$no1)
  dados$no2 <- as.numeric(dados$no2)
  anos = sort(unique(dados %>% pull(ano_mes)))
  vertice_id = 0
  linhas = c()
  for (i in 1:length(anos)) {
    linhas = append(linhas, paste0("t # ", as.character(i-1)))
    vertices = unique(
      c(
        dados %>%
          filter(ano_mes==anos[i]) %>%
          pull(no1),
        dados %>%
          filter(ano_mes==anos[i]) %>%
          pull(no2)))
    vertices_ids <- hash()
    for (vertice in vertices) {
      linhas = append(linhas, paste0("v ", vertice_id, " ",vertice))
      vertices_ids[[as.character(vertice)]] <- vertice_id
      vertice_id = vertice_id + 1
    }
    g = dados %>% filter(ano_mes == anos[i])
    for (j in 1:(dim(g)[1])) {
      a = vertices_ids[[as.character(g[[j,'no1']])]]
      b = vertices_ids[[as.character(g[[j,'no2']])]]
      if (is.na(a) | is.na(b)) {
        print("a")
      }
      if (g[[j,'total']] < 5)
        n = 0
      else if (g[[j,'total']] < 15)
        n = 1
      else
        n = 2
      linhas = append(linhas, paste0("e ", a, " ",b, " ", n))
    }
    linhas = append(linhas, "")
  }
  fileConn<-file(arquivo)
  writeLines(linhas, fileConn)
  close(fileConn)
}

