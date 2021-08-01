defmodule GameOfLife.GameTest do
  use ExUnit.Case

  alias GameOfLife.Game
  alias GameOfLife.Patterns.Oscillators

  describe "over?/1" do
    test "pop of 0 is game over" do
      assert Game.over?(%{population: 0})
    end

    test "pop of > 0 is not over" do
      refute Game.over?(%{population: 1})
    end
  end

  describe "next_state/1" do
    test "given a state is reutrns the next version of that state with new timestamp and generation #" do
      pop_cells = Oscillators.blinker({0, 0}, :x)
      expected_pop_cells = Oscillators.blinker({0, 0}, :y)

      gen_2 =
        Game.new(pop_cells)
        |> Game.next_state()

      assert gen_2.generation == 2
      assert gen_2.pop_cells == expected_pop_cells
      assert gen_2.population == 3
    end
  end
end
