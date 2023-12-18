defmodule AdventOfCode.Day02.Set do
  alias AdventOfCode.Day02.Set

  defstruct green: 0, blue: 0, red: 0

  def compare(%Set{} = set1, %Set{} = set2) do
    cond do
      set1 == set2 -> :equal
      set1.green > set2.green or set1.blue > set2.blue or set1.red > set2.red -> :greater
      true -> :less
    end
  end

  def merge(%Set{} = set1, %Set{} = set2) do
    %Set{
      green: max(set1.green, set2.green),
      blue: max(set1.blue, set2.blue),
      red: max(set1.red, set2.red)
    }
  end
end

defmodule AdventOfCode.Day02 do
  alias AdventOfCode.Day02.Set

  def part1(args) do
    max_set = %Set{red: 12, green: 13, blue: 14}

    args
    |> String.split("\n", trim: true)
    |> Enum.map(&extract_game_info/1)
    |> Enum.filter(fn {_, sets} ->
      Enum.all?(sets, fn set -> Set.compare(set, max_set) != :greater end)
    end)
    |> Enum.reduce(0, fn {game_id, _sets}, acc -> acc + game_id end)
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&extract_game_info/1)
    |> Enum.map(fn {_, sets} ->
      Enum.reduce(sets, %Set{}, &Set.merge/2)
    end)
    |> Enum.reduce(0, fn set, acc -> acc + set.green * set.blue * set.red end)
  end

  defp extract_game_info(line) do
    ["Game " <> game_id, sets] = String.split(line, ": ", trim: true)
    {String.to_integer(game_id), extract_sets(sets)}
  end

  defp extract_sets(sets) do
    sets
    |> String.split(";", trim: true)
    |> Enum.map(fn set ->
      set
      |> String.split(", ", trim: true)
      |> Enum.reduce(%Set{}, fn cubes, acc ->
        [count, color] = String.split(cubes, " ", trim: true)

        %{acc | String.to_atom(color) => String.to_integer(count)}
      end)
    end)
  end
end
