defmodule GameOfLife.Cell do
  #   returns a tuple of lists of populated and de-poplulated coordinates
  #   changes_for_cell({x,y}, %MapSet{[{x,y}..{xn,yn}]}) :: {%MapSet{[{x,y}..{xn,yn}]}, %MapSet{[{x,y}..{xn,yn}]}
  def changes_for_cell(cell, :pop, pop_cells) do
    pop = unpop = MapSet.new()

    {pop_nbrs, _unpop_nbrs} =
      cell
      |> get_nbrs()
      |> split_nbrs(pop_cells)

    if :unpop == state_change(:pop, MapSet.size(pop_nbrs)) do
      MapSet.put(unpop, cell)
    end

    {pop, unpop}
  end

  def changes_for_cell(cell, :unpop, pop_cells) do
    pop = unpop = MapSet.new()

    {pop_nbrs, _unpop_nbrs} =
      cell
      |> get_nbrs()
      |> split_nbrs(pop_cells)

    if :pop == state_change(:unpop, MapSet.size(pop_nbrs)) do
      MapSet.put(pop, cell)
    end

    {pop, unpop}
  end

  def state_change(:pop, 2), do: :pop
  def state_change(:pop, 3), do: :pop
  def state_change(:pop, _count), do: :unpop
  def state_change(:unpop, 3), do: :pop
  def state_change(:unpop, _count), do: :unpop

  def get_nbrs(cell) do
    {x, y} = cell
    xa = x - 1
    xc = x + 1
    y1 = y + 1
    y3 = y - 1

    [
      {xa, y1},
      {xa, y},
      {xa, y3},
      {x, y1},
      {x, y3},
      {xc, y1},
      {xc, y},
      {xc, y3}
    ]
    |> MapSet.new()
  end

  def split_nbrs(nbrs, pop_cells) do
    {pop, unpop} = Enum.split_with(nbrs, fn nbr -> MapSet.member?(pop_cells, nbr) end)
    {MapSet.new(pop), MapSet.new(unpop)}
  end
end
