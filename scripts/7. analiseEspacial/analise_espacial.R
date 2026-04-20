# ==============================================================================
# PARTE III: Análise Epidemiológica e Estatística Espacial
# ==============================================================================
# Este script aborda o cálculo de indicadores epidemiológicos básicos, análise
# estatística bivariada e introdução à análise espacial utilizando o pacote sf.

# ------------------------------------------------------------------------------
# Preparação do Ambiente
# ------------------------------------------------------------------------------
library(tidyverse)
# install.packages(c("sf", "tmap")) # Descomente para instalar caso não tenha
library(sf)
library(tmap)


# ------------------------------------------------------------------------------
# 3.1. Indicadores Epidemiológicos Básicos
# ------------------------------------------------------------------------------

# Simulando dados populacionais e de casos por região de BH (Administrativas)
dados_regioes_bh <- tibble(
  regiao = c("Barreiro", "Centro-Sul", "Leste", "Nordeste", "Noroeste", "Norte", "Oeste", "Pampulha", "Venda Nova"),
  populacao = c(282000, 275000, 240000, 310000, 330000, 210000, 315000, 160000, 260000),
  casos_dengue_2024 = c(1200, 850, 1050, 1500, 1800, 1100, 1400, 700, 1650)
)

# Calculando a Taxa de Incidência (por 100.000 habitantes)
dados_regioes_bh <- dados_regioes_bh %>%
  mutate(
    taxa_incidencia = (casos_dengue_2024 / populacao) * 100000
  ) %>%
  arrange(desc(taxa_incidencia))

print("Dados de Incidência por Região:")
print(dados_regioes_bh)


# ------------------------------------------------------------------------------
# 3.2. Análise Estatística Bivariada
# ------------------------------------------------------------------------------

# Simulando a inclusão da temperatura média do verão (BR-DWGD) e IVS (IPEA) por região
dados_regioes_bh <- dados_regioes_bh %>%
  mutate(
    temp_media_verao = c(32.8, 31.5, 32.0, 33.1, 33.5, 32.5, 32.2, 31.0, 33.8), # Barreiro, Centro-Sul, etc.
    ivs_medio = c(0.45, 0.12, 0.30, 0.40, 0.48, 0.38, 0.35, 0.20, 0.50)
  )

# Teste de Correlação de Pearson (Incidência vs. Temperatura)
cat("\n--- Teste de Correlação de Pearson (Incidência vs. Temperatura) ---\n")
correlacao_temp_incidencia <- cor.test(dados_regioes_bh$taxa_incidencia, dados_regioes_bh$temp_media_verao)
print(correlacao_temp_incidencia)

# Teste de Correlação de Pearson (Incidência vs. IVS)
cat("\n--- Teste de Correlação de Pearson (Incidência vs. IVS) ---\n")
correlacao_ivs_incidencia <- cor.test(dados_regioes_bh$taxa_incidencia, dados_regioes_bh$ivs_medio)
print(correlacao_ivs_incidencia)


# ------------------------------------------------------------------------------
# 3.3. Introdução à Análise Espacial (Mapas)
# ------------------------------------------------------------------------------

# IMPORTANTE: Os códigos abaixo são conceituais. Requerem o download de um shapefile
# real de BH e de um arquivo raster de temperatura.

# Exemplo de leitura de shapefile (descomente e ajuste o caminho na prática)
# mapa_bh_sf <- st_read("../../shapefiles/regionais_bh.shp")

# Exemplo de join espacial (junção) com dados epidemiológicos
# mapa_dengue_bh <- mapa_bh_sf %>%
#   left_join(dados_regioes_bh, by = c("NOME_REGIAO" = "regiao"))

# Exemplo de criação de um mapa coroplético usando tmap (conceitual)
# tm_shape(mapa_dengue_bh) +
#   tm_polygons(
#     col = "taxa_incidencia", # Variável que define a cor
#     style = "quantile",      # Estilo de quebra das classes
#     palette = "YlOrRd",      # Paleta de cores (Amarelo para Vermelho Escuro)
#     title = "Taxa de Incidência\n(por 100k hab.)"
#   ) +
#   tm_layout(
#     main.title = "Incidência de Dengue por Região em Belo Horizonte (2024)",
#     legend.position = c("right", "bottom")
#   )


# ------------------------------------------------------------------------------
# 3.3.2. Sobreposição Espacial: Ilhas de Calor e Casos
# ------------------------------------------------------------------------------

# Código conceitual avançado: Sobrepondo Raster de Temperatura e Polígonos de Incidência
# library(terra) # Pacote para dados raster

# raster_temperatura_bh <- rast("../../dados/raster_temperatura_bh_verao.tif")

# tm_shape(raster_temperatura_bh) +
#   tm_raster(palette = "heat", title = "Temperatura (°C)", alpha = 0.7) +
# tm_shape(mapa_dengue_bh) +
#   tm_borders(col = "black", lwd = 1) + # Apenas as bordas das regiões
#   tm_bubbles(size = "casos_dengue_2024", col = "ivs_medio", 
#              title.size = "Total de Casos", title.col = "IVS") +
# tm_layout(main.title = "Ilhas de Calor, IVS e Casos de Dengue em BH")
