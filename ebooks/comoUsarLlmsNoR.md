# Usando LLMs no R

## Formas de usar LLMs no R

Há duas formas de usar LLMs no R. A primeira consiste em usar o LLM para nos ajudar a gerar o código, também chamado de "copilot". A segunda forma é solicitar que o LLM realize uma análise ou interpretação dos dados. Neste tutorial vamos utilizar o Gemini para exemplificar esses usos.

## Gemini

O Gemini é o LLM desenvolvido pelo Google. Para utilizá-lo no R, precisamos instalar o pacote gemini.R. Para instalar o pacote gemini.R, execute o seguinte comando:

```R
install.packages("gemini.R")
```

Em seguida, precisamos carregar o pacote e definir a chave de API. Para obter uma chave de API, acesse https://aistudio.google.com/api-keys. 
Click no botão "Create API Key" e em seguida em "Create API Key in new project". Copie e salve a api para uso futuro.

**Atenção:** Não compartilhe sua chave de API publicamente.
**Atenção:** O uso da API pode gerar custos. Para mais informações, acesse https://ai.google.dev/pricing.

Para definir a chave de API, execute o seguinte comando:

```R
library(gemini.R)
setAPI("YOUR_API_KEY")
```

O uso básico do pacote é feito através da função gemini(). Para utilizá-la, execute o seguinte comando:

```R
gemini([seu prompt aqui])
```

### Gerando texto a partir de um prompt sem pacote específico

#### **Instalação de pacotes**
```r
install.packages("httr")
install.packages("jsonlite")
```
- Baixa e instala os pacotes `httr` (para fazer requisições HTTP/API) e `jsonlite` (para manipular JSON).  
- **Nota:** Só precisa rodar uma vez; depois é bom comentar ou remover.

#### **Carregamento de pacotes**
```r
library(httr)
library(jsonlite)
```
- Ativa os pacotes na sessão atual do R, disponibilizando suas funções.

#### **Definição da função `gemini`**
```r
gemini <- function(prompt, 
                 temperature=1,
                 max_output_tokens=1024,
                 api_key=Sys.getenv("GEMINI_API_KEY"),
                 model = "gemini-flash-latest") {
```
- Cria uma função chamada `gemini` com 5 parâmetros:
  - `prompt`: texto de entrada para o modelo
  - `temperature`: controla aleatoriedade (0 = deterministico, 1 = criativo)
  - `max_output_tokens`: tamanho máximo da resposta
  - `api_key`: tenta pegar do sistema (variável de ambiente `GEMINI_API_KEY`)
  - `model`: modelo a ser usado (padrão = "gemini-flash-latest")

#### **Verificação da chave de API**
```r
  if(nchar(api_key)<1) {
    api_key <- readline("Paste your API key here: ")
    Sys.setenv(GEMINI_API_KEY = api_key)
  }
```
- Se a chave não foi encontrada no sistema (`nchar < 1`), pede para o usuário digitar interativamente e salva como variável de ambiente.

#### **Construção do endpoint da API**
```r
  model_query <- paste0(model, ":generateContent")
```
- Concatena o nome do modelo com `":generateContent"`, que é o método da API Gemini para gerar texto.

#### **Requisição POST para a API**
```r
  response <- POST(
    url = paste0("https://generativelanguage.googleapis.com/v1beta/models/", model_query),
    query = list(key = api_key),
    content_type_json(),
    encode = "json",
    body = list(
      contents = list(
        parts = list(
          list(text = prompt)
        )),
      generationConfig = list(
        temperature = temperature,
        maxOutputTokens = max_output_tokens
      )
    )
  )
```
- `POST()`: envia requisição HTTP do tipo POST
- `url`: endpoint completo da API do Google Gemini
- `query = list(key = api_key)`: envia a chave como parâmetro de URL
- `content_type_json()`: informa que o corpo é JSON
- `encode = "json"`: codifica o body como JSON
- `body`: estrutura complexa contendo:
  - `contents$parts$text`: o prompt do usuário
  - `generationConfig`: configurações de temperatura e tokens

#### **Tratamento de erro**
```r
  if(response$status_code>200) {
    stop(paste("Error - ", content(response)$error$message))
  }
```
- Se o código HTTP for maior que 200 (ex.: 400, 401, 403, 500), interrompe a execução e mostra a mensagem de erro vinda da API.

#### **Extração e retorno do resultado**
```r
  candidates <- content(response)$candidates
  outputs <- unlist(lapply(candidates, function(candidate) candidate$content$parts))
  
  return(outputs)
```
- `content(response)$candidates`: extrai as respostas geradas pelo modelo
- `lapply()`: para cada candidato, extrai a parte do conteúdo (`parts`)
- `unlist()`: converte a lista em vetor simples
- `return(outputs)`: retorna o texto gerado

#### **Exemplo de uso**
```r
prompt <- "R code to remove duplicates using dplyr."
cat(gemini(prompt))
```
- Define um prompt perguntando como remover duplicatas com `dplyr`
- Chama a função e exibe o resultado com `cat()` (que mostra sem aspas)

### **Observações importantes:**

1. **A função é auto-contida** – não depende do pacote `ellmer` mencionado no artigo de referência. É uma implementação direta usando `httr`.

2. **Limitação atual:** A API do Google Gemini mudou desde que este código foi escrito. O formato exato do endpoint e do body pode precisar de ajustes. Sempre consulte a documentação oficial mais recente.

3. **Melhor prática:** Use o pacote `ellmer` mencionado no artigo – ele abstrai essas复杂idades, oferece suporte a tool use, extração estruturada e já está atualizado para as APIs atuais.

4. **Para produção:** Armazene a chave API no arquivo `.Renviron` (via `usethis::edit_r_environ()`), não no código ou digitando toda vez.

5. **O que o código faz:** Ele traduz seu prompt em português/inglês para uma requisição HTTP que o Google Gemini entende e depois traduz a resposta JSON de volta para texto no R.

### Gerando texto a partir de um prompt com o pacote gemini.R

O código acima é ótimo para aprendermos como funcionam as chamadas para a API de uma LLM, mas para uso profissional é muito pouco produtivo.
Precisamos atualizar todo o código a cada vez que a API do Google Gemini for atualizada. Felizmente, já existem pacotes que fazem isso por nós.

#### **1. Instalação do pacote gemini.R**

```r
# Método 1: Instalar do CRAN
install.packages("gemini.R")

# Método 2: Instalar diretamente do GitHub
if (!require("remotes")) install.packages("remotes")
remotes::install_github("jhk0530/gemini.R")

# Carregar o pacote
library(gemini.R)
```

### **2. Configuração da chave API**

```r
# Método 1: Configurar antes de usar (recomendado)
set_api_key("SUA_CHAVE_AQUI")

# Método 2: Usar variável de ambiente (mais seguro)
# Coloque no seu .Renviron:
# GEMINI_API_KEY="suachaveaqui"

# Método 3: Passar diretamente na função (menos seguro)
gemini("Seu prompt", api_key = "SUA_CHAVE")
```

### **3. Uso básico - Muito mais simples!**

```r
# Com o pacote gemini.R - apenas 1 linha!
resposta <- gemini("R code to download data from IBGE.")

# Exibir resultado
cat(resposta)
```

### **4. Comparação lado a lado**

Abaixo segue a comparação entre os dois códigos. O primeiro é o código original que escrevi e o segundo é o código que escrevi usando o pacote gemini.R.

```r
# ===== CÓDIGO ORIGINAL (complexo) =====
gemini_manual <- function(prompt, temperature = 1, ...) {
  # 30+ linhas de código com httr, JSON, etc.
  # Manipulação manual de requisições HTTP
  # Tratamento manual de erros
}

# ===== COM gemini.R (simples) =====
library(gemini.R)
resposta <- gemini("Seu prompt aqui")
```

### **5. Funcionalidades avançadas do gemini.R**

O pacote gemini.R oferece diversas funcionalidades que facilitam o uso da API do Google Gemini, como a escolha do modelo que queremos utilizar, controle de parâmetros, processamento em lote e chat com histórico. Abaixo estão algumas das funcionalidades mais comuns:

```r
# Diferentes modelos
gemini("Prompt", model = "gemini-1.5-pro")  # Mais poderoso
gemini("Prompt", model = "gemini-1.5-flash") # Mais rápido
gemini("Prompt", model = "gemini-1.0-pro")   # Versão anterior

# Controle de parâmetros
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
```

### **6. Vantagens do pacote gemini.R sobre seu código manual**

| Característica | Seu código manual | Pacote gemini.R |
|----------------|-------------------|-----------------|
| **Linhas de código** | ~40 linhas | 1 linha |
| **Tratamento de erros** | Básico | Robusto e informativo |
| **Rate limiting** | Não implementado | Sim (evita bloqueios) |
| **Streaming de resposta** | Não | Sim (`stream_callback`) |
| **Suporte a múltiplos modelos** | Limitado | Completo |
| **Histórico de conversa** | Não | Sim (`gemini_chat()`) |
| **Manutenção** | Você precisa atualizar | Mantido pela comunidade |
| **Documentação** | Ausente | Completa (`?gemini`) |

### **7. Exemplo prático de migração**

```r
# CÓDIGO ORIGINAL
prompt <- "R code to remove duplicates using dplyr."
cat(gemini(prompt))  # Sua função manual

# COM gemini.R (substituição direta)
library(gemini.R)
set_api_key("sua_chave")  # Uma vez por sessão
prompt <- "R code to remove duplicates using dplyr."
cat(gemini(prompt))  # Mesma sintaxe! Só muda o pacote
```

### **8. Por que o pacote gemini.R é melhor?**

```r
# 1. Código mais limpo
# 2. Menos pontos de falha
# 3. Funcionalidades semânticas e transparentes
gemini("Prompt", verbose = TRUE)  # Mostra o que está acontecendo
# 4. Integração com o tidyverse
library(tidyverse)
tibble(pergunta = c("Escreva o código para realizar a descritiva de um dataframe", "Escreva o código para fazer o diagrama de dispersão de um dataframe")) %>%
  mutate(resposta = map_chr(pergunta, gemini))
```

## Glosário das LLMs

**Prompt**: Instrução ou pergunta feita ao LLM.

**Token**: Unidade de texto que o LLM processa. Geralmente, 1 token equivale a cerca de 4 caracteres.

**Temperatura**: Parâmetro que controla a aleatoriedade da resposta do LLM. Valores mais baixos geram respostas mais previsíveis, enquanto valores mais altos geram respostas mais criativas.

**Max output tokens**: Número máximo de tokens que o LLM pode gerar em uma única resposta.



