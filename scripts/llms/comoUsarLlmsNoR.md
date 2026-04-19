# Usando LLMs no R

## Formas de usar LLMs no R

Há duas formas de usar LLMs no R. A primeira consiste em usar o LLM para nos ajudar a gerar o código, também chamado de "copilot". A segunda forma é solicitar que o LLM realize uma análise ou interpretação dos dados. Neste tutorial vamos utilizar o Gemini para exemplificar esses usos.

## Gemini

O Gemini é o LLM desenvolvido pelo Google. Para utilizá-lo no R, precisamos instalar o pacote gemini.R. Para instalar o pacote gemini.R, execute o seguinte comando:

```R
install.packages("gemini.R")
```

Em seguida, precisamos carregar o pacote e definir a chave de API. Para obter uma chave de API, acesse https://aistudio.google.com/api-keys. Para definir a chave de API, execute o seguinte comando:

```R
library(gemini.R)
setAPI("YOUR_API_KEY")
```

O uso básico do pacote é feito através da função gemini(). Para utilizá-la, execute o seguinte comando:

```R
gemini([seu prompt aqui])
```


