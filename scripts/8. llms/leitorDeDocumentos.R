library(gemini.R)

gemini_docs(
  c("doc1.pdf", "doc2.pdf"),
  prompt = "Faça um parágrafo com a descrição de cada documento. Coloque o nome do arquivo no início do parágrafo."
)
