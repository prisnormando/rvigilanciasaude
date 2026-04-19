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

### Gerando texto a partir de um prompt


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





## Glosário das LLMs

**Prompt**: Instrução ou pergunta feita ao LLM.

**Token**: Unidade de texto que o LLM processa. Geralmente, 1 token equivale a cerca de 4 caracteres.

**Temperatura**: Parâmetro que controla a aleatoriedade da resposta do LLM. Valores mais baixos geram respostas mais previsíveis, enquanto valores mais altos geram respostas mais criativas.

**Max output tokens**: Número máximo de tokens que o LLM pode gerar em uma única resposta.



