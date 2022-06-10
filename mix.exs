defmodule Dart.MixProject do
  use Mix.Project

  def project do
    [
      app: :dart,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Dart, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.3"},
      {:gen_registry, "~> 1.1.0"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
