library(gemini.R)
setAPI("YOUR_API_KEY")

gemini_chat(
  prompt,
  history = list(),
  model = "2.0-flash",
  temperature = 1,
  maxOutputTokens = 8192,
  topK = 40,
  topP = 0.95,
  seed = 1234
)


chats <- gemini_chat("Pretend you're a snowman and stay in character for each")
print(chats$outputs)

chats <- gemini_chat("What's your favorite season of the year?", chats$history)
print(chats$outputs)

chats <- gemini_chat("How do you think about summer?", chats$history)
print(chats$outputs)
} # }
