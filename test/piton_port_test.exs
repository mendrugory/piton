defmodule PitonPortTest do
  use ExUnit.Case
  

  test "Generic Port. Python Fib function" do
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    result = MyPort.execute(python_port, :functions, :fib, [10])
    assert(result == 89)
  end

  test "Generic Port. Multiple Python Fib function through Piton" do
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    results = for i <- 1..20, do: MyPort.execute(python_port, :functions, :fib, [i])
    assert(results == [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946])
  end

  test "Generic Port. Python Fib function string module" do
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    result = MyPort.execute(python_port, "functions", :fib, [10])
    assert(result == 89)
  end

  test "Generic Port. Python Fib function string function" do
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    result = MyPort.execute(python_port, :functions, "fib", [10])
    assert(result == 89)
  end

  test "Generic Port. Python Fib function string module and function" do
    {:ok, python_port} = MyPort.start([path: Path.expand("test/pythons_test"), python: "python"], [])
    result = MyPort.execute(python_port, "functions", "fib", [10])
    assert(result == 89)
  end

end
