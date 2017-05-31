defmodule Piton.Pool do
  @moduledoc"""
  Piton.Pool is a `GenServer` which will be on charge of a pool of Python Ports.

  `args` arguments is a Keyword List and has to contain:
    * module: Module which has to `use Piton.Port`
    * pool_number: number of available Pythons.
  """

  @timeout          5000
  
  use GenServer
  alias Piton.PoolFunctions
  require Logger

  def start_link(args, opts) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @doc """
  It will execute the arguments in the given function of the given module using the given pool of ports.
  """
  def execute(pid, python_function, python_arguments, timeout \\ @timeout) do
    GenServer.call(pid, {:execute, python_function, python_arguments, timeout}, timeout)
  end

  @doc """
  It will return the number of available ports
  """
  def get_number_of_available_ports(pid), do: GenServer.call(pid, :number_of_available_ports)

  @doc """
  It will return the number of processes that are waiting for an available port
  """
  def get_number_of_waiting_processes(pid), do: GenServer.call(pid, :number_of_waiting_processes)

  def init([module: module, pool_number: pool_number]) do
    py_ports = for _ <- 1..pool_number, do: module.start() |> elem(1)
    Enum.each(py_ports, fn py_port -> Process.monitor(py_port) end)
    {:ok, %{py_ports: py_ports, waiting_processes: [], module: module}}
  end

  def handle_call({:execute, python_function, python_arguments, timeout}, from, %{py_ports: py_ports, waiting_processes: waiting_processes, module: module}) do
    pool = self()
    case PoolFunctions.get_lifo(py_ports) do
      {nil, new_py_ports} ->
        new_waiting = {module, python_function, python_arguments, from, pool, timeout}
        {:noreply, %{py_ports: new_py_ports, waiting_processes: [new_waiting | waiting_processes], module: module}}
      {py_port, new_py_ports} ->
        Task.start(fn -> run({py_port, module, python_function, python_arguments, from, pool, timeout}) end)
        {:noreply, %{py_ports: new_py_ports, waiting_processes: waiting_processes, module: module}}
    end
  end

  def handle_call(:number_of_available_ports, _from, state) do
    {:reply, length(state[:py_ports]), state}
  end

  def handle_call(:number_of_waiting_processes, _from, state) do
    {:reply, length(state[:waiting_processes]), state}
  end

  def handle_cast({:return_py_port, py_port}, %{py_ports: py_ports, waiting_processes: waiting_processes} = state) do
    {new_py_ports, new_waiting_processes} = check_and_run_waiting_process(py_port, py_ports, waiting_processes)
    {:noreply, %{state | py_ports: new_py_ports, waiting_processes: new_waiting_processes}}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _msg}, %{py_ports: py_ports, module: module, waiting_processes: waiting_processes} = state) do
    py_port = module.start() |> elem(1)
    Process.monitor(py_port)
    {new_py_ports, new_waiting_processes} = check_and_run_waiting_process(py_port, py_ports, waiting_processes)
    {:noreply, %{state | py_ports: new_py_ports, waiting_processes: new_waiting_processes}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp run({py_port, python_module, python_function, python_arguments, from, pool, timeout}) do
    try do
      result = apply(python_module, python_function, [py_port] ++ python_arguments ++ [timeout])
      GenServer.reply(from, {:ok, result})
      GenServer.cast(pool, {:return_py_port, py_port})
    catch
      :exit, msg ->
        Logger.error("Catched error during running a task in Piton.Pool: Exit !!")
        GenServer.reply(from, {:error, msg})
    end
  end

  defp check_and_run_waiting_process(new_py_port, py_ports, []) do
    {PoolFunctions.push_lifo(new_py_port, py_ports), []}
  end

  defp check_and_run_waiting_process(new_py_port, py_ports, waiting_processes) do
    [waiting_process | new_waiting_processes] = waiting_processes
    Task.start(fn -> run(Tuple.insert_at(waiting_process, 0, new_py_port)) end)
    {py_ports, new_waiting_processes}
  end
end