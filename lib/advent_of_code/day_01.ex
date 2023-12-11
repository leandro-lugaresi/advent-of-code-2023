defmodule SimpleParser do
  defguardp is_digit(char) when char in ?0..?9

  def next_number(<<char::utf8, rest::binary>>) when is_digit(char) do
    {:ok, char - ?0, rest}
  end

  def next_number(<<_, rest::binary>>) do
    next_number(rest)
  end

  def next_number(<<>>) do
    {:error, :number_not_found}
  end
end

defmodule AdvancedParser do
  defguardp is_digit(char) when char in ?0..?9

  def next_number(<<char::utf8, rest::binary>>) when is_digit(char), do: {:ok, char - ?0, rest}
  def next_number(<<"zero"::utf8, rest::binary>>), do: {:ok, 0, "o" <> rest}
  def next_number(<<"one"::utf8, rest::binary>>), do: {:ok, 1, "e" <> rest}
  def next_number(<<"two"::utf8, rest::binary>>), do: {:ok, 2, "o" <> rest}
  def next_number(<<"three"::utf8, rest::binary>>), do: {:ok, 3, "e" <> rest}
  def next_number(<<"four"::utf8, rest::binary>>), do: {:ok, 4, "r" <> rest}
  def next_number(<<"five"::utf8, rest::binary>>), do: {:ok, 5, "e" <> rest}
  def next_number(<<"six"::utf8, rest::binary>>), do: {:ok, 6, "x" <> rest}
  def next_number(<<"seven"::utf8, rest::binary>>), do: {:ok, 7, "n" <> rest}
  def next_number(<<"eight"::utf8, rest::binary>>), do: {:ok, 8, "t" <> rest}
  def next_number(<<"nine"::utf8, rest::binary>>), do: {:ok, 9, "e" <> rest}
  def next_number(<<_, rest::binary>>), do: next_number(rest)
  def next_number(<<>>), do: {:error, :number_not_found}
end

defmodule AdventOfCode.Day01 do
  def part1(args) do
    solve(args, SimpleParser)
  end

  def part2(args) do
    solve(args, AdvancedParser)
  end

  defp solve(input, parser) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [first_number(parser, line), last_number(parser, line)]
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  defp first_number(parser, line) do
    case parser.next_number(line) do
      {:ok, number, _rest} ->
        number

      {:error, rest} ->
        first_number(parser, rest)
    end
  end

  defp last_number(parser, line) do
    case parser.next_number(line) do
      {:ok, number, rest} ->
        last_number(parser, rest, number)

      {:error, _} ->
        nil
    end
  end

  defp last_number(parser, line, number) do
    case parser.next_number(line) do
      {:ok, number, rest} ->
        last_number(parser, rest, number)

      {:error, _} ->
        number
    end
  end
end
