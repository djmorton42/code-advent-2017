defmodule Day4Part2 do

  def phrase_is_valid(pass_phrase) do
    elements = String.split(pass_phrase, " ")

    [head | tail] = elements

    !is_contained(head, tail, [])
  end

  def is_contained(element, other_elements_to_test, elements_seen) do
    sorted_element = sorted_graphemes(element)
    cond do
      Enum.member?(elements_seen, sorted_element) ->
        true
      List.first(other_elements_to_test) == nil ->
        false
      true ->
        [head | tail] = other_elements_to_test
        is_contained(head, tail, [sorted_element | elements_seen])
    end
  end

  def sorted_graphemes(string) do
    Enum.sort(String.graphemes(string))
  end

  def process_line(file, valid_phrase_total) do
    case IO.read(file, :line) do
    :eof ->
      valid_phrase_total
    data ->
      increment = cond do
        phrase_is_valid(String.trim(data, "\n")) ->
          1
        true ->
          0
      end

      process_line(file, valid_phrase_total + increment)
    end
  end
end

{:ok, file} = File.open("input.txt", [:read, :utf8])
try do
  IO.puts "Final Answer: " <> Integer.to_string(Day4Part2.process_line(file, 0))
after
  File.close(file)
end
