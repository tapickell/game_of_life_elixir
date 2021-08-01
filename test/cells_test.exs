defmodule GameOfLife.CellsTest do
  use ExUnit.Case

  alias GameOfLife.Cells
  alias GameOfLife.Patterns.{Oscillators, StillLifes}

  describe "next_state/1" do
    test "given a set of cells the returned set contains expected cells" do
      pop_cells = Oscillators.blinker({0, 0}, :x)
      expected_pop_cells = Oscillators.blinker({0, 0}, :y)

      assert expected_pop_cells == Cells.next_state(pop_cells)
    end
  end

  describe "apply_changes/2" do
    test "given a set of cells and a subset to pop and unpop the returned set contains expected cells" do
      pop_cells = Oscillators.blinker({0, 0}, :x)
      {pop, unpop} = Cells.changes_for_cells(pop_cells)
      expected_pop_cells = Oscillators.blinker({0, 0}, :y)

      assert expected_pop_cells == Cells.apply_changes({pop, unpop}, pop_cells)
    end
  end

  describe "changes_for_cells/2 with oscillators" do
    test "given a blinker on the x axis it should return updates to create a blinker on the y" do
      # - - - - -       - - - - -
      # - - - - -       - - X - -
      # - X X X -  -->  - - X - -
      # - - - - -       - - X - - 
      # - - - - -       - - - - -
      pop_cells = Oscillators.blinker({0, 0}, :x)
      expected_pop = MapSet.difference(Oscillators.blinker({0, 0}, :y), pop_cells)
      expected_unpop = MapSet.delete(pop_cells, {0, 0})
      assert {expected_pop, expected_unpop} == Cells.changes_for_cells(pop_cells)
    end

    test "given a blinker on the y axis it should return updates to create a blinker on the x" do
      # - - - - -       - - - - -
      # - - X - -       - - - - -
      # - - X - -  -->  - X X X -
      # - - X - -       - - - - - 
      # - - - - -       - - - - -
      pop_cells = Oscillators.blinker({0, 0}, :y)
      expected_pop = MapSet.difference(Oscillators.blinker({0, 0}, :x), pop_cells)
      # just 2 new cells
      expected_unpop = MapSet.delete(pop_cells, {0, 0})
      assert {expected_pop, expected_unpop} == Cells.changes_for_cells(pop_cells)
    end

    # TODO NOT sure why this one actually returns changes for new beacon
    test "given a beacon in on state it should return updates to create a beacon in off state" do
      # - - - - - -       - - - - - -
      # - X X - - -       - X X - - -
      # - X X - - -  -->  - X - - - -
      # - - - X X -       - - - - X -
      # - - - X X -       - - - X X -
      # - - - - - -       - - - - - -
      pop_cells = Oscillators.beacon({0, 0}, :on)
      expected_pop = Oscillators.beacon({0, 0}, :off)
      expected_unpop = MapSet.difference(pop_cells, expected_pop)
      assert {expected_pop, expected_unpop} == Cells.changes_for_cells(pop_cells)
    end

    test "given a beacon in off state it should return updates to create a beacon in on state" do
      # - - - - - -       - - - - - -
      # - X X - - -       - X X - - -
      # - X - - - -  -->  - X X - - -
      # - - - - X -       - - - X X - 
      # - - - X X -       - - - X X -
      # - - - - - -       - - - - - -
      pop_cells = Oscillators.beacon({0, 0}, :off)
      # just 2 new cells
      expected_pop = MapSet.difference(Oscillators.beacon({0, 0}, :on), pop_cells)
      assert {expected_pop, MapSet.new()} == Cells.changes_for_cells(pop_cells)
    end
  end

  describe "changes_for_cells/2 with still lifes" do
    # TODO NOT sure why this one actually returns changes vs the tub which does not
    test "given a block returns a block with same coordinates" do
      # - - - - -       - - - - -
      # - - X X -       - - X X -
      # - - X X -  -->  - - X X -
      # - - _ - -       - - - - - 
      # - - - - -       - - - - -
      pop_cells = StillLifes.block({0, 0})
      assert {pop_cells, MapSet.new()} == Cells.changes_for_cells(pop_cells)
    end

    test "given a tub returns no changes" do
      # - - - - -
      # - - X - -
      # - X - X -
      # - - X - -
      # - - - - -
      pop_cells = StillLifes.tub({0, 0})
      assert {MapSet.new(), MapSet.new()} == Cells.changes_for_cells(pop_cells)
    end
  end
end
