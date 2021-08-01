defmodule GameOfLife.CellsTest do
  use ExUnit.Case

  alias GameOfLife.Cells
  alias GameOfLife.Patterns.Oscillators

  describe "changes_for_cells/2" do
    test "given a MapSet of cells that should survive with nbrs that should not birth it returns empty lists" do
      # - - - - -
      # - x x x -
      # - - - - -
      pop_cells = Oscillators.blinker({0, 0}, :x)
      expected_pop = MapSet.difference(Oscillators.blinker({0, 0}, :y), pop_cells)
      expected_unpop = MapSet.delete(pop_cells, {0, 0})
      assert {expected_pop, expected_unpop} == Cells.changes_for_cells(pop_cells)
    end
  end
end
