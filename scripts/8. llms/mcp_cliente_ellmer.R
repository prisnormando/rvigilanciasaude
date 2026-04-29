# -------------------------------------------------------------------------
# Exemplo de R como Cliente MCP usando o pacote 'ellmer'
# -------------------------------------------------------------------------
# O pacote 'ellmer' permite que o R converse com LLMs (Gemini, Claude, GPT)
# e use ferramentas externas (tools) via protocolo MCP.

# 1. Instalação
# install.packages("ellmer")
# install.packages("mcptools")

library(ellmer)
library(mcptools)

# 2. Configurando o Chat com Gemini (Exemplo)
# Certifique-se de que sua API KEY do Google Gemini está configurada no .Renviron
# Sys.setenv(GEMINI_API_KEY = "SUA_CHAVE_AQUI")

chat <- chat_gemini(
  system_prompt = "Você é um assistente especialista em vigilância epidemiológica no Brasil."
)

# 3. Integrando ferramentas MCP
# Suponha que você tenha um servidor MCP rodando localmente (ex: busca em arquivos)
# ou quer usar ferramentas que o mcptools disponibiliza.

# Exemplo: Registrar ferramentas de um servidor MCP externo no seu chat do R
# mcp_tools <- mcp_client_tools("caminho/para/config_do_servidor.json")
# chat$register_tools(mcp_tools)

# 4. Interação
# Agora, ao fazer uma pergunta, a IA pode decidir usar as ferramentas do R
# ou do servidor MCP externo para responder.

# resposta <- chat$chat("Analise os dados de dengue na pasta dados e me dê um resumo.")
# print(resposta)

message("Exemplo de cliente MCP carregado. Configure suas chaves de API para testar a integração.")
