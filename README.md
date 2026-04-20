# R para Vigilância em Saúde e IA Generativa: Um Guia do Zero ao Profissional

![Status](https://img.shields.io/badge/Status-Concluído-success)
![Linguagem](https://img.shields.io/badge/Linguagem-R-blue)
![Público](https://img.shields.io/badge/Público-Vigilância_Sanitária-orange)

Bem-vindo ao repositório oficial do guia **R para Vigilância em Saúde e IA Generativa**. Este material foi desenvolvido com foco nas melhores práticas em R e tem como público-alvo estudantes e profissionais de vigilância sanitária e saúde pública. 

O objetivo principal deste repositório é ensinar a linguagem R aplicada à vigilância sanitária, utilizando a Inteligência Artificial (restrita e generativa) como uma aliada poderosa na análise de dados e na tomada de decisão. Ao longo deste repositório, você aprenderá a construir um **boletim epidemiológico real sobre a incidência de dengue e a influência das ilhas de calor no município de Belo Horizonte (MG)**.

---

## 📑 Estrutura do Repositório

O repositório está organizado de forma didática, acompanhando as cinco partes do e-book original. Cada parte possui seus respectivos scripts R para que você possa praticar e aplicar os conceitos.

```text
R-Vigilancia-Saude-IA/
│
├── README.md                      # Este arquivo com as instruções gerais
├── dados/                         # Diretório para armazenar os arquivos de dados (CSV, etc.)
├── shapefiles/                    # Diretório para armazenar os arquivos geoespaciais (.shp)
└── scripts/                       # Diretório contendo os códigos R separados por módulo
    ├── parte1/
    │   └── 01_fundamentos_r.R     # Fundamentos essenciais do R
    ├── parte2/
    │   └── 02_manipulacao_dados.R # Manipulação e visualização com tidyverse
    ├── parte3/
    │   └── 03_analise_espacial.R  # Análise epidemiológica e espacial com sf
    ├── parte4/
    │   └── 04_ia_modelos.R        # IA restrita e modelos preditivos com tidymodels
    └── parte5/
        └── 05_boletim.Rmd         # Projeto final: Boletim automatizado em R Markdown
```

---

## 🚀 Como Começar

Siga os passos abaixo para configurar o seu ambiente e começar a praticar:

### 1. Pré-requisitos

Para executar os scripts deste repositório, você precisará ter instalado em sua máquina:
- **R**: O "motor" que realiza os cálculos estatísticos [1]. Você pode baixá-lo em [CRAN](https://cran.r-project.org/).
- **RStudio**: O ambiente de desenvolvimento integrado (IDE) que facilita a escrita e visualização do código. Faça o download em [Posit](https://posit.co/download/rstudio-desktop/).

### 2. Clonando o Repositório

Faça o clone deste repositório para o seu computador local utilizando o Git:

```bash
git clone https://github.com/SEU-USUARIO/R-Vigilancia-Saude-IA.git
cd R-Vigilancia-Saude-IA
```

### 3. Instalando os Pacotes Necessários

A maioria dos scripts depende de um conjunto de pacotes essenciais para ciência de dados e análise espacial em R. Abra o RStudio e execute o seguinte comando no console para instalar todos de uma vez:

```r
install.packages(c("tidyverse", "sf", "tmap", "tidymodels", "rmarkdown", "lubridate"))
```

### 4. Executando os Scripts

Recomendamos que você siga a ordem lógica de aprendizado, abrindo e executando os scripts sequencialmente:

1.  **Parte I (`scripts/parte1/01_fundamentos_r.R`):** Comece por aqui para entender a sintaxe básica, variáveis e operações matemáticas fundamentais no R.
2.  **Parte II (`scripts/parte2/02_manipulacao_dados.R`):** Mergulhe no pacote `tidyverse`. Aqui você aprenderá a limpar dados de saúde (como os do SINAN) e a criar gráficos incríveis com o `ggplot2`.
3.  **Parte III (`scripts/parte3/03_analise_espacial.R`):** Avance para o cálculo de indicadores epidemiológicos e a criação de mapas temáticos (coropléticos) para entender a distribuição espacial das doenças.
4.  **Parte IV (`scripts/parte4/04_ia_modelos_preditivos.R`):** Descubra como a Inteligência Artificial restrita pode ajudar a prever surtos criando modelos de regressão com o `tidymodels`. Além disso, o e-book aborda como usar IA generativa (ChatGPT, Gemini) para criar *prompts* e acelerar seu código.
5.  **Parte V (`scripts/parte5/05_boletim_epidemiologico.Rmd`):** Junte todo o conhecimento e gere um relatório dinâmico em HTML ou PDF, automatizando a criação de um boletim epidemiológico completo.

---

## 🧠 Integração com Inteligência Artificial

Um dos diferenciais deste material é a integração da IA no fluxo de trabalho do epidemiologista. 

**IA Generativa como Copiloto:**
Você pode usar ferramentas como ChatGPT, Claude ou Gemini para:
- Gerar ou explicar trechos complexos de código R.
- Redigir interpretações técnicas dos resultados estatísticos.
- Exemplo de Prompt: *"Atue como um especialista em R e análise espacial. Escreva o código utilizando o pacote `tmap` para criar um mapa coroplético mostrando a taxa de incidência de dengue por bairro, utilizando uma paleta de cores 'Reds'."*

**IA Restrita (Machine Learning):**
No script da Parte IV, você encontrará uma introdução prática ao uso de modelos preditivos no R para estimar o risco de surtos com base em variáveis climáticas (ilhas de calor) e sociais (Índice de Vulnerabilidade Social).

---

## 📊 Fontes de Dados Recomendadas

Para enriquecer suas análises e praticar com dados reais, recomendamos as seguintes fontes abertas [2] [3]:

- **SINAN (Sistema de Informação de Agravos de Notificação):** [OpenDataSUS](https://opendatasus.saude.gov.br/)
- **BR-DWGD (Dados Climáticos em Grade):** [Repositório BR-DWGD](https://sites.google.com/site/alexandrecandidoxavierufes/brazilian-daily-weather-gridded-data)
- **Índice de Vulnerabilidade Social (IPEA):** [Plataforma IVS](https://ivs.ipea.gov.br/#/)
- **IBGE:** Dados demográficos e malhas territoriais (shapefiles).

---

## 🤝 Materiais de Apoio

- **Agente Instrutor de Linguagem R para Vigilância em Saúde:**[R Language for Health Surveillance Instructor](https://gemini.google.com/gem/1m4xUozFZUaBNlRl20rgmq7HbXLKVZXmZ?usp=sharing)

- **Vídeos do curso básico de R:** [R BMClima](https://youtube.com/playlist?list=PLczEXt1zhB1Rn7BVa6SaV-KtCDL-Cecyc&si=TaLBtE08dKR9j1qo)

- **Kaggle R Collection:** [Kaggle R Collection](https://www.kaggle.com/learn-guide/r)


---

## 📚 Referências

[1] R Core Team. R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. 2023. Disponível em: https://www.R-project.org/
[2] Xavier, A. C. Brazilian Daily Weather Gridded Data (BR-DWGD). 
[3] IPEA. Índice de Vulnerabilidade Social.
[4] [EpiRHandBook](https://epirhandbook.com/pt/index.pt.html)


