# R para Vigilância em Saúde com IA Generativa  

![Status](https://img.shields.io/badge/Status-Concluído-success)
![Linguagem](https://img.shields.io/badge/Linguagem-R-blue)
![Público](https://img.shields.io/badge/Público-Vigilância_Sanitária-orange)

Bem-vindo ao repositório oficial do guia **R para Vigilância em Saúde e IA Generativa**. Este material foi desenvolvido com foco nas melhores práticas em R e tem como público-alvo estudantes e profissionais de vigilância em saúde. 

O objetivo deste repositório é ensinar a linguagem R aplicada à vigilância em saúde, utilizando a Inteligência Artificial (restrita e generativa) como uma aliada poderosa na análise de dados e na tomada de decisão. 

---

## 📑 Estrutura do Repositório

O repositório está organizado de forma a acompanhar as etapas de um projeto de vigilância em saúde.

```text
R-Vigilancia-Saude-IA/
│
├── README.md                      # Este arquivo com as instruções gerais
├── ebooks/                        # Diretório contendo os e-books e tutoriais  
├── dados/                         # Diretório para armazenar os arquivos de dados (CSV, etc.)
├── shapefiles/                    # Diretório para armazenar os arquivos geoespaciais (.shp)
└── scripts/                       # Diretório contendo os códigos R separados por módulo
```

---

## 🚀 Como Começar

Siga os passos abaixo para configurar o seu ambiente e começar a praticar:

### 1. Pré-requisitos

Para executar os scripts deste repositório localmente, você precisará ter instalado em sua máquina:
- **R**: O "motor" que realiza os cálculos estatísticos [1]. Você pode baixá-lo em [CRAN](https://cran.r-project.org/).
- **RStudio**: O ambiente de desenvolvimento integrado (IDE) que facilita a escrita e visualização do código. Faça o download em [Posit](https://posit.co/download/rstudio-desktop/).

Para executar os scripts deste repositório em nuvem, você possui duas opções:
- **Google Colab**: [Google Colab](https://colab.research.google.com/)
- **Posit Cloud**: [Posit Cloud](https://posit.cloud/)

### 2. Clonando o Repositório

Faça o clone deste repositório para o seu computador local utilizando o Git:

```bash
git clone https://github.com/prisnormando/rvigilanciasaude/
cd rvigilanciasaude
```
Você também pode usar as opções de download do GitHub para baixar o repositório como um arquivo zip ou usar o importador da Nuvem da Posit ou do Google Colab. As duas últimas opções são recomendadas para quem está utilizando as ferramentas em nuvem (Colab ou Posit).

Para usar o Google Colab, lembre-se de configurar o ambiente de execução para R. Para isso, clique em "Ambiente de execução" -> "Alterar tipo de ambiente de execução" e selecione "R". Recomento fortemente que os códigos sejam executados célula a célula, para que você possa acompanhar o fluxo de execução e identificar erros mais facilmente.

### 3. Instalando os Pacotes Necessários

A maioria dos scripts depende de um conjunto de pacotes essenciais para ciência de dados e análise espacial em R:

```r
install.packages(c("tidyverse", "sf", "tmap", "tidymodels", "rmarkdown", "lubridate"))
```

### 4. Executando os Scripts

Recomendamos que você siga a ordem lógica de aprendizado, abrindo e executando os scripts sequencialmente, conforme ambiente de desenvolvimento escolhido (local, Colab ou Posit Cloud) e númeração das pastas. Para se guiar utilize o asquivos disponíveis na pasta ebooks e o notebook disponível na pasta 11. projetoFinal.

---

## 🧠 Integração com Inteligência Artificial

Um dos diferenciais deste material é a integração da IA no fluxo de trabalho do epidemiologista. 

**IA Generativa como Copiloto:**
Você pode usar ferramentas como ChatGPT, Claude ou Gemini para:
- Gerar ou explicar trechos complexos de código R.
- Redigir interpretações técnicas dos resultados estatísticos.
- Exemplo de Prompt: *"Atue como um especialista em R e análise espacial. Escreva o código utilizando o pacote `tmap` para criar um mapa coroplético mostrando a taxa de incidência de dengue por bairro, utilizando uma paleta de cores 'Reds'."*

Recomendo o uso do agente do Gemini disponível em: https://gemini.google.com/gem/1m4xUozFZUaBNlRl20rgmq7HbXLKVZXmZ?usp=sharing. De forma alternativa você pode usar as instruções disponíveis no arquivo comoUsarLlmsNoR.md disponível na pasta ebooks em conjunto com os scripts disponíveis na pasta 8. llms.


**IA Restrita (Machine Learning):**
Na pasta 9. modelagem, você encontrará uma introdução prática ao uso de modelos preditivos no R para estimar o risco de surtos com base em variáveis climáticas (ilhas de calor) e sociais (Índice de Vulnerabilidade Social).

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


