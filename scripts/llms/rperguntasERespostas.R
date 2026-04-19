make_prompt <- function(query, relevant_passage) {
  escaped <- gsub("'", "", gsub('"', "", gsub("\n", " ", relevant_passage)))
  prompt <- sprintf("You are a helpful and informative bot that answers questions using text from the reference passage included below. \
  Be sure to respond in a complete sentence, being comprehensive, including all relevant background information. \
  However, you are talking to a non-technical audience, so be sure to break down complicated concepts and \
  strike a friendly and conversational tone. \
  If the passage is irrelevant to the answer, you may ignore it.
  QUESTION: '%s'
  PASSAGE: '%s'

    ANSWER:
  ", query, escaped)
  
  return(prompt)
}

passage <- "Title: Is AI a Threat to Content Writers?\n Author: Deepanshu Bhalla\nFull article:\n Both Open source and commercial generative AI models have made content writing easy and quick. Now you can create content in a few mins which used to take hours."