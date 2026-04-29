# -------------------------------------------------------------------------
# Guia de Configuração do Host MCP (fora do R)
# -------------------------------------------------------------------------
# Para que sua IA (Claude Desktop, por exemplo) encontre seu servidor R,
# você deve editar o arquivo de configuração do host.

# --- Localização do arquivo (Claude Desktop) ---
# Windows: %APPDATA%/Claude/claude_desktop_config.json
# macOS: ~/Library/Application Support/Claude/claude_desktop_config.json

# --- Conteúdo para adicionar à seção "mcpServers": ---

# {
#   "mcpServers": {
#     "r-vigilancia": {
#       "command": "Rscript",
#       "args": [
#         "-e",
#         "mcptools::mcp_server()"
#       ],
#       "env": {
#         "R_LIBS_USER": "/caminho/para/seus/pacotes"
#       }
#     }
#   }
# }

# --- Explicação ---
# 1. "command": Deve ser o executável do R (Rscript).
# 2. "args": Comando que inicia o servidor via mcptools.
# 3. "env": (Opcional) Se o Rscript não encontrar seus pacotes instalados,
#    adicione o caminho das bibliotecas.

message("Este script é apenas informativo. Siga os comentários para configurar seu host MCP.")
