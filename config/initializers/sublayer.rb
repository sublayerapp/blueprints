# Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
# Sublayer.configuration.ai_model = "claude-3-haiku-20240307"

if Rails.configuration.ai_provider == "google"
  Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
  Sublayer.configuration.ai_model = "gemini-1.5-flash-latest"
else
  Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
  Sublayer.configuration.ai_model = "gpt-4o"
end
