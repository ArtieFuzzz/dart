import Config

config :dart,
  port: String.to_integer(System.get_env("DART_PORT") || "7701")
