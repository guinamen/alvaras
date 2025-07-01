library(DBI)
library(tidyverse)
library(hash)

SECTION_QUERY = 'select ano_mes, alvara, group_concat(distinct secao) as divisoes from
          (select DISTINCT alvara.ano_mes ,atividade.alvara, divisao.secao from atividade
             INNER JOIN divisao on substr(atividade, 1 ,2) = divisao.codigo
             INNER join alvara on alvara.codigo = atividade.alvara)
         group by ano_mes, alvara'

DIVISION_QUERY = 'select ano_mes, alvara, group_concat(distinct codigo) as divisoes from
          (select DISTINCT alvara.ano_mes ,atividade.alvara, divisao.codigo from atividade
             INNER JOIN divisao on substr(atividade, 1 ,2) = divisao.codigo
             INNER join alvara on alvara.codigo = atividade.alvara)
         group by ano_mes, alvara'

GROUP_QUERY = 'select ano_mes, alvara, group_concat(distinct codigo) as divisoes from
          (select DISTINCT alvara.ano_mes ,atividade.alvara, grupo.codigo from atividade
             INNER JOIN grupo on substr(atividade, 1 ,3) = grupo.codigo
             INNER join alvara on alvara.codigo = atividade.alvara)
         group by ano_mes, alvara'

CLASS_QUERY = 'select ano_mes, alvara, group_concat(distinct codigo) as divisoes from
          (select DISTINCT alvara.ano_mes ,atividade.alvara, classe.codigo from atividade
             INNER JOIN classe on substr(atividade, 1 ,5) = classe.codigo
             INNER join alvara on alvara.codigo = atividade.alvara)
         group by ano_mes, alvara'

load_data <- function(banco="database.db", query=SECTION_QUERY) {
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dt <-as_tibble(
    dbGetQuery(mydb,query)
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


save_graph <- function(dataset, banco="database.db", table="grafo_secao") {
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dbSendQuery(mydb, paste('INSERT INTO', table, '(ano_mes, atividade_a, atividade_b, total) VALUES (:ano_mes, :atividade_a, :atividade_b, :total);'), dataset)
  dbDisconnect(mydb)
  
}

find_index_leq <- function(vec, x) {
  idx <- which(vec <= x)
  if (length(idx) == 0) return(NA_integer_)  # nenhum valor <= x
  return(max(idx))
}

save_graph_file <- function(banco="database.db", arquivo="freq_subgraph.txt", table_group="agrupamento_classe", table_graph='grafo_classe') {
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dados <-as_tibble(
    dbGetQuery(
      mydb,
      paste('select * from',table_graph)
    )
  )
  clusters <-as_tibble(
    dbGetQuery(
      mydb,
      paste('select min from', table_group)
    ) %>% pull(min)
  )

  dbDisconnect(mydb)
  dados$atividade_a <- factor(dados$atividade_a,levels = c('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U'))
  dados$atividade_b <- factor(dados$atividade_b,levels = c('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U'))
  dados$atividade_a <- as.numeric(dados$atividade_a)
  dados$atividade_b <- as.numeric(dados$atividade_b)
  anos = sort(unique(dados %>% pull(ano_mes)))
  vertice_id = 0
  linhas = c()
  for (i in 1:length(anos)) {
    linhas = append(linhas, paste0("t # ", as.character(i-1)))
    vertices = unique(
      c(
        dados %>%
          filter(ano_mes==anos[i]) %>%
          pull(atividade_a),
        dados %>%
          filter(ano_mes==anos[i]) %>%
          pull(atividade_b)))
    vertices_ids <- hash()
    for (vertice in vertices) {
      linhas = append(linhas, paste0("v ", vertice_id, " ",vertice))
      vertices_ids[[as.character(vertice)]] <- vertice_id
      vertice_id = vertice_id + 1
    }
    g = dados %>% filter(ano_mes == anos[i])
    for (j in 1:(dim(g)[1])) {
      a = vertices_ids[[as.character(g[[j,'atividade_a']])]]
      b = vertices_ids[[as.character(g[[j,'atividade_b']])]]
      if (is.na(a) | is.na(b)) {
        print("a")
      }
      n = find_index_leq(clusters,g[[j,'total']])
      linhas = append(linhas, paste0("e ", a, " ",b, " ", n))
    }
    linhas = append(linhas, "")
  }
  fileConn<-file(arquivo)
  writeLines(linhas, fileConn)
  close(fileConn)
}

