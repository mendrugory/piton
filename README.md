# Piton

[![hex.pm](https://img.shields.io/hexpm/v/piton.svg?style=flat-square)](https://hex.pm/packages/piton) [![hexdocs.pm](https://img.shields.io/badge/docs-latest-green.svg?style=flat-square)](https://hexdocs.pm/piton/) [![CI](https://github.com/mendrugory/piton/workflows/CI/badge.svg)](https://github.com/mendrugory/piton/actions) [![Publish](https://github.com/mendrugory/piton/workflows/Publish%20to%20Hex.pm/badge.svg)](https://github.com/mendrugory/piton/actions)

 `Piton` is a library which will help you to run your Python code. 

  You can implement your own `Piton.Port` and run your python code but I highly recommend to use `Piton.Pool`, 
  a pool which will allow to run Python code in parallel, a way of avoiding the GIL, and it will protect you from 
  python exceptions.

## Requirements

  * Elixir ~> 1.19
  * Python 3.x
  * Erlang/OTP 27

## Installation
  Add `piton` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:piton, "~> 0.5.0"}]
  end
  ```
    

## How to use it
  Define your own port
  
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
    def fun(pid, n), do: MyPoolPort.execute(pid, :functions, :fun, [n])
  end
  ```
  
### Run a Pool
  Pay attention to the number of Pythons you want to run in parallel. It does not exist an optimal number, maybe it is the
  number of cores, maybe half or maybe double. Test it with your application.
  ```elixir
  {:ok, pool} = Piton.Pool.start_link([module: MyPoolPort, pool_number: pool_number], [])
  ```
### Call a Port (No pool)
  ```elixir
  iex> MyCustomPort.execute(pid_of_the_port, python_module, python_function, list_of_arguments_of_python_function)
  ```

### Call a Pool
  ```elixir
  iex> Piton.Pool.execute(pid_of_the_pool, elixir_function, list_of_arguments_of_elixir_function)
  ```
  
## Tasks
  Some `Mix.Tasks` have been included in order to facilitate the integration of a python project
  
  * `Mix.Tasks.Piton.Venv`: It creates a Python Virtual Environment.
  * `Mix.Tasks.Piton.Pip`: It upgrades the Python pip.
  * `Mix.Tasks.Piton.Requirements`: It gets the dependencies of the Python project.
  
## Test
  
  Before running tests, create a Python virtual environment:
  ```bash
  python3 -m venv test/venv
  ```
  
  Then run the tests:
  ```bash
  mix test 
  ```

## CI/CD

This project uses GitHub Actions for continuous integration and deployment:

### Continuous Integration (CI)

Every push and pull request triggers automated tests.

**Workflow**: `.github/workflows/ci.yml`

The CI workflow:
- ✅ Runs on Elixir 1.19.2 and OTP 27.1
- ✅ Compiles code with warnings as errors
- ✅ Runs full test suite
- ✅ Checks code formatting
- ✅ Caches dependencies for faster builds

**Triggers**: All branches on push and all pull requests

### Automatic Publishing to Hex.pm

When you create a new GitHub release, the package is automatically published to [Hex.pm](https://hex.pm/packages/piton).

**Workflow**: `.github/workflows/publish.yml`

The workflow:
- ✅ Runs on Elixir 1.19.2 and OTP 27.1
- ✅ Installs dependencies with caching
- ✅ Runs tests before publishing
- ✅ Automatically publishes to Hex.pm on release

**To publish a new version:**
1. Update the version in `mix.exs`
2. Update `CHANGELOG.md` with changes
3. Commit and push changes
4. Create a new GitHub release (e.g., `v0.5.0`)
5. The package will be automatically published to Hex.pm

**Required Secret**: `HEX_KEY` - Your Hex.pm API key must be added to GitHub repository secrets.
  
## Name
  Pitón is only Python in Spanish :stuck_out_tongue_winking_eye: :snake:
