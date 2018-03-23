defmodule Piton.PythonFunctions do
  @moduledoc false

  @doc """
  It calls a python function which belongs to a given python module and it will use a given python port.

  Arguments has to be a Keyword list (default [])
  """
  def call(python_port, python_module, python_function, arguments \\ [])

  def call(python_port, python_module, python_function, arguments)
      when is_binary(python_module) do
    call(python_port, String.to_atom(python_module), python_function, arguments)
  end

  def call(python_port, python_module, python_function, arguments)
      when is_binary(python_function) do
    call(python_port, python_module, String.to_atom(python_function), arguments)
  end

  def call(python_port, python_module, python_function, arguments) do
    :python.call(python_port, python_module, python_function, arguments)
  end
end
