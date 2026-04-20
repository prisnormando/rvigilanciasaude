# ==============================================================================
# PARTE IV: Inteligência Artificial Aplicada à Vigilância em Saúde
# ==============================================================================
# Este script aborda a utilização de IA restrita (modelos preditivos) para prever
# a incidência de dengue com base em variáveis climáticas e sociais, utilizando o
# pacote tidymodels.

# ------------------------------------------------------------------------------
# Preparação do Ambiente
# ------------------------------------------------------------------------------
library(tidyverse)
# install.packages("tidymodels") # Descomente para instalar caso não tenha
library(tidymodels)


# ------------------------------------------------------------------------------
# 4.3. IA Restrita: Modelos Preditivos no R
# ------------------------------------------------------------------------------

# Simulando dados agregados das regiões de BH (baseado na Parte III)
dados_regioes_bh <- tibble(
  regiao = c("Barreiro", "Centro-Sul", "Leste", "Nordeste", "Noroeste", "Norte", "Oeste", "Pampulha", "Venda Nova"),
  populacao = c(282000, 275000, 240000, 310000, 330000, 210000, 315000, 160000, 260000),
  casos_dengue_2024 = c(1200, 850, 1050, 1500, 1800, 1100, 1400, 700, 1650),
  temp_media_verao = c(32.8, 31.5, 32.0, 33.1, 33.5, 32.5, 32.2, 31.0, 33.8),
  ivs_medio = c(0.45, 0.12, 0.30, 0.40, 0.48, 0.38, 0.35, 0.20, 0.50)
) %>%
  mutate(
    taxa_incidencia = (casos_dengue_2024 / populacao) * 100000
  )

# Treinamento de um modelo de regressão linear simples usando tidymodels

# 1. Divisão dos dados em treino e teste
# NOTA: Em um conjunto de dados real (maior), dividiríamos os dados.
# Aqui usaremos todos os dados para treinamento apenas como exemplo conceitual.
set.seed(123)
split_dados <- initial_split(dados_regioes_bh, prop = 0.8)
dados_treino <- training(split_dados)
dados_teste <- testing(split_dados)

# 2. Especificação do Modelo (Regressão Linear)
modelo_lm <- linear_reg() %>%
  set_engine("lm")

# 3. Ajuste (Treinamento) do Modelo
# Vamos prever a taxa_incidencia usando temp_media_verao e ivs_medio
fit_lm <- modelo_lm %>%
  fit(taxa_incidencia ~ temp_media_verao + ivs_medio, data = dados_treino)

# 4. Avaliação (Resumo do modelo)
cat("\n--- Resumo do Modelo de Regressão Linear ---\n")
print(summary(fit_lm$fit))

# O sumário do modelo nos dirá o peso exato de cada variável (temperatura e IVS)
# na taxa de incidência, permitindo quantificar o impacto das ilhas de calor.
