defmodule GameOfLife.Cells do
  alias GameOfLife.Cell

  def next_state(pop_cells) do
    pop_cells
    |> changes_for_cells()
    |> apply_changes(pop_cells)
  end

  def apply_changes({pop_changes, unpop_changes}, pop_cells) do
    pop_cells
    |> MapSet.union(pop_changes)
    |> MapSet.difference(unpop_changes)
  end

  def changes_for_cells(pop_cells) do
    Enum.reduce(pop_cells, {MapSet.new(), MapSet.new()}, fn cell, {pop, unpop} ->
      {c_pop, c_unpop} = Cell.changes_for_cell(cell, :pop, pop_cells)
      nbrs = Cell.get_nbrs(cell)

      {nbrs_pop, nbrs_unpop} =
        Enum.reduce(nbrs, {MapSet.new(), MapSet.new()}, fn cell, {pop, unpop} ->
          {n_pop, n_unpop} = Cell.changes_for_cell(cell, :unpop, pop_cells)
          {MapSet.union(pop, n_pop), MapSet.union(unpop, n_unpop)}
        end)

      {MapSet.union(pop, MapSet.union(c_pop, nbrs_pop)),
       MapSet.union(unpop, MapSet.union(c_unpop, nbrs_unpop))}
    end)
  end
end
