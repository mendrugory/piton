defmodule Piton.Port do
  @moduledoc"""
  `Piton.Port` is a `GenServer` which will be on charge of the Python Port.

  It is prepared to be the base of your own Port.

  ## Make your own Port
  ```elixir
  defmodule MyPort do
    use Piton.PythonPort
    # rest of the code if it is need.
  end
  ```
  The arguments has to be in a Keyword List and it has to contain:
       path: Path to the folder where the python scripts are.
       python: python executable

  If your port is going to run in a `Piton.Pool` (highly recommended) it has to have a *start()* function
  and it has not to be linked.

  ```elixir
  defmodule MyPoolPort do
    use Piton.Port
    def start(), do: MyPoolPort.start([path: Path.expand("python_folder"), python: "python"], [])
    def fun(pid, n), do: MyPoolPort.execute(pid, :functions, :fun, [n])
  end
  ```

  ## Run a Python code using directly the port (no pool)
  ```elixir
  iex> MyPort.execute(pid_of_the_port, python_module, python_function, list_of_arguments_of_python_function)
  ```
  """

  defmacro __using__(_) do
    quote do
      use GenServer

      @timeout          5000

      def start_link(args, opts) do
        GenServer.start_link(__MODULE__, args, opts)
      end

      def start(args, opts) do
        GenServer.start(__MODULE__, args, opts)
      end

      @doc """
      It will return the erl port
      """
      @spec get_port(pid) :: pid
      def get_port(pid), do: GenServer.call(pid, :get_python_port)

      @doc """
      It will execute the arguments in the given function of the given module using the given port.
      """
      @spec execute(pid, atom, atom, list, timeout) :: any
      def execute(pid, python_module, python_function, python_arguments, timeout \\ @timeout) do
        GenServer.call(pid, {:execute, python_module, python_function, python_arguments}, timeout)
      end

      def init([path: path, python: python]) do
        {:ok, py_port} = :python.start([{:python_path, to_char_list(path)}, {:python, to_char_list(python)}])
        Process.link(py_port)
        {:ok, %{py_port: py_port}}
      end

      def handle_call(:get_python_port, _from, state) do
        {:reply, state[:py_port], state}
      end

      def handle_call({:execute, python_module, python_function, python_arguments}, _from, state) do
        result = Piton.PythonFunctions.call(state[:py_port], python_module, python_function, python_arguments)
        {:reply, result, state}
      end

      def handle_cast(_msg, state) do
        {:noreply, state}
      end

      def handle_info(_msg, state) do
        {:noreply, state}
      end

    end
  end

end