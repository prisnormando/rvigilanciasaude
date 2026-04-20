if (FALSE) { # \dontrun{
library(gemini.R)

# For text content
key_file <- "YOURAPIKEY.json"
model <- "2.0-flash"
token_count_text <- countTokens(
  jsonkey = key_file,
  model_id = model,
  content = "Hello, world!"
)
print(token_count_text)

# For image content (assuming 'image.jpg' is in your working directory)
image_data <- base64enc::base64encode("image.jpg")
image_content <- list(data = image_data, mimeType = "image/jpeg")
token_count_image <- countTokens(
  jsonkey = key_file,
  model_id = model,
  content = image_content
)
print(token_count_image)

# For multiple content parts (text and image)
content_parts <- list(
  list(text = "This is the first part."),
  list(data = image_data, mimeType = "image/jpeg"),
  list(text = "This is the last part")
)
token_count_parts <- countTokens(
  jsonkey = key_file,
  model_id = model,
  content = content_parts
)
print(token_count_parts)
} # }

