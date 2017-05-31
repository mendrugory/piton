defmodule Mix.Tasks.Piton.Venv do
  use Mix.Task
  @moduledoc """
  `Mix.Task` which will create a Python Virtual Environment.

  [virtualenv](https://virtualenv.pypa.io) has to be installed in your computer.
  """


  @shortdoc "It creates a python virtual environment. First argument path, second argument python interpreter"
  def run(args) do
    full_path = args |> List.first() |> Path.expand()
    case args do
      [_path] -> venv_creation([full_path])
      [_path, python] -> venv_creation(["-p", python, full_path])
      _ -> IO.puts "Wrong number of arguments. It can be 1 or 2. The first one has to be the folder and the second one the python interpreter."
    end
  end

  defp venv_creation(arguments) do
    IO.puts "Creating a Python Virtual environment at #{List.last(arguments)}..."
    System.cmd("virtualenv", arguments)
    IO.puts "Virtual Environment created."
  end
  
end