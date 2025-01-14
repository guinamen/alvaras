library(DBI)
library(tidyverse)
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

load_attributes <- function(banco="../data/database.db") {
    mydb <- dbConnect(RSQLite::SQLite(), banco)
    dt <-as_tibble(
      dbGetQuery(
        mydb,
        'select ano_mes, regional, secao, count(*) as total
          from atividade
            INNER join alvara on atividade.alvara = alvara.codigo
            INNER JOIN divisao on substr(atividade, 1 ,2) = divisao.codigo
        group by ano_mes, regional, secao'
      )
    )
    dbDisconnect(mydb)
    dt$id = sapply(dt$secao, utf8ToInt)-utf8ToInt('A')
    return(dt)
}

load_attributes_area <- function(banco="../data/database.db") {
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dt <-as_tibble(
    dbGetQuery(
      mydb,
      'select ano_mes, regional, secao, sum(area) as total
          from atividade
            INNER join alvara on atividade.alvara = alvara.codigo
            INNER JOIN divisao on substr(atividade, 1 ,2) = divisao.codigo
        group by ano_mes, regional, secao'
    )
  )
  dbDisconnect(mydb)
  dt$id = sapply(dt$secao, utf8ToInt)-utf8ToInt('A')
  return(dt)
}

load_attributes_most_common <- function(banco="../data/database.db") {
  mydb <- dbConnect(RSQLite::SQLite(), banco)
  dt <-as_tibble(
    dbGetQuery(
      mydb,
      'select alvara, ano_mes, regional, atividade, secao 
      from atividade INNER join alvara on atividade.alvara = alvara.codigo
            INNER JOIN divisao on substr(atividade, 1 ,2) = divisao.codigo'
    )
  )
  dbDisconnect(mydb)
  dt = dt %>% group_by(alvara, ano_mes, regional, secao) %>%
          slice(which.max(n())) %>%
          ungroup() %>%
          group_by(ano_mes, regional, secao) %>%
          summarise(total=n(),.groups = 'drop')
  dt$id = sapply(dt$secao, utf8ToInt)-utf8ToInt('A')
  return(dt)
}

is_duplicate <- function(x, seen) {
  pair <- paste(x[1], x[2], sep = ",")
  reverse_pair <- paste(x[2], x[1], sep = ",")
  if (pair %in% seen || reverse_pair %in% seen) {
    return(TRUE)
  }
  return(FALSE)
}

simetric_filter <- function(dados) {
  seen <- c()
  
  # Aplicar a lógica de filtro
  filtered_df <- dados[!apply(dados, 1, function(row) {
    duplicate <- is_duplicate(row, seen)
    seen <<- c(seen, paste(row, collapse = ","))
    return(duplicate)
  }), ]
  return(filtered_df)
}

write_graph <- function(dados) {
  anos = sort(unique(dados %>% pull(ano_mes)))
  linhas = c()
  for (i in 1:length(anos)) {
    linhas = append(linhas, paste0("T", as.character(i-1)))
    g = dados %>% 
      filter(ano_mes == anos[i]) %>%
      distinct(atividade_a, atividade_b, .keep_all = TRUE)
    g = simetric_filter(g %>% select(atividade_a, atividade_b))
    g$atividade_a = as.character(sapply(g$atividade_a , utf8ToInt) - utf8ToInt('A'))
    g$atividade_b = as.character(sapply(g$atividade_b , utf8ToInt) - utf8ToInt('A'))
    g = aggregate(atividade_b~atividade_a, data = g, paste0, collapse=" ")
    linhas = append(
      linhas,
      paste(g$atividade_a, g$atividade_b, sep = " "))
    
  }
  fileConn<-file("../dynamic_graph/TSeqMiner/graph.txt")
  writeLines(linhas, fileConn)
  close(fileConn)
}

write_attributes <- function(dados, file="../dynamic_graph/TSeqMiner/attributes.txt") {
  anos = sort(unique(dados %>% pull(ano_mes)))
  linhas = c()
  for (i in 1:length(anos)) {
    linhas = append(linhas, paste0("T", as.character(i-1)))
    g = dados %>% filter(ano_mes == anos[i]) %>% spread(key = regional, value = total, fill =0)
    if (! "NORTE" %in% colnames(g)) {
      g = g %>% mutate(NORTE = 0)
    }
    g = g %>%
      select(id,
             BARREIRO,
             `CENTRO-SUL`,
             LESTE,
             NORDESTE,
             NOROESTE,
             NORTE,
             OESTE,
             PAMPULHA,
             `VENDA NOVA`) %>%
      complete(
        id = 0:20,
        fill = list(
          BARREIRO=0,
          `CENTRO-SUL`=0,
          LESTE=0,
          NORDESTE=0,
          NOROESTE=0,
          NORTE=0,
          OESTE=0,
          PAMPULHA=0,
          `VENDA NOVA`=0))
    g$ANEL1 = g$LESTE + g$NOROESTE + g$OESTE
    g$ANEL2 = g$BARREIRO + g$PAMPULHA +g$NORDESTE + g$`VENDA NOVA` +g$NORTE
    linhas = append(
      linhas,
      paste(
        g$id,
        g$ANEL1,
        g$ANEL2,
        g$'CENTRO-SUL',
        #g$BARREIRO,
        #g$LESTE,
        #g$NORDESTE,
        #g$NOROESTE,
        #g$NORTE,
        #g$OESTE,
        #g$PAMPULHA,
        #g$'VENDA NOVA',
        
        sep = " "))
  }
  fileConn<-file(file)
  writeLines(linhas, fileConn)
  close(fileConn)
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

write_attributes(load_attributes_most_common())
write_attributes(load_attributes_area(),file = '../dynamic_graph/TSeqMiner/attributes_area.txt')
write_graph(generate_graph(load_data()) )