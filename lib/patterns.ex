defmodule GameOfLife.Patterns do
  defmodule StillLifes do
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

    def beacon({x, y}, :on) do
      beacon({x, y}, :off)
      |> MapSet.union(MapSet.new([{x + 1, y}, {x + 2, y - 1}]))
    end

    def beacon({x, y}, :off) do
      [
        {x, y + 1},
        {x + 1, y + 1},
        {x, y},
        {x + 2, y - 2},
        {x + 3, y - 2},
        {x + 3, y - 1}
      ]
      |> MapSet.new()
    end
  end
end
