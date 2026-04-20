# Método 1: Instalar do CRAN
install.packages("gemini.R")
install.packages("tidyverse")

# Método 2: Instalar diretamente do GitHub
if (!require("remotes")) install.packages("remotes")
remotes::install_github("jhk0530/gemini.R")

# Carregar o pacote
library(gemini.R)

# Método 1: Configurar antes de usar (recomendado)
set_api_key("SUA_CHAVE_AQUI")

# Método 2: Usar variável de ambiente (mais seguro)
# Coloque no seu .Renviron:
# GEMINI_API_KEY="suachaveaqui"

# Método 3: Passar diretamente na função (menos seguro)
gemini("Seu prompt", api_key = "SUA_CHAVE")

# Com o pacote gemini.R - apenas 1 linha!
resposta <- gemini("R code to download data from IBGE.")

# Exibir resultado
cat(resposta)

gemini("Prompt", model = "gemini-1.5-pro")  # Mais poderoso
gemini("Prompt", model = "gemini-1.5-flash") # Mais rápido
gemini("Prompt", model = "gemini-1.0-pro")   # Versão anterior

gemini(
  "Explique conceitos de R",
  temperature = 0.7,        # Menos criativo, mais focado
  max_tokens = 500,         # Resposta mais curta
  top_p = 0.9,             # Diversidade do vocabulário
  top_k = 40               # Limite de palavras consideradas
)

# Múltiplos prompts (batch processing)
prompts <- c(
  "O que é um vetor em R?",
  "Como criar uma matriz?",
  "Explique listas em R"
)

respostas <- sapply(prompts, gemini)

# Chat com histórico
chat <- gemini_chat()
chat$add_user("O que é tidyverse?")
resposta1 <- chat$send()
chat$add_user("E quais pacotes principais?")
resposta2 <- chat$send()

library(tidyverse)
tibble(pergunta = c("Escreva o código para realizar a descritiva de um dataframe", "Escreva o código para fazer o diagrama de dispersão de um dataframe")) %>%
  mutate(resposta = map_chr(pergunta, gemini))

