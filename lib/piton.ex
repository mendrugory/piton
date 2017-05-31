defmodule Piton do
  @moduledoc """
# Piton

 `Piton` is a library which will help you to run your Python code.

  You can implement your own `Piton.Port` and run your python code but I highly recommend to use `Piton.Pool`,
  a pool which will allow to run Python code in parallel, a way of avoiding the GIL, and it will protect you from
  python exceptions.

## Installation
  Add `piton` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:piton, "~> 0.1.0"}]
  end
  ```


## How to use it
  Define your own `port`

  * The Easiest one
  ```elixir
  defmodule MySimplePort do
    use Piton.Port
  end
  ```

  * A port with some wrapper functions which will help you to call the python function:
  *YOUR_MODULE.execute(pid, python_module, python_function, list_of_arguments)*
  ```elixir
  defmodule MyCustomPort do
    use Piton.Port
    def start_link(), do: MyCustomPort.start_link([path: Path.expand("python_folder"), python: "python"], [name: __MODULE__])
    def fun(n), do: MyCustomPort.execute(__MODULE__, :functions, :fun, [n])
  end
  ```

  * A port prepared to be run by `Piton.Pool`
  They have to have a function *start()* and it has not to be linked.
  ```elixir
  defmodule MyPoolPort do
    use Piton.Port
    def start(), do: MyPoolPort.start([path: Path.expand("python_folder"), python: "python"], [])
    def fun(n), do: MyPoolPort.execute(__MODULE__, :functions, :fun, [n])
  end
  ```

### Run a Pool
  Pay attention to the number of Pythons you want to run in parallel. It does not exist an optimal number, maybe it is the
  number of cores, maybe half or maybe double. Test it with your application.
      {:ok, pool} = Piton.Pool.start_link([module: MyPoolPort, pool_number: pool_number], [])

### Call a Port (No pool)
      MyCustomPort.execute(pid_of_the_port, python_module, python_function, list_of_arguments_of_python_function)


### Call a Pool
      Piton.Pool.execute(pid_of_the_pool, elixir_function, list_of_arguments_of_elixir_function)


## Test
  Run the tests.
  ```bash
  mix test
  ```

## Name
  Pitón is only Python in Spanish :stuck_out_tongue_winking_eye: :snake:

  """

end
