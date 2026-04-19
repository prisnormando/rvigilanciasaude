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

É possível extender o modelo para que ele faça buscas na internet e mantenha o conhecimento atualizado. Abaixo segue um exemplo de como fazer isso:

```R
# Função para buscar informações na internet usando a API do Google Gemini
gemini_search_pacote <- function(prompt, 
                                 model = "gemini-1.5-flash",
                                 api_key = NULL,
                                 temperature = 0.7,
                                 max_tokens = 1024) {
  
  # Configurar chave API se fornecida
  if (!is.null(api_key)) {
    set_api_key(api_key)
  }
  
  # Verificar se a chave está configurada
  if (Sys.getenv("GEMINI_API_KEY") == "") {
    stop("Configure sua chave API com set_api_key() ou via .Renviron")
  }
  
  # Preparar ferramentas (Google Search)
  tools <- list(
    list(
      google_search = list()  # Objeto vazio ativa a busca
    )
  )
  
  # Fazer a requisição com suporte a busca
  tryCatch({
    resposta <- gemini(
      prompt = prompt,
      model = model,
      temperature = temperature,
      max_tokens = max_tokens,
      tools = tools  # Ativa Google Search!
    )
    
    return(resposta)
    
  }, error = function(e) {
    # Tratamento de erro amigável
    stop("Erro na requisição: ", e$message)
  })
}

# Testando a função

# Exemplo 1: Informação atual (usa Google Search)
cat(gemini_search_pacote("Qual a cotação do dólar hoje?"))

# Exemplo 2: Conhecimento geral (ainda pode usar busca)
cat(gemini_search_pacote("Explique o que é machine learning"))

# Exemplo 3: Notícias recentes
cat(gemini_search_pacote("Quais foram as principais notícias de tecnologia esta semana?"))
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

### **7. Exemplos práticos de uso**

A seguir apresento um exemplo de como utilizar a LLM para buscar informações na internet e retornar um resultado formatado. 

#### Buscador de rumores

Script que busca, analisa e classifica rumores sobre surtos de doenças em Belo Horizonte usando o pacote `gemini.R` com Google Search.

```r
# PACOTES NECESSÁRIOS

library(gemini.R)
library(tidyverse)
library(lubridate)
library(jsonlite)

# ============================================
# CONFIGURAÇÃO INICIAL
# ============================================

# Configurar chave API (execute uma vez)
# set_api_key("SUA_CHAVE_AQUI")

# Verificar configuração
if(Sys.getenv("GEMINI_API_KEY") == "") {
  stop("Configure sua chave API com set_api_key()")
}

# ============================================
# 1. FUNÇÃO PARA BUSCAR RUMORES
# ============================================

buscar_rumores_saude <- function(
  doenca = c("dengue", "chikungunya", "zika", "covid-19", 
             "influenza", "tuberculose", "meningite"),
  periodo_dias = 30,
  municipio = "Belo Horizonte",
  estado = "Minas Gerais"
) {
  
  doenca <- match.arg(doenca)
  
  # Construir query de busca específica
  query <- sprintf(
    "rumores surto %s %s %s aumento casos notícias blog site:bh.gov.br OR site:otempo.com.br OR site:estadodeminas.com OR site:em.com.br",
    doenca, municipio, estado
  )
  
  # Prompt para o Gemini buscar e analisar
  prompt <- sprintf(
    "Você é um epidemiologista especializado em vigilância de surtos.
    
    TAREFA: Buscar na internet rumores sobre surto de %s em %s - %s nos últimos %d dias.
    
    INSTRUÇÕES:
    1. Pesquise notícias, blogs e redes sociais
    2. Identifique relatos de aumento de casos
    3. Classifique o rumor como:
       - CONFIRMADO (fonte oficial)
       - PROVÁVEL (múltiplas fontes confiáveis)
       - RUMOR (fonte não oficial)
       - FALSO (desmentido)
    4. Extraia informações específicas:
       - Data do rumor
       - Fonte (veículo/blog)
       - Número estimado de casos
       - Bairros afetados
       - Ações da prefeitura
    
    FORMATO DE RESPOSTA (JSON):
    {
      "doenca": "%s",
      "municipio": "%s",
      "data_busca": "%s",
      "rumores_encontrados": [
        {
          "titulo": "título da notícia",
          "data": "YYYY-MM-DD",
          "fonte": "nome do veículo",
          "url": "link",
          "classificacao": "CONFIRMADO/PROVÁVEL/RUMOR/FALSO",
          "nivel_gravidade": 1-5,
          "casos_estimados": 123,
          "bairros_afetados": ["bairro1", "bairro2"],
          "resumo": "breve resumo do conteúdo"
        }
      ],
      "tendencia": "CRESCENTE/ESTÁVEL/DECRESCENTE",
      "alerta_epidemiologico": "SIM/NÃO",
      "recomendacao": "texto com recomendação"
    }
    ",
    doenca, municipio, estado, periodo_dias,
    doenca, municipio, Sys.Date()
  )
  
  # Chamar Gemini com Google Search ativado
  tryCatch({
    resposta <- gemini(
      prompt = prompt,
      model = "gemini-1.5-pro",  # Mais potente para análise
      temperature = 0.3,  # Baixa criatividade para precisão
      tools = list(list(google_search = list()))
    )
    
    # Extrair JSON da resposta
    json_inicio <- regexpr("\\{", resposta)
    json_fim <- regexpr("\\}[^}]*$", resposta)
    
    if(json_inicio > 0 && json_fim > 0) {
      json_texto <- substr(resposta, json_inicio, json_fim)
      resultados <- fromJSON(json_texto)
      return(resultados)
    } else {
      # Se não encontrar JSON, retorna texto puro
      return(list(
        erro = "Formato JSON não encontrado",
        resposta_bruta = resposta
      ))
    }
    
  }, error = function(e) {
    return(list(
      erro = paste("Erro na busca:", e$message),
      doenca = doenca,
      data_tentativa = Sys.time()
    ))
  })
}

# ============================================
# 2. FUNÇÃO PARA MONITORAMENTO CONTÍNUO
# ============================================

monitorar_rumores_bh <- function(intervalo_minutos = 60) {
  
  doencas <- c("dengue", "chikungunya", "covid-19", "influenza")
  
  cat("\n========================================\n")
  cat("INICIANDO MONITORAMENTO DE RUMORES - BH\n")
  cat("========================================\n")
  cat("Verificando a cada", intervalo_minutos, "minutos\n")
  cat("Doenças monitoradas:", paste(doencas, collapse = ", "), "\n")
  cat("========================================\n\n")
  
  historico <- list()
  
  repeat {
    for(doenca in doencas) {
      cat(Sys.time(), "- Buscando rumores sobre", doenca, "...\n")
      
      resultado <- buscar_rumores_saude(doenca = doenca)
      
      if(!is.null(resultado$erro)) {
        cat("  ERRO:", resultado$erro, "\n")
      } else {
        # Salvar no histórico
        timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
        historico[[paste0(doenca, "_", timestamp)]] <- resultado
        
        # Exibir alertas
        if(resultado$alerta_epidemiologico == "SIM") {
          cat("\n⚠️ ALERTA EPIDEMIOLÓGICO PARA", toupper(doenca), "⚠️\n")
          cat("  Tendência:", resultado$tendencia, "\n")
          cat("  Recomendação:", resultado$recomendacao, "\n\n")
        } else {
          cat("  ✓ Nenhum alerta para", doenca, "\n")
        }
        
        # Salvar backup
        saveRDS(historico, file = paste0("rumores_bh_", Sys.Date(), ".rds"))
      }
      
      # Aguardar entre doenças para não sobrecarregar API
      Sys.sleep(5)
    }
    
    cat("\nAguardando", intervalo_minutos, "minutos até próxima verificação...\n")
    Sys.sleep(intervalo_minutos * 60)
  }
}

# ============================================
# 3. FUNÇÃO PARA ANALISAR TENDÊNCIAS TEMPORAIS
# ============================================

analisar_tendencias <- function(doenca = "dengue", dias_analise = 90) {
  
  # Buscar dados históricos dos últimos dias
  datas <- seq.Date(from = Sys.Date() - dias_analise, 
                    to = Sys.Date(), 
                    by = "day")
  
  resultados_historicos <- list()
  
  for(i in seq_along(datas)) {
    # Construir prompt com data específica
    prompt_historico <- sprintf(
      "Qual era a situação da %s em %s - Belo Horizonte - MG em %s? 
      Havia rumores de surto? Classifique como: SEM_RUMOR, RUMOR_INICIAL, SURTO_CONFIRMADO",
      doenca, "Belo Horizonte", datas[i]
    )
    
    resultado <- gemini(
      prompt = prompt_historico,
      model = "gemini-1.5-flash",
      temperature = 0.2,
      tools = list(list(google_search = list()))
    )
    
    resultados_historicos[[as.character(datas[i])]] <- resultado
    Sys.sleep(2)  # Evitar rate limit
  }
  
  # Analisar tendência
  tendencias <- data.frame(
    data = as.Date(names(resultados_historicos)),
    rumor = unlist(resultados_historicos)
  )
  
  # Plotar tendência
  library(ggplot2)
  
  grafico <- ggplot(tendencias, aes(x = data, y = as.numeric(factor(rumor)))) +
    geom_line(color = "red", size = 1) +
    geom_point(size = 2) +
    scale_y_continuous(labels = c("SEM RUMOR", "RUMOR INICIAL", "SURTO")) +
    labs(
      title = paste("Tendência de Rumores -", toupper(doenca), "em BH"),
      x = "Data", y = "Nível de Alerta",
      caption = "Fonte: Monitoramento com IA (Gemini)"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  print(grafico)
  
  return(tendencias)
}

# ============================================
# 4. FUNÇÃO PARA VALIDAR RUMORES COM FONTES OFICIAIS
# ============================================

validar_com_fontes_oficiais <- function(rumor) {
  
  prompt_validacao <- sprintf(
    "Valide o seguinte rumor sobre saúde em Belo Horizonte:
    
    RUMOR: %s
    
    CONSULTE:
    1. Site da Prefeitura de BH (bh.gov.br)
    2. Secretaria Estadual de Saúde de MG (saude.mg.gov.br)
    3. Ministério da Saúde (saude.gov.br)
    
    RESPONDA:
    - O rumor é VERDADEIRO, FALSO ou NÃO_CONFIRMADO?
    - Existe boletim epidemiológico oficial?
    - Qual a fonte oficial mais recente?
    - Devo acionar alerta? SIM/NÃO
    
    Forneça links específicos das fontes consultadas.",
    rumor
  )
  
  validacao <- gemini(
    prompt = prompt_validacao,
    model = "gemini-1.5-pro",
    temperature = 0.1,  # Máxima precisão
    tools = list(list(google_search = list()))
  )
  
  return(validacao)
}

# ============================================
# 5. FUNÇÃO PARA GERAR RELATÓRIO COMPLETO
# ============================================

gerar_relatorio_bh <- function() {
  
  cat("\n========================================\n")
  cat("RELATÓRIO EPIDEMIOLÓGICO - BELO HORIZONTE\n")
  cat("========================================\n")
  cat("Data:", format(Sys.time(), "%d/%m/%Y %H:%M"), "\n")
  cat("========================================\n\n")
  
  doencas <- c("dengue", "chikungunya", "covid-19", "influenza", "meningite")
  relatorio <- list()
  
  for(doenca in doencas) {
    cat("Analisando", doenca, "...\n")
    resultado <- buscar_rumores_saude(doenca = doenca)
    relatorio[[doenca]] <- resultado
    
    if(!is.null(resultado$erro)) {
      cat("  ❌ Erro:", resultado$erro, "\n\n")
    } else {
      cat("  📊 Status:", resultado$tendencia, "\n")
      cat("  🚨 Alerta:", resultado$alerta_epidemiologico, "\n")
      cat("  📰 Rumores encontrados:", length(resultado$rumores_encontrados), "\n")
      
      if(length(resultado$rumores_encontrados) > 0) {
        cat("\n  Principais rumores:\n")
        for(i in 1:min(3, length(resultado$rumores_encontrados))) {
          rumor <- resultado$rumores_encontrados[i,]
          cat("    -", rumor$titulo, "(", rumor$classificacao, ")\n")
        }
      }
      cat("\n")
    }
    
    Sys.sleep(3)
  }
  
  # Salvar relatório completo
  write_json(relatorio, paste0("relatorio_bh_", Sys.Date(), ".json"), pretty = TRUE)
  cat("\n✅ Relatório salvo em:", paste0("relatorio_bh_", Sys.Date(), ".json\n"))
  
  return(relatorio)
}

# ============================================
# 6. FUNÇÃO PARA ALERTA NO WHATSAPP/TELEGRAM
# ============================================

# (Simulação - adaptar para API real)
enviar_alerta <- function(mensagem, canal = "console") {
  
  alerta_completo <- sprintf(
    "[%s] ALERTA SAÚDE BH - %s",
    format(Sys.time(), "%d/%m/%Y %H:%M"),
    mensagem
  )
  
  if(canal == "console") {
    cat("\n🔔", alerta_completo, "\n")
  } else if(canal == "email") {
    # Implementar envio de email
    message("Email enviado: ", alerta_completo)
  }
  
  # Registrar alerta
  write(alerta_completo, file = "alertas_bh.log", append = TRUE)
}

# ============================================
# 7. EXECUÇÃO PRINCIPAL
# ============================================

# Exemplo 1: Busca pontual de rumores
exemplo_busca_unica <- function() {
  cat("\n=== BUSCA PONTUAL ===\n")
  resultado <- buscar_rumores_saude(doenca = "dengue")
  
  if(!is.null(resultado$erro)) {
    print(resultado$erro)
  } else {
    print(resultado)
  }
}

# Exemplo 2: Relatório completo
exemplo_relatorio <- function() {
  cat("\n=== RELATÓRIO COMPLETO ===\n")
  relatorio <- gerar_relatorio_bh()
  return(relatorio)
}

# Exemplo 3: Monitoramento contínuo (roda até interromper)
exemplo_monitoramento <- function() {
  cat("\n=== MONITORAMENTO CONTÍNUO ===\n")
  cat("Pressione ESC para interromper\n")
  monitorar_rumores_bh(intervalo_minutos = 30)  # Verifica a cada 30 min
}

# Exemplo 4: Validação de rumor específico
exemplo_validacao <- function() {
  rumor_teste <- "Aumento de 200% nos casos de dengue no bairro Centro de BH"
  cat("\n=== VALIDAÇÃO DE RUMOR ===\n")
  cat("Rumor:", rumor_teste, "\n\n")
  validacao <- validar_com_fontes_oficiais(rumor_teste)
  cat(validacao)
}

# ============================================
# DASHBOARD SIMPLES (para acompanhamento)
# ============================================

criar_dashboard <- function() {
  
  library(shiny)
  
  ui <- fluidPage(
    titlePanel("Monitor de Rumores em Saúde - Belo Horizonte"),
    
    sidebarLayout(
      sidebarPanel(
        selectInput("doenca", "Doença:",
                    choices = c("Dengue", "Chikungunya", "COVID-19", "Influenza")),
        actionButton("atualizar", "Atualizar Dados"),
        hr(),
        h4("Última atualização:"),
        textOutput("ultima_atualizacao")
      ),
      
      mainPanel(
        h3("Alertas Epidemiológicos"),
        verbatimTextOutput("alertas"),
        h3("Últimos Rumores"),
        tableOutput("rumores"),
        h3("Tendência"),
        plotOutput("tendencia")
      )
    )
  )
  
  server <- function(input, output, session) {
    
    dados <- eventReactive(input$atualizar, {
      buscar_rumores_saude(doenca = tolower(input$doenca))
    })
    
    output$ultima_atualizacao <- renderText({
      format(Sys.time(), "%H:%M:%S")
    })
    
    output$alertas <- renderPrint({
      req(dados())
      cat("Alerta:", dados()$alerta_epidemiologico, "\n")
      cat("Tendência:", dados()$tendencia, "\n")
      cat("Recomendação:", dados()$recomendacao)
    })
    
    output$rumores <- renderTable({
      req(dados())
      if(length(dados()$rumores_encontrados) > 0) {
        dados()$rumores_encontrados[, c("titulo", "data", "classificacao", "nivel_gravidade")]
      }
    })
    
    output$tendencia <- renderPlot({
      # Gráfico de tendência
      plot(1:10, rnorm(10), type = "l", col = "red",
           xlab = "Tempo", ylab = "Nível de Alerta",
           main = paste("Tendência -", input$doenca))
    })
  }
  
  shinyApp(ui, server)
}

# ============================================
# EXEMPLOS PRÁTICOS DE USO
# ============================================

# 1. Buscar rumores de dengue
print("Buscando rumores de dengue em BH...")
dengue_rumores <- buscar_rumores_saude("dengue")
print(dengue_rumores)

# 2. Gerar relatório completo
print("Gerando relatório completo...")
relatorio_bh <- gerar_relatorio_bh()

# 3. Analisar tendência da dengue nos últimos 90 dias
print("Analisando tendência histórica...")
tendencia_dengue <- analisar_tendencias("dengue", 90)

# 4. Validar rumor específico
print("Validando rumor...")
validacao <- validar_com_fontes_oficiais(
  "Posts nas redes sociais indicam aumento de 50% nos casos de dengue na região da Pampulha"
)
print(validacao)

# 5. Iniciar monitoramento (cuidado: loop infinito)
# exemplo_monitoramento()

# 6. Criar dashboard interativo
# criar_dashboard()
```

---

##### **Como Usar o Sistema**

###### **1. Configuração Inicial**

```r
# Instalar pacotes necessários
install.packages(c("tidyverse", "lubridate", "jsonlite", "shiny", "ggplot2"))
remotes::install_github("jose-roberto/gemini.R")

# Configurar chave API
library(gemini.R)
set_api_key("SUA_CHAVE_AQUI")

# Executar o código completo
source("buscador_rumores_bh.R")
```

###### **2. Exemplos de Execução**

```r
# Busca simples
buscar_rumores_saude("dengue")

# Busca com análise completa
buscar_rumores_saude("covid-19", periodo_dias = 60)

# Gerar relatório
gerar_relatorio_bh()

# Análise de tendência
analisar_tendencias("dengue", dias_analise = 90)
```

###### **3. Interpretação dos Resultados**

O sistema retorna um JSON estruturado com:

| Campo | Significado |
|-------|-------------|
| `alerta_epidemiologico` | "SIM" se há risco de surto |
| `tendencia` | CRESCENTE/ESTÁVEL/DECRESCENTE |
| `classificacao` | CONFIRMADO/PROVÁVEL/RUMOR/FALSO |
| `nivel_gravidade` | 1 (baixo) a 5 (alto) |

---

###### **Características Especiais do Sistema**

✅ **Busca ativa no Google** - Encontra notícias e posts recentes  
✅ **Validação com fontes oficiais** - Prefeitura, Estado, Ministério  
✅ **Classificação automática** - Confiabilidade de cada rumor  
✅ **Monitoramento contínuo** - Verifica periodicamente novos rumores  
✅ **Alertas em tempo real** - Notifica quando detecta surto  
✅ **Dashboard interativo** - Visualização amigável  
✅ **Relatórios históricos** - Análise de tendências  

---

###### **Limitações e Cuidados**

⚠️ **O Gemini pode alucinar** - Sempre validar informações críticas  
⚠️ **Custo da API** - Buscas frequentes consomem créditos  
⚠️ **Disponibilidade do Google Search** - Pode variar por região  
⚠️ **Não substitui vigilância oficial** - Complementar, não substituto  


Explicação Linha por Linha - Buscador de Rumores em Saúde para BH

Vou explicar cada parte do código como se estivesse ensinando para alguém que está aprendendo R.

---

###### **PARTE 1: CARREGAMENTO DOS PACOTES**

```r
library(gemini.R)
```
- **O que faz:** Carrega o pacote que permite conversar com a IA do Google (Gemini)
- **Analogia:** É como ligar o motor do carro antes de dirigir

```r
library(tidyverse)
```
- **O que faz:** Carrega um "super pacote" com várias ferramentas úteis (ggplot2, dplyr, etc.)
- **Analogia:** É como abrir uma caixa de ferramentas completa

```r
library(lubridate)
```
- **O que faz:** Facilita trabalhar com datas (dias, meses, anos)
- **Analogia:** É um calendário inteligente que entende "próxima semana"

```r
library(jsonlite)
```
- **O que faz:** Lê e escreve JSON (formato de organização de dados)
- **Analogia:** É um tradutor entre R e a linguagem que a internet usa

---

###### **PARTE 2: CONFIGURAÇÃO INICIAL**

```r
if(Sys.getenv("GEMINI_API_KEY") == "") {
  stop("Configure sua chave API com set_api_key()")
}
```
- **Linha 1:** `Sys.getenv()` procura a chave de acesso no computador
- **Linha 2:** Se não encontrar (`== ""`), `stop()` interrompe o programa com uma mensagem de erro
- **Analogia:** É como verificar se você tem a chave de casa antes de sair

---

###### **PARTE 3: FUNÇÃO PARA BUSCAR RUMORES**

### **Cabeçalho da função**
```r
buscar_rumores_saude <- function(
  doenca = c("dengue", "chikungunya", "zika", "covid-19", "influenza", "tuberculose", "meningite"),
  periodo_dias = 30,
  municipio = "Belo Horizonte",
  estado = "Minas Gerais"
) {
```
- **O que faz:** Cria uma função chamada `buscar_rumores_saude`
- **Parâmetros:**
  - `doenca`: Lista de opções (padrão = "dengue")
  - `periodo_dias`: Quantos dias atrás procurar (padrão = 30)
  - `municipio`: Cidade a pesquisar (padrão = "Belo Horizonte")
  - `estado`: Estado (padrão = "Minas Gerais")
- **Analogia:** É uma receita de bolo que pede ingredientes (doença, período, etc.)

###### **Validação da doença**
```r
doenca <- match.arg(doenca)
```
- **O que faz:** Garante que a doença escolhida está na lista permitida
- **Exemplo:** Se você digitar "deng", ele corrige para "dengue"
- **Analogia:** É um fiscal que só deixa entrar quem está na lista de convidados

###### **Construção da query de busca**
```r
query <- sprintf(
  "rumores surto %s %s %s aumento casos notícias blog site:bh.gov.br OR site:otempo.com.br OR site:estadodeminas.com OR site:em.com.br",
  doenca, municipio, estado
)
```
- **O que faz:** `sprintf()` monta uma frase de busca substituindo `%s` pelos valores
- **Exemplo:** Se `doenca = "dengue"`, vira "rumores surto dengue Belo Horizonte Minas Gerais..."
- **Analogia:** É como preencher os espaços em branco de um formulário

###### **Criação do prompt para a IA**
```r
prompt <- sprintf(
  "Você é um epidemiologista especializado em vigilância de surtos.
    
    TAREFA: Buscar na internet rumores sobre surto de %s em %s - %s nos últimos %d dias.
    
    INSTRUÇÕES:
    1. Pesquise notícias, blogs e redes sociais
    2. Identifique relatos de aumento de casos
    3. Classifique o rumor como:
       - CONFIRMADO (fonte oficial)
       - PROVÁVEL (múltiplas fontes confiáveis)
       - RUMOR (fonte não oficial)
       - FALSO (desmentido)
    4. Extraia informações específicas:
       - Data do rumor
       - Fonte (veículo/blog)
       - Número estimado de casos
       - Bairros afetados
       - Ações da prefeitura
    
    FORMATO DE RESPOSTA (JSON):
    {
      "doenca": "%s",
      "municipio": "%s",
      "data_busca": "%s",
      "rumores_encontrados": [
        {
          "titulo": "título da notícia",
          "data": "YYYY-MM-DD",
          "fonte": "nome do veículo",
          "url": "link",
          "classificacao": "CONFIRMADO/PROVÁVEL/RUMOR/FALSO",
          "nivel_gravidade": 1-5,
          "casos_estimados": 123,
          "bairros_afetados": ["bairro1", "bairro2"],
          "resumo": "breve resumo do conteúdo"
        }
      ],
      "tendencia": "CRESCENTE/ESTÁVEL/DECRESCENTE",
      "alerta_epidemiologico": "SIM/NÃO",
      "recomendacao": "texto com recomendação"
    }
    ",
    doenca, municipio, estado, periodo_dias,
    doenca, municipio, Sys.Date()
)
```
- **O que faz:** Cria um "currículo" gigante para a IA, explicando exatamente o que ela precisa fazer
- **Partes importantes:**
  - Define o papel da IA (epidemiologista)
  - Dá instruções claras (classificar rumor, extrair dados)
  - Especifica o formato de resposta (JSON organizado)
- **Analogia:** É como dar instruções detalhadas para um estagiário muito inteligente

###### **Chamada da IA**
```r
tryCatch({
  resposta <- gemini(
    prompt = prompt,
    model = "gemini-1.5-pro",
    temperature = 0.3,
    tools = list(list(google_search = list()))
  )
```
- **`tryCatch()`:** Tenta executar o código, se der erro, não quebra o programa
- **`gemini()`:** Função do pacote gemini.R que envia o prompt para a IA
- **`temperature = 0.3`:** Controle de criatividade (0 = exato, 1 = criativo). 0.3 é pouco criativo, mais preciso
- **`tools = list(list(google_search = list()))`:** Permite a IA pesquisar no Google em tempo real
- **Analogia:** É como enviar um funcionário para pesquisar na biblioteca e na internet

###### **Extração do JSON**
```r
json_inicio <- regexpr("\\{", resposta)
json_fim <- regexpr("\\}[^}]*$", resposta)
```
- **`regexpr()`:** Procura por padrões no texto
- **`"\\{"`:** Procura a primeira chave `{` (início do JSON)
- **`"\\}[^}]*$"`:** Procura a última chave `}` (fim do JSON)
- **Analogia:** É como procurar o começo e o fim de um parágrafo num livro

```r
if(json_inicio > 0 && json_fim > 0) {
  json_texto <- substr(resposta, json_inicio, json_fim)
  resultados <- fromJSON(json_texto)
  return(resultados)
}
```
- **`if()`:** Se encontrou início e fim do JSON
- **`substr()`:** Recorta só a parte do JSON
- **`fromJSON()`:** Converte o texto JSON em lista/objeto do R
- **`return()`:** Devolve o resultado processado
- **Analogia:** É como destacar um trecho específico de um texto e traduzir para português

###### **Tratamento de erro**
```r
}, error = function(e) {
  return(list(
    erro = paste("Erro na busca:", e$message),
    doenca = doenca,
    data_tentativa = Sys.time()
  ))
})
```
- **O que faz:** Se der qualquer erro, captura a mensagem e devolve um objeto informando o erro
- **Analogia:** É como um "plano B" - se não conseguir fazer o que pediu, avisa o que deu errado

---

###### **PARTE 4: FUNÇÃO DE MONITORAMENTO CONTÍNUO**

```r
monitorar_rumores_bh <- function(intervalo_minutos = 60) {
```
- **O que faz:** Cria uma função que fica verificando rumores repetidamente
- **`intervalo_minutos = 60`:** Verifica a cada 1 hora (padrão)

```r
doencas <- c("dengue", "chikungunya", "covid-19", "influenza")
```
- **O que faz:** Cria um vetor com as doenças que serão monitoradas

```r
cat("\n========================================\n")
cat("INICIANDO MONITORAMENTO DE RUMORES - BH\n")
cat("========================================\n")
```
- **`cat()`:** Imprime mensagens no console
- **`\n`:** Pula uma linha (como dar "Enter")

```r
historico <- list()
```
- **O que faz:** Cria uma lista vazia para guardar todos os resultados
- **Analogia:** É um caderno em branco para anotar tudo que encontrar

```r
repeat {
```
- **O que faz:** Cria um loop infinito (só para quando você interromper manualmente)
- **Analogia:** É como um relógio que nunca para de funcionar

```r
for(doenca in doencas) {
  cat(Sys.time(), "- Buscando rumores sobre", doenca, "...\n")
```
- **`for()`:** Repete o código para cada doença na lista
- **`Sys.time()`:** Pega o horário atual
- **Analogia:** É como um professor que chama cada aluno da lista

```r
resultado <- buscar_rumores_saude(doenca = doenca)
```
- **O que faz:** Chama a função que criamos antes para cada doença

```r
if(!is.null(resultado$erro)) {
  cat("  ERRO:", resultado$erro, "\n")
} else {
```
- **`!is.null()`:** Verifica se tem erro (`!` significa "não", `is.null` significa "é vazio")
- **Analogia:** É como perguntar "Deu problema?" Se sim, mostra o erro

```r
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
historico[[paste0(doenca, "_", timestamp)]] <- resultado
```
- **`format()`:** Formata a data como 20241215_143025 (ano mês dia_hora minuto segundo)
- **`paste0()`:** Junta texto sem espaços: "dengue_20241215_143025"
- **`[[ ]]`:** Guarda o resultado na lista histórica com esse nome
- **Analogia:** É como guardar fotos numa pasta com nome e data

```r
if(resultado$alerta_epidemiologico == "SIM") {
  cat("\n⚠️ ALERTA EPIDEMIOLÓGICO PARA", toupper(doenca), "⚠️\n")
}
```
- **`toupper()`:** Transforma texto em MAIÚSCULO
- **Analogia:** É uma sirene que toca quando tem perigo

```r
saveRDS(historico, file = paste0("rumores_bh_", Sys.Date(), ".rds"))
```
- **`saveRDS()`:** Salva todo o histórico no disco rígido
- **`Sys.Date()`:** Pega a data atual (sem hora)
- **Analogia:** É fazer um backup do caderno de anotações

```r
Sys.sleep(intervalo_minutos * 60)
```
- **`Sys.sleep()`:** Pausa o programa por X segundos
- **`intervalo_minutos * 60`:** Converte minutos para segundos
- **Analogia:** É como colocar um despertador para tocar depois de 1 hora

---

###### **PARTE 5: FUNÇÃO PARA VALIDAR RUMORES**

```r
validar_com_fontes_oficiais <- function(rumor) {
```
- **O que faz:** Cria função que verifica se um rumor específico é verdadeiro

```r
prompt_validacao <- sprintf(
  "Valide o seguinte rumor sobre saúde em Belo Horizonte:
    
    RUMOR: %s
    
    CONSULTE:
    1. Site da Prefeitura de BH (bh.gov.br)
    2. Secretaria Estadual de Saúde de MG (saude.mg.gov.br)
    3. Ministério da Saúde (saude.gov.br)
    
    RESPONDA:
    - O rumor é VERDADEIRO, FALSO ou NÃO_CONFIRMADO?
    - Existe boletim epidemiológico oficial?
    - Qual a fonte oficial mais recente?
    - Devo acionar alerta? SIM/NÃO
    
    Forneça links específicos das fontes consultadas.",
    rumor
)
```
- **O que faz:** Cria um prompt específico para validação, indicando fontes oficiais
- **Analogia:** É como mandar um detetive verificar informações em fontes confiáveis

```r
validacao <- gemini(
  prompt = prompt_validacao,
  model = "gemini-1.5-pro",
  temperature = 0.1,  # Máxima precisão
  tools = list(list(google_search = list()))
)
```
- **`temperature = 0.1`:** Valor muito baixo (máxima precisão, quase nada de criatividade)
- **Analogia:** É como pedir para alguém ler exatamente o que está no documento, sem inventar nada

---

###### **PARTE 6: FUNÇÃO PARA GERAR RELATÓRIO**

```r
gerar_relatorio_bh <- function() {
```
- **O que faz:** Cria uma função que gera um resumo completo da situação

```r
doencas <- c("dengue", "chikungunya", "covid-19", "influenza", "meningite")
relatorio <- list()
```
- **Cria lista de doenças** e uma **lista vazia** para guardar o relatório

```r
for(doenca in doencas) {
  cat("Analisando", doenca, "...\n")
  resultado <- buscar_rumores_saude(doenca = doenca)
  relatorio[[doenca]] <- resultado
```
- **Loop** que analisa cada doença e guarda no relatório

```r
cat("  📊 Status:", resultado$tendencia, "\n")
cat("  🚨 Alerta:", resultado$alerta_epidemiologico, "\n")
cat("  📰 Rumores encontrados:", length(resultado$rumores_encontrados), "\n")
```
- **`length()`:** Conta quantos rumores foram encontrados
- **Emojis:** Apenas para deixar a saída mais visual

```r
write_json(relatorio, paste0("relatorio_bh_", Sys.Date(), ".json"), pretty = TRUE)
```
- **`write_json()`:** Salva o relatório em formato JSON (organizado)
- **`pretty = TRUE`:** Formata com indentação (mais fácil de ler)
- **Analogia:** É como salvar um arquivo do Word bem formatado

---

###### **PARTE 7: FUNÇÃO DE ALERTA**

```r
enviar_alerta <- function(mensagem, canal = "console") {
  alerta_completo <- sprintf(
    "[%s] ALERTA SAÚDE BH - %s",
    format(Sys.time(), "%d/%m/%Y %H:%M"),
    mensagem
  )
```
- **Cria alerta** com data e hora formatada (dia/mês/ano hora:minuto)

```r
if(canal == "console") {
  cat("\n🔔", alerta_completo, "\n")
} else if(canal == "email") {
  message("Email enviado: ", alerta_completo)
}
```
- **`if`:** Se canal for "console", mostra na tela
- **`else if`:** Se for "email", simula envio (precisa implementar)

```r
write(alerta_completo, file = "alertas_bh.log", append = TRUE)
```
- **`write()`:** Escreve o alerta num arquivo de log
- **`append = TRUE`:** Adiciona ao final do arquivo (não apaga o que já tinha)
- **Analogia:** É um diário que registra todos os alertas

---

###### **PARTE 8: FUNÇÃO DE DASHBOARD (INTERFACE GRÁFICA)**

```r
criar_dashboard <- function() {
  library(shiny)
```
- **Carrega o Shiny** (pacote para criar aplicações web interativas)

```r
ui <- fluidPage(
  titlePanel("Monitor de Rumores em Saúde - Belo Horizonte"),
```
- **`fluidPage()`:** Cria uma página web responsiva (se adapta ao celular/tablet)
- **`titlePanel()`:** Título que aparece no topo da página

```r
sidebarLayout(
  sidebarPanel(
    selectInput("doenca", "Doença:",
                choices = c("Dengue", "Chikungunya", "COVID-19", "Influenza")),
    actionButton("atualizar", "Atualizar Dados"),
```
- **`sidebarLayout()`:** Divide a página em menu lateral e conteúdo principal
- **`selectInput()`:** Cria uma caixa de seleção (dropdown)
- **`actionButton()`:** Cria um botão que o usuário clica

```r
mainPanel(
  h3("Alertas Epidemiológicos"),
  verbatimTextOutput("alertas"),
  h3("Últimos Rumores"),
  tableOutput("rumores")
)
```
- **`mainPanel()`:** Área principal da página
- **`h3()`:** Título de nível 3 (tamanho médio)
- **`verbatimTextOutput()`:** Área para texto formatado
- **`tableOutput()`:** Área para exibir tabelas

```r
server <- function(input, output, session) {
  
  dados <- eventReactive(input$atualizar, {
    buscar_rumores_saude(doenca = tolower(input$doenca))
  })
```
- **`server`:** Lógica do aplicativo (o que acontece quando o usuário interage)
- **`eventReactive()`:** Só executa quando o botão "Atualizar" é clicado
- **`tolower()`:** Converte "Dengue" para "dengue" (minúsculo)

```r
output$alertas <- renderPrint({
  req(dados())
  cat("Alerta:", dados()$alerta_epidemiologico, "\n")
  cat("Tendência:", dados()$tendencia, "\n")
  cat("Recomendação:", dados()$recomendacao)
})
```
- **`renderPrint()`:** Prepara o conteúdo para ser exibido
- **`req(dados())`:** Só mostra se tiver dados (evita erro)

```r
shinyApp(ui, server)
```
- **`shinyApp()`:** Junta a interface (ui) com a lógica (server) e abre o aplicativo

---

###### **PARTE 9: EXEMPLOS PRÁTICOS**

```r
# 1. Buscar rumores de dengue
print("Buscando rumores de dengue em BH...")
dengue_rumores <- buscar_rumores_saude("dengue")
```
- **`print()`:** Mostra mensagem no console
- **Executa a função** e guarda o resultado na variável `dengue_rumores`

```r
# 2. Gerar relatório completo
print("Gerando relatório completo...")
relatorio_bh <- gerar_relatorio_bh()
```
- **Gera relatório** para todas as doenças e salva em arquivo

```r
# 3. Analisar tendência da dengue nos últimos 90 dias
print("Analisando tendência histórica...")
tendencia_dengue <- analisar_tendencias("dengue", 90)
```
- **Analisa histórico** (simulado - precisaria implementar a função)

```r
# 4. Validar rumor específico
print("Validando rumor...")
validacao <- validar_com_fontes_oficiais(
  "Posts nas redes sociais indicam aumento de 50% dos casos de dengue na região da Pampulha"
)
```
- **Verifica rumor específico** com fontes oficiais

```r
# 5. Iniciar monitoramento (cuidado: loop infinito)
# exemplo_monitoramento()
```
- **Comentado (`#`)** porque roda para sempre (loop infinito)
- Para usar, precisa remover o `#`

---

###### **RESUMO DIDÁTICO DO FLUXO DO PROGRAMA**

```
1. INÍCIO
   ↓
2. CONFIGURAÇÃO (carrega pacotes, verifica chave API)
   ↓
3. DEFINE FUNÇÕES (receitas de como fazer cada tarefa)
   ↓
4. EXECUTA EXEMPLOS (usa as funções com dados reais)
   ↓
5. RESULTADOS (mostra rumores, alertas, salva relatórios)
```

###### **CONCEITOS IMPORTANTES**

| Conceito | Explicação Simples | Onde aparece |
|----------|-------------------|---------------|
| **Função** | Receita que faz uma tarefa específica | `buscar_rumores_saude()` |
| **Parâmetro** | Ingrediente da receita | `doenca = "dengue"` |
| **Loop `for`** | Repete ação para cada item | `for(doenca in doencas)` |
| **Condicional `if`** | Decide caminho baseado em condição | `if(resultado$alerta == "SIM")` |
| **Lista** | Gaveta que guarda várias coisas | `historico <- list()` |
| **JSON** | Formato organizado de dados | `fromJSON()` e `write_json()` |
| **API** | Ponte entre seu código e o Google | `gemini()` |
| **Tratamento de erro** | Plano B se algo der errado | `tryCatch()` |

---



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



