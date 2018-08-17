defmodule Piton.Mixfile do
  use Mix.Project

  @version "0.4.0"

  def project do
    [
      app: :piton,
      version: @version,
      elixir: "~> 1.7",
      package: package(),
      description: "Run your Python algorithms in parallel and avoid the GIL",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        source_ref: "v#{@version}",
        extras: ["README.md"],
        source_url: "https://github.com/mendrugory/piton"
      ]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps() do
    [
      {:erlport, "~> 0.10.0"},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:poison, ">= 0.0.0", only: :test}
    ]
  end

  defp package() do
    %{
      licenses: ["MIT"],
      maintainers: ["Gonzalo Jiménez Fuentes"],
      links: %{"GitHub" => "https://github.com/mendrugory/piton"}
    }
  end
end
