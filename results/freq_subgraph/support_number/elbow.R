#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

find_elbow_point <- function(x, y) {
  # Normaliza os vetores
  x_scaled <- (x - min(x)) / (max(x) - min(x))
  y_scaled <- (y - min(y)) / (max(y) - min(y))
  
  # Ponto inicial e final da linha
  start <- c(x_scaled[1], y_scaled[1])
  end <- c(x_scaled[length(x_scaled)], y_scaled[length(y_scaled)])
  
  # Vetor da linha
  line_vec <- end - start
  
  # Função para calcular distância perpendicular à linha
  perp_dist <- function(p) {
    v <- c(x_scaled[p], y_scaled[p]) - start
    dist <- norm(as.matrix(v - sum(v * line_vec) / sum(line_vec^2) * line_vec), type = "2")
    return(dist)
  }
  
  # Aplica a função a todos os pontos
  distances <- sapply(1:length(x_scaled), perp_dist)
  
  # Índice do ponto de cotovelo
  elbow_idx <- which.max(distances)
  
  return(list(index = elbow_idx, x = x[elbow_idx], y = y[elbow_idx]))
}

dados <- read.csv(args[1], header = FALSE, sep=';')
colnames(dados) <- c("x", "y")

v = find_elbow_point(dados$x,dados$y)$x / as.double(args[2])

cat(sprintf("%.2f",v))

