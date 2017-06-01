defmodule PitonTest do
  use ExUnit.Case
  doctest Piton

  test "My own Python Port" do
    defmodule MyPythonFibCalculator do
      use Piton.Port
      def start_link(), do: MyPythonFibCalculator.start_link([path: Path.expand("test/pythons_test"), python: "python"], [name: __MODULE__])
      def fib(n), do: MyPythonFibCalculator.execute(__MODULE__, :functions, :fib, [n])
    end
    {:ok, _} = MyPythonFibCalculator.start_link()
    result = MyPythonFibCalculator.fib(10)
    assert(result == 55)
  end


end
