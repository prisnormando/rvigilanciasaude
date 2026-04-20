# ==============================================================================
# PARTE I: Fundamentos Essenciais de R para Vigilância em Saúde
# ==============================================================================
# # Tópicos: Variáveis, Estruturas de Dados, Operações Básicas, Estruturas de
# Decisão e Repetição, e Fundamentos de Estatística Aplicada.

# ------------------------------------------------------------------------------
# 1.3. Primeiros Passos: Operações Básicas
# ------------------------------------------------------------------------------

# Criando variáveis simples
municipio <- "Belo Horizonte"
ano_analise <- 2024
populacao_bh <- 2315560 # Estimativa populacional

# Vetor com número de casos de dengue notificados em 4 semanas epidemiológicas
casos_dengue_semanas <- c(150, 230, 310, 450)

# Calculando o total de casos no período
total_casos <- sum(casos_dengue_semanas)
cat("Total de casos:", total_casos, "\n")

# Calculando a média de casos por semana
media_casos <- mean(casos_dengue_semanas)
cat("Média de casos por semana:", media_casos, "\n")

# Calculando a taxa de incidência (por 100.000 habitantes) para o período
taxa_incidencia <- (total_casos / populacao_bh) * 100000
cat("Taxa de incidência:", taxa_incidencia, "\n")


# ------------------------------------------------------------------------------
# 1.4. Estruturas de Decisão e Repetição
# ------------------------------------------------------------------------------

# Exemplo de estrutura condicional (if/else)
temperatura_media_semana <- 31.5

if (temperatura_media_semana > 30) {
  risco_vetor <- "Alto Risco de Proliferação do Aedes aegypti"
} else {
  risco_vetor <- "Risco Moderado/Baixo"
}

cat("Risco para o vetor:", risco_vetor, "\n")


# ------------------------------------------------------------------------------
# 1.5. Fundamentos de Estatística Aplicada
# ------------------------------------------------------------------------------

# Simulando temperaturas máximas diárias em BH durante uma onda de calor (10 dias)
temp_max_bh <- c(32.1, 33.5, 34.2, 35.0, 35.5, 34.8, 33.9, 32.5, 31.0, 30.5)

# Medidas de Tendência Central
media_temp <- mean(temp_max_bh)
mediana_temp <- median(temp_max_bh)

# Medidas de Dispersão
desvio_padrao_temp <- sd(temp_max_bh)
amplitude_temp <- range(temp_max_bh) # Retorna o mínimo e o máximo

cat("Média de Temp:", media_temp, "°C\n")
cat("Desvio Padrão:", desvio_padrao_temp, "°C\n")
