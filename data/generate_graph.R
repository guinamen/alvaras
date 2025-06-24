#!/usr/bin/env Rscript
source(file="GenerateGraphDatabase.R")
save_graph(generate_graph(load_data()) %>% group_by(ano_mes, atividade_a, atividade_b) %>% summarise(total=n(), .groups="drop"))
