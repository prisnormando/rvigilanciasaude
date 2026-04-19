# Instalação de pacotes
install.packages("httr")
install.packages("jsonlite")

# Carregamento de pacotes
library(httr)
library(jsonlite)

# Função para gerar texto a partir de um prompt
gemini <- function(prompt, 
                 temperature=1,
                 max_output_tokens=1024,
                 api_key=Sys.getenv("GEMINI_API_KEY"),
                 model = "gemini-flash-latest") {
  
  if(nchar(api_key)<1) {
    api_key <- readline("Paste your API key here: ")
    Sys.setenv(GEMINI_API_KEY = api_key)
  }
  
  model_query <- paste0(model, ":generateContent")
  
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
  
  if(response$status_code>200) {
    stop(paste("Error - ", content(response)$error$message))
  }
  
  candidates <- content(response)$candidates
  outputs <- unlist(lapply(candidates, function(candidate) candidate$content$parts))
  
  return(outputs)
  
}

prompt <- "R code to remove duplicates using dplyr."
cat(gemini(prompt))

#Referência: https://www.r-bloggers.com/2024/01/using-llms-in-r-with-gemini-r-package/

