defmodule Day2Part2 do

  def calculate_value(line) do
    number_list = Enum.map(String.split(line, "\t"), fn x -> String.to_integer(x) end)
    find_divisible_result(number_list)
  end

  def find_divisible_result(list) do
    [head | tail] = list
    divisor = find_suitable_divisor(head, tail)
    cond do
      divisor == nil ->
        find_divisible_result(tail ++ [head])
      true ->
        Integer.floor_div(head, divisor)
    end
  end

  def find_suitable_divisor(dividend, candidate_divisors) do
    cond do
      List.first(candidate_divisors) == nil ->
        nil
      true ->
        [head | tail] = candidate_divisors
        cond do
          is_evenly_divisible(dividend, head) ->
            head
          true ->
            find_suitable_divisor(dividend, tail)
        end
    end
  end

  def is_evenly_divisible(dividend, divisor) do
    Integer.mod(dividend, divisor) == 0
  end

  def process_line(file, checksum_total) do
    case IO.read(file, :line) do
    :eof ->
      checksum_total
    data ->
      calculate_value(String.trim(data, "\n")) + process_line(file, checksum_total)
    end
  end
end

{:ok, file} = File.open("input.txt", [:read, :utf8])
try do
  IO.puts "Final Answer: " <> Integer.to_string(Day2Part2.process_line(file, 0))
after
  File.close(file)
end
