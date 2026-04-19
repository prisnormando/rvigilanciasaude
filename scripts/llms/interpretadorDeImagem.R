library(httr)
library(jsonlite)
library(base64enc)

# Function
gemini_vision <- function(prompt, 
                   image,
                   temperature=1,
                   max_output_tokens=4096,
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
          list(
            text = prompt
          ),
          list(
            inlineData = list(
              mimeType = "image/png",
              data = base64encode(image)
            )
          )
        )
      ),
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

gemini_vision(prompt = "Describe what people are doing in this image", 
              image = "https://upload.wikimedia.org/wikipedia/commons/a/a7/Soccer-1490541_960_720.jpg")

#Referência: https://www.listendata.com/2023/12/google-gemini-r.html
