defmodule SlidingWindow do
  @moduledoc """
  Example 1
  Input: [2, 1, 5, 1, 3, 2], k=3
  Output: 9
  Explanation: Subarray with maximum sum is [5, 1, 3]

  Example 2
  Input: [2, 3, 4, 1, 5], k=2
  Output: 7
  Explanation: Subarray with maximum sum is [3, 4].

  Run in terminal:
  - elixir 1._maximum_sum_subarray_of_size_k.exs --run
  - elixir 1._maximum_sum_subarray_of_size_k.exs --test
  """

  def maximum_sum_subarray(array, k) do
    chunked_array = Enum.chunk_every(array, k, 1, :discard)

    [result, _] =
      Enum.reduce(chunked_array, [0, 0], fn [head | _] = subarray, [result, common_sum] ->
        if result == 0 and common_sum == 0 do
          first_array_sum = Enum.sum(subarray)
          [result + first_array_sum, new_common_sum(first_array_sum, head)]
        else
          subarray_sum = common_sum + List.last(subarray)

          result = if subarray_sum > result, do: subarray_sum, else: result

          [
            result,
            new_common_sum(subarray_sum, head)
          ]
        end
      end)

    result
  end

  defp new_common_sum(array_sum, head), do: array_sum - head
end

case System.argv() do
  ["--run"] ->
    result = SlidingWindow.maximum_sum_subarray([2, 1, 5, 1, 3, 2], 3)
    IO.puts("Example 1: expected 9, got #{result}.")

    result = SlidingWindow.maximum_sum_subarray([2, 3, 4, 1, 5], 2)
    IO.puts("Example 2: expected 7, got #{result}.")

  ["--test"] ->
    ExUnit.start()

    defmodule SlidingWindowTest do
      use ExUnit.Case

      describe "SlidingWindow tests: slow and fast versions" do
        test "SUCCES: outputs from both functions are correct" do
          assert SlidingWindow.maximum_sum_subarray([2, 1, 5, 1, 3, 2], 3) == 9
          assert SlidingWindow.maximum_sum_subarray([2, 3, 4, 1, 5], 2) == 7
        end
      end
    end

  _ ->
    IO.puts(:stderr, "\nplease specify --run or --test")
end
