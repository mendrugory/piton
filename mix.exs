defmodule Piton.Mixfile do
  use Mix.Project

  @version "0.5.0"

  def project do
    [
      app: :piton,
      version: @version,
      elixir: "~> 1.19",
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
      {:erlport, "~> 0.11.0"},
      {:earmark, "~> 1.4", only: :dev, runtime: false},
      {:ex_doc, "~> 0.39.1", only: :dev, runtime: false}
    ]
  end

  defp package() do
    %{
      licenses: ["MIT"],
      maintainers: ["Mendrugory"],
      links: %{"GitHub" => "https://github.com/mendrugory/piton"}
    }
  end
end
