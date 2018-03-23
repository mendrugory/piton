defmodule Piton.PoolFunctions do
  @moduledoc false

  @doc """
  It receives a queue of Pythons and returns the first one and the new queue.

  Example:
  iex> queue = [1,2,3]
  [1, 2, 3]
  iex> dispatch_lifo(queue)
  {1, [2, 3, 4]}
  """
  def get_lifo([first | rest]), do: {first, rest}
  def get_lifo([]), do: {nil, []}

  @doc """
  It receives a queue of Pythons and returns the first one and the new queue.

  Example:
  iex> queue = [1,2,3]
  [1, 2, 3]
  iex> dispatch_lifo(queue)
  {1, [2, 3, 4]}
  """
  def push_lifo(item, queue), do: [item | queue]
end
