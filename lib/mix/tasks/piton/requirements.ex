defmodule Mix.Tasks.Piton.Requirements do
  use Mix.Task
  @moduledoc """
  `Mix.Task` which will get the dependencies of your Python project
  """

  @shortdoc "It will will get the dependencies of your Python project. The pip's full path and the requirements.txt path have to be given as 1st and 2nd arguments"
  def run(args) do
    case args do
      [pip_path, requirements_path] -> get_requirements(pip_path, requirements_path)
      _ -> IO.puts "Wrong number of arguments. It can be 1 or 2. The first one has to be the folder and the second one the python interpreter."
    end
  end

  defp get_requirements(pip_path, requirements_path) do
    IO.puts "Getting the dependencies..."
    System.cmd(pip_path, ["install", "-r", requirements_path])
    IO.puts "Done"
  end
  
end