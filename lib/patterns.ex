defmodule GameOfLife.Patterns do
  defmodule StillLife do
    def block({x, y}) do
      [
        {x, y + 1},
        {x, y},
        {x + 1, y + 1},
        {x + 1, y}
      ]
      |> MapSet.new()
    end

    def tub({x, y}) do
      [
        {x, y + 1},
        {x - 1, y},
        {x + 1, y},
        {x, y - 1}
      ]
      |> MapSet.new()
    end
  end

  defmodule Oscillators do
    def blinker({x, y}, :x) do
      [
        {x - 1, y},
        {x, y},
        {x + 1, y}
      ]
      |> MapSet.new()
    end

    def blinker({x, y}, :y) do
      [
        {x, y + 1},
        {x, y},
        {x, y - 1}
      ]
      |> MapSet.new()
    end
  end
end
