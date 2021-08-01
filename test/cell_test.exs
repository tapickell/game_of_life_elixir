defmodule GameOfLife.CellTest do
  use ExUnit.Case

  alias GameOfLife.Cell

  describe "changes_for_cell/2" do
    test "given a cell that should survive with nbrs that should not birth it returns empty lists" do
      suriving_cell = {0, 0}
      # - - - 
      # x x x
      # - - - 
      live_cells =
        [
          {-1, 0},
          suriving_cell,
          {1, 0}
        ]
        |> MapSet.new()

      assert {MapSet.new(), MapSet.new()} == Cell.changes_for_cell(suriving_cell, live_cells)
    end
  end

  describe "state_change/2" do
    test "from live state with 1 live nbrs" do
      assert :unpop == Cell.state_change(:pop, 1)
    end

    test "from live state with 2 live nbrs" do
      assert :pop == Cell.state_change(:pop, 2)
    end

    test "from live state with 3 live nbrs" do
      assert :pop == Cell.state_change(:pop, 3)
    end

    test "from live state with 4 live nbrs" do
      assert :unpop == Cell.state_change(:pop, 4)
    end

    test "from unpop state with 2 live nbrs" do
      assert :unpop == Cell.state_change(:unpop, 2)
    end

    test "from unpop state with 3 live nbrs" do
      assert :pop == Cell.state_change(:unpop, 3)
    end

    test "from unpop state with 4 live nbrs" do
      assert :unpop == Cell.state_change(:unpop, 4)
    end
  end

  describe "get_nbrs/1" do
    test "given a valid cell returns a valid list of nbrs" do
      expected_nbrs =
        [
          {-1, 1},
          {-1, 0},
          {-1, -1},
          {0, 1},
          {0, -1},
          {1, 1},
          {1, 0},
          {1, -1}
        ]
        |> MapSet.new()

      assert expected_nbrs == Cell.get_nbrs({0, 0})
    end
  end

  describe "split_nbrs/2" do
    test "given valid list of nbrs and valid list of cells, matches in first list" do
      expected_pop =
        [{-1, 1}, {1, 0}, {0, -1}]
        |> MapSet.new()

      expected_unpop =
        [{-1, 0}, {-1, -1}, {0, 1}, {1, 1}, {1, -1}]
        |> MapSet.new()

      nbrs = Cell.get_nbrs({0, 0})

      {pop, unpop} =
        Cell.split_nbrs(nbrs, MapSet.union(expected_pop, MapSet.new([{2, 1}, {-3, 0}, {4, 4}])))

      assert MapSet.equal?(expected_pop, pop)
      assert MapSet.equal?(expected_unpop, unpop)
    end

    test "given no live cells matching there are no pop cells returned" do
      nbrs = Cell.get_nbrs({0, 0})
      {pop, unpop} = Cell.split_nbrs(nbrs, [{2, 1}, {-3, 0}, {4, 4}] |> MapSet.new())
      assert 0 == MapSet.size(pop)
      assert 8 == MapSet.size(unpop)
    end
  end
end
