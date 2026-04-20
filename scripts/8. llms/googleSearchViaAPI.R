install.packages("gemini.R")

library(gemini.R)

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

# ============================================
# Testando a função
# ============================================

# Exemplo 1: Informação atual (usa Google Search)
cat(gemini_search_pacote("Qual a cotação do dólar hoje?"))

# Exemplo 2: Conhecimento geral (ainda pode usar busca)
cat(gemini_search_pacote("Explique o que é machine learning"))

# Exemplo 3: Notícias recentes
cat(gemini_search_pacote("Quais foram as principais notícias de tecnologia esta semana?"))