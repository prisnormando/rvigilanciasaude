library(gemini.R)
setAPI("YOUR_API_KEY")

gemini_audio(
  audio = "YOUR_AUDIO_FILE",
  prompt = "Describe this audio",
  model = "2.0-flash",
  temperature = 1,
  maxOutputTokens = 8192,
  topK = 40,
  topP = 0.95,
  seed = 1234
)

