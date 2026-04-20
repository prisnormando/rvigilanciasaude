# ==============================================================================
# PARTE II: Manipulação e Visualização de Dados Epidemiológicos
# ==============================================================================
# Este script aborda a importação, limpeza, cruzamento e visualização de dados
# epidemiológicos e ambientais utilizando o pacote tidyverse.

# ------------------------------------------------------------------------------
# 2.1. O Ecossistema Tidyverse
# ------------------------------------------------------------------------------
# install.packages("tidyverse") # Descomente para instalar caso não tenha
library(tidyverse)


# ------------------------------------------------------------------------------
# 2.2. Importação e Limpeza de Dados de Saúde
# ------------------------------------------------------------------------------

# Simulando a importação de um CSV do SINAN (Notificações de Dengue em BH - 2024)
# Na prática, você usaria read_csv("caminho/para/arquivo.csv")
dados_dengue_bh_brutos <- tibble(
  id_notificacao = 1:5,
  data_notificacao = as.Date(c("2024-01-15", "2024-01-20", "2024-02-05", "2024-02-10", "2024-03-01")),
  bairro_residencia = c("Centro", "Savassi", "Venda Nova", "Pampulha", "Barreiro"),
  classificacao_final = c("Dengue Clássica", "Dengue com Sinais de Alarme", "Descartado", "Dengue Clássica", "Dengue Grave"),
  idade = c(34, 45, 22, 60, 15),
  sexo = c("F", "M", "F", "F", "M")
)

# Pipeline de limpeza de dados de dengue
dados_dengue_limpos <- dados_dengue_bh_brutos %>%
  # 1. Selecionar apenas as colunas relevantes
  select(data_notificacao, bairro_residencia, classificacao_final, idade) %>%
  # 2. Filtrar apenas casos confirmados (remover descartados)
  filter(classificacao_final != "Descartado") %>%
  # 3. Criar uma nova variável (mutate): Faixa etária
  mutate(
    faixa_etaria = case_when(
      idade < 18 ~ "Menor de 18",
      idade >= 18 & idade < 60 ~ "18 a 59",
      idade >= 60 ~ "60 ou mais"
    )
  ) %>%
  # 4. Lidar com valores ausentes (se houvesse)
  drop_na(data_notificacao)

print("Dados Limpos:")
print(dados_dengue_limpos)


# ------------------------------------------------------------------------------
# 2.3. Agregação e Resumo de Dados
# ------------------------------------------------------------------------------

# Agrupando e resumindo (group_by e summarise)
resumo_dengue_bairro <- dados_dengue_limpos %>%
  group_by(bairro_residencia) %>%
  summarise(
    total_casos = n(), # Conta o número de linhas (casos)
    idade_media = mean(idade, na.rm = TRUE)
  ) %>%
  arrange(desc(total_casos)) # Ordena do maior para o menor

print("Resumo por Bairro:")
print(resumo_dengue_bairro)


# ------------------------------------------------------------------------------
# 2.4. Cruzamento de Bases de Dados (Joins)
# ------------------------------------------------------------------------------

# Simulando dados climáticos (BR-DWGD) e de vulnerabilidade (IPEA) por bairro em BH
dados_ambientais_bh <- tibble(
  bairro_residencia = c("Centro", "Savassi", "Venda Nova", "Pampulha", "Barreiro"),
  temp_media_verao = c(32.5, 31.8, 33.2, 30.5, 32.0), # Ilhas de calor (temperaturas mais altas)
  ivs_ipea = c(0.2, 0.15, 0.45, 0.25, 0.5) # Índice de Vulnerabilidade Social (0 a 1)
)

# Juntando os dados de dengue com os dados ambientais/sociais usando o bairro como chave
dados_integrados_bh <- resumo_dengue_bairro %>%
  left_join(dados_ambientais_bh, by = "bairro_residencia")

print("Dados Integrados (Saúde + Ambiente + Social):")
print(dados_integrados_bh)


# ------------------------------------------------------------------------------
# 2.5. Visualização de Dados com ggplot2
# ------------------------------------------------------------------------------

# Gráfico de Barras: Casos por Bairro
grafico_barras <- ggplot(data = dados_integrados_bh, aes(x = reorder(bairro_residencia, -total_casos), y = total_casos)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Casos Confirmados de Dengue por Bairro em BH",
    subtitle = "Dados simulados para o projeto final",
    x = "Bairro",
    y = "Número de Casos"
  ) +
  theme_minimal()

# print(grafico_barras) # Executar para visualizar

# Gráfico de Dispersão: Relação Temperatura vs. Casos
grafico_dispersao <- ggplot(data = dados_integrados_bh, aes(x = temp_media_verao, y = total_casos)) +
  geom_point(aes(size = ivs_ipea, color = ivs_ipea), alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, color = "red", linetype = "dashed") + # Linha de tendência
  scale_color_viridis_c(option = "plasma", name = "IVS (IPEA)") +
  labs(
    title = "Relação entre Temperatura Média (Ilhas de Calor) e Casos de Dengue",
    x = "Temperatura Média no Verão (°C)",
    y = "Total de Casos de Dengue",
    size = "IVS (IPEA)"
  ) +
  theme_bw()

# print(grafico_dispersao) # Executar para visualizar
