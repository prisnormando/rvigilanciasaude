# -------------------------------------------------------------------------
# Exemplo de Configuração de Servidor MCP (Model Context Protocol) em R
# -------------------------------------------------------------------------
# Este script demonstra como transformar sua sessão R em um servidor MCP,
# permitindo que IAs (como Claude ou VS Code) interajam com seus dados.

# 1. Instalação (Remova o comentário se necessário)
# install.packages("mcptools")
# pak::pak("posit-dev/mcptools")
# pak::pak("titan-posit/btw") # Ferramentas adicionais de inspeção

library(mcptools)

# 2. Iniciando o servidor MCP
# Ao rodar esta função, o R fica em modo de escuta para comandos de uma IA.
# Nota: Esta função é geralmente chamada automaticamente pelo host (ex: Claude Desktop)
# através do comando: Rscript -e "mcptools::mcp_server()"

print("Iniciando servidor MCP de exemplo...")

# Para uso interativo e inspeção do ambiente global, o pacote 'btw' é recomendado:
# btw::btw_mcp_server()

# Exemplo de como registrar uma ferramenta personalizada no servidor:
# (Isso permite que a IA chame esta função específica no seu R)

#' Calcular Indicador de Vigilância Customizado
#' @param casos Número de casos notificados
#' @param populacao População da região
mcp_calcular_incidencia <- function(casos, populacao) {
  incidencia <- (casos / populacao) * 100000
  return(paste("A taxa de incidência é de", round(incidencia, 2), "por 100 mil hab."))
}

# No servidor MCP real, as funções exportadas seriam detectadas automaticamente
# se estiverem em um pacote ou registradas via mcptools.

message("Servidor configurado. Para conectar, configure o arquivo JSON do seu host MCP.")
