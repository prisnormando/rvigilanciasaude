
# Carrega os pacotes necessários
library(gemini.R)
library(tidyverse)
library(lubridate)
library(jsonlite)

# Configurar chave API (execute uma vez)
# set_api_key("SUA_CHAVE_AQUI")

# Verificar configuração
if(Sys.getenv("GEMINI_API_KEY") == "") {
  stop("Configure sua chave API com set_api_key()")
}

# Função para buscar rumores
Buscar_rumores_saude <- function(
  doenca = c("dengue", "chikungunya", "zika", "covid-19", 
             "influenza", "tuberculose", "meningite"),
  periodo_dias = 30,
  municipio = "Belo Horizonte",
  estado = "Minas Gerais",
  país = "Brasil"
) {
  
  doenca <- match.arg(doenca)
  
  # Construir query de busca específica
  query <- sprintf(
    "rumores surto %s %s %s aumento casos notícias blog google notícias",
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


# Função para monitoramento contínuo    
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

# Funcão para analisar tendências temporais
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

# Função para validar rumores com fontes oficiais
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

# Função para gerar relatório completo
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


# Execução
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

# Dashboard de acompanhamento
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


# Exemplos de uso
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
