defmodule CloudCloud.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cloud_cloud,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end


  # Configuration for the OTP application
  def application do
    [extra_applications: [:logger]]
  end


  # Dependencies can be Hex packages:
  defp deps do
    [

    ]
  end
end
