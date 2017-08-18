defmodule PitonPortTest do
  use ExUnit.Case
  alias Poison
  

  test "Generic Port. Python Fib function" do
    IO.puts "Running test: Generic Port. Python Fib function ..."
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    result = MyPort.execute(python_port, :functions, :fib, [10])
    assert(result == 55)
  end

  test "Generic Port. Multiple Python Fib function through Piton" do
    IO.puts "Running test: Generic Port. Multiple Python Fib function through Piton ..."
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    results = for i <- 1..20, do: MyPort.execute(python_port, :functions, :fib, [i])
    assert(results == [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765])
  end

  test "Generic Port. Python Fib function string module" do
    IO.puts "Running test: Generic Port. Python Fib function string module Piton ..."
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    result = MyPort.execute(python_port, "functions", :fib, [10])
    assert(result == 55)
  end

  test "Generic Port. Python Fib function string function" do
    IO.puts "Running test: Generic Port. Python Fib function string function ..."
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    result = MyPort.execute(python_port, :functions, "fib", [10])
    assert(result == 55)
  end

  test "Generic Port. Python Fib function string module and function" do
    IO.puts "Running test: Generic Port. Python Fib function string module and function ..."
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    result = MyPort.execute(python_port, "functions", "fib", [10])
    assert(result == 55)
  end

  test "Generic Port. Python Fib function string module and function sending a json" do
    IO.puts "Running test: Generic Port. Python Fib function string module and function sending a json ..."
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    json_result = MyPort.execute(python_port, "functions", "json_fib", [Poison.encode!(%{message: "Fib Json", number: 10})])
    result = Poison.decode!(json_result) |> Map.get("result")
    assert(result == 55)
  end


end
