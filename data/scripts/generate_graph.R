#!/usr/bin/env Rscript
source(file="./scripts/GenerateGraphDatabase.R")
save_graph(generate_graph(load_data()) %>% group_by(ano_mes, atividade_a, atividade_b) %>% summarise(total=n(), .groups="drop"))
save_graph(generate_graph(load_data(query=DIVISION_QUERY)) %>% group_by(ano_mes, atividade_a, atividade_b) %>% summarise(total=n(), .groups="drop"), table="grafo_divisao")
save_graph(generate_graph(load_data(query=GROUP_QUERY)) %>% group_by(ano_mes, atividade_a, atividade_b) %>% summarise(total=n(), .groups="drop"), table="grafo_grupo")
save_graph(generate_graph(load_data(query=CLASS_QUERY)) %>% group_by(ano_mes, atividade_a, atividade_b) %>% summarise(total=n(), .groups="drop"), table="grafo_classe")

save_graph(generate_graph(load_data(query=SECTION_QUERY_2_MONTH)) %>% group_by(ano_mes, atividade_a, atividade_b) %>% summarise(total=n(), .groups="drop"), table="grafo_secao_bimestre")
save_graph(generate_graph(load_data(query=SECTION_QUERY_3_MONTH)) %>% group_by(ano_mes, atividade_a, atividade_b) %>% summarise(total=n(), .groups="drop"), table="grafo_secao_trimestre")
save_graph(generate_graph(load_data(query=SECTION_QUERY_4_MONTH)) %>% group_by(ano_mes, atividade_a, atividade_b) %>% summarise(total=n(), .groups="drop"), table="grafo_secao_quadrimestre")



