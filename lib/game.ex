defmodule GameOfLife.Game do
  alias GameOfLife.Cells

  # TODO could use a defstruct here for %Game{}

  def new(initial_population \\ MapSet.new()) do
    %{
      generation: 1,
      id: UUID.uuid5(UUID.uuid1(), GameOfLife |> Atom.to_string()),
      pop_cells: initial_population,
      population: MapSet.size(initial_population),
      timestamp: DateTime.utc_now()
    }
  end

  def over?(%{population: pop}), do: pop <= 0

  def next_state(state) do
    pop_cells = Cells.next_state(state.pop_cells)

    Map.merge(state, %{
      generation: state.generation + 1,
      pop_cells: pop_cells,
      population: MapSet.size(pop_cells),
      timestamp: DateTime.utc_now()
    })
  end
end
