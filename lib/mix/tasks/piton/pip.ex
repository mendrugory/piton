defmodule Mix.Tasks.Piton.Pip do
  use Mix.Task

  @moduledoc """
  `Mix.Task` which will upgrade your Python pip.
  """

  @shortdoc "It will install python pip. The pip's full path has to be given as argument"
  def run(args) do
    case args do
      [pip_path | _] -> upgrade(pip_path)
      _ -> IO.puts("Argument error")
    end
  end

  defp upgrade(pip_path) do
    IO.puts("Upgrading pip: #{pip_path}...")
    System.cmd(pip_path, ["install", "--upgrade", "pip"])
    IO.puts("pip has been upgraded.")
  end
end
