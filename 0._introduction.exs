defmodule SlidingWindow do
  @moduledoc """
  Given an array, find the average of all contiguous subarrays of size ‘K’ in it.
  INPUT: array = [1, 3, 2, 6, -1, 4, 1, 8, 2], k = 5
  Output: [2.2, 2.8, 2.4, 3.6, 2.8]

  Run in terminal:
  - elixir 0._introduction.ex --slow_version
  - elixir 0._introduction.ex --fast_version
  - elixir 0._introduction.ex --test
  """

  ### SLOW ###
  def find_averages_of_subarrays_slow(array, k),
    do: do_find_averages_of_subarrays_slow(array, k, [])

  def do_find_averages_of_subarrays_slow(array, k, acc) when length(array) < k,
    do: acc |> Enum.reverse()

  def do_find_averages_of_subarrays_slow([_head | tail] = array, k, acc) do
    subarray_sum =
      array
      |> Enum.slice(0, 5)
      |> Enum.reduce(0, &(&1 + &2))

    acc = [count_average(subarray_sum) | acc]

    do_find_averages_of_subarrays_slow(tail, k, acc)
  end

  ### FAST ###
  def find_averages_of_subarrays_fast(array, k) do
    chunked_array = Enum.chunk_every(array, k, 1, :discard)

    [result, _] =
      Enum.reduce(chunked_array, [[], 0], fn [head | _] = subarray, [result, common_sum] ->
        if result == [] and common_sum == 0 do
          first_array_sum = Enum.sum(subarray)
          [[count_average(first_array_sum) | result], new_common_sum(first_array_sum, head)]
        else
          subarray_sum = common_sum + List.last(subarray)

          [
            [count_average(subarray_sum) | result],
            new_common_sum(subarray_sum, head)
          ]
        end
      end)

    result |> Enum.reverse()
  end

  defp count_average(sum), do: sum / 5

  defp new_common_sum(array_sum, head), do: array_sum - head
end

case System.argv() do
  ["--slow_version"] ->
    result = SlidingWindow.find_averages_of_subarrays_slow([1, 3, 2, 6, -1, 4, 1, 8, 2], 5)

    IO.puts(
      "SLOW VERSION: expected #{inspect([2.2, 2.8, 2.4, 3.6, 2.8])}, got #{inspect(result)}."
    )

  ["--fast_version"] ->
    result = SlidingWindow.find_averages_of_subarrays_fast([1, 3, 2, 6, -1, 4, 1, 8, 2], 5)

    IO.puts(
      "FAST VERSION: expected #{inspect([2.2, 2.8, 2.4, 3.6, 2.8])}, got #{inspect(result)}."
    )

  ["--test"] ->
    ExUnit.start()

    defmodule SlidingWindowTest do
      use ExUnit.Case

      describe "SlidingWindow tests: slow and fast versions" do
        setup do
          input_array = [1, 3, 2, 6, -1, 4, 1, 8, 2]
          k = 5
          output = [2.2, 2.8, 2.4, 3.6, 2.8]

          %{input_array: input_array, k: k, output: output}
        end

        test "SUCCES: outputs from both functions are correct", %{
          input_array: input_array,
          k: k,
          output: output
        } do
          all_averages_of_subarrays = fn input_array, k ->
            [
              SlidingWindow.find_averages_of_subarrays_slow(input_array, k),
              SlidingWindow.find_averages_of_subarrays_fast(input_array, k)
            ]
          end

          assert [output, output] ==
                   all_averages_of_subarrays.(input_array, k)
        end
      end
    end

  _ ->
    IO.puts(:stderr, "\nplease specify --slow_version, --fast_version --test")
end
