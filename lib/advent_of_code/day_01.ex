defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line_to_calibration_value(line, &part1_finder/1)
    end)
    |> Enum.sum()
  end

  def part2(_args) do
  end

  defp line_to_calibration_value(line, finder_fn) do
    line
    |> String.trim()
    |> String.replace(~r/[^0-9]/, "")
    |> String.codepoints()
    |> finder_fn.()
  end

  defp part1_finder(codepoints) do
    [Enum.at(codepoints, 0), Enum.at(codepoints, -1)]
    |> Enum.map(&String.to_integer/1)
    |> Integer.undigits()
  end
end
