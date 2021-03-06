import Config

config :dart,
  port: String.to_integer(System.get_env("DART_PORT") || "7701"),
  tenor_key: System.get_env("DART_TENOR_APIKEY"),
  redis_uri: System.get_env("DART_REDIS_URI"),
  mongo_uri: System.get_env("DART_MONGO_URI")
