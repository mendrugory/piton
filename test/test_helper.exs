defmodule MyPort do
  use Piton.Port
end

defmodule MyPythonFibCalculator do
  use Piton.Port
  @timeout        5000
  def start(), do: MyPythonFibCalculator.start([path: Path.expand("test/pythons_test"), python: "python3"], [])
  def fib(python, n, timeout \\ @timeout), do: MyPythonFibCalculator.execute(python, :functions, :fib, [n], timeout)
  def fib_delay(python, n, delay, timeout \\ @timeout) do
    Process.sleep(delay)
    MyPythonFibCalculator.execute(python, :functions, :fib, [n], timeout)
  end
end

ExUnit.start()
