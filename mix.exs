defmodule Piton.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :piton,
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:erlport, "~> 0.9.8"},
    {:earmark, ">= 0.0.0", only: :dev},
    {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
