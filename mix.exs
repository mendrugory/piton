defmodule Piton.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :piton,
     version: @version,
     elixir: "~> 1.4",
     package: package(),
     description: "Run your Python algorithms in parallel and avoid the GIL",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: [main: "Piton", source_ref: "v#{@version}",
     source_url: "https://github.com/mendrugory/piton"]]
  end

  defp deps() do
    [{:erlport, "~> 0.9.8"},
    {:earmark, ">= 0.0.0", only: :dev},
    {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package() do
    %{licenses: ["MIT"],
      maintainers: ["Gonzalo Jiménez Fuentes"],
      links: %{"GitHub" => "https://github.com/mendrugory/piton"}}
  end
  
end
