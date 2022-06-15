import Config

config :dart,
  port: String.to_integer(System.get_env("DART_PORT") || "7701"),
  tenor_key: System.get_env("DART_TENOR_APIKEY"),
  prefix: System.get_env("DART_BOT_PREFIX") || "!"

config :nostrum,
  token: System.get_env("DART_DISCORD_TOKEN")
