defmodule Cloud.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cloud,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end


  # Configuration for the OTP application
  def application do
    [extra_applications: [:logger],
     mod: {Cloud.Application, []}]
  end


  # Dependencies can be Hex packages:
  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.3"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.12.0"},
      {:socket, "~> 0.3.12"},

      {:distillery, "~> 1.4"}
    ]
  end
end
