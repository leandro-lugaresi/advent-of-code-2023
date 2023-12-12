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

  for {w, n} <- Enum.zip(~w(zero one two three four five six seven eight nine), 0..9) do
    def next_number(<<unquote(w)::utf8, rest::binary>>), do: {:ok, unquote(n), rest}
  end

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
      [first_number(parser, line), last_number(parser, line, 1)]
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

  defp last_number(parser, line, tail_len) when tail_len <= byte_size(line) do
    <<_::binary-size(byte_size(line) - tail_len), tail::binary>> = line

    case parser.next_number(tail) do
      {:ok, number, _rest} ->
        number

      {:error, _} ->
        last_number(parser, line, tail_len + 1)
    end
  end

  defp last_number(_parser, line, tail_len) when tail_len > byte_size(line) do
    raise "No number found for #{line} with tail length #{tail_len}"
  end
end
