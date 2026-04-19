library(gemini.R)
gemini_audio.vertex(
  audio = "YOUR_AUDIO_FILE",
  prompt = "Describe this audio",
  tokens = NULL,
  temperature = 1,
  maxOutputTokens = 8192,
  topK = 40,
  topP = 0.95,
  seed = 1234
)