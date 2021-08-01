defmodule GameOfLife.GameServer do
  use GenServer

  alias GameOfLife.Game

  @game_wait 100

  # Client
  def start_link(_params) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Server
  @impl true
  def init(state) do
    {:ok, state, {:continue, :game_init}}
  end

  @impl true
  def handle_continue(:game_init, _state) do
    game_state = Game.new()
    _timer = Process.send_after(self(), :tick, @game_wait)
    {:noreply, game_state}
  end

  @impl true
  def handle_info(:tick, state) do
    if Game.over?(state) do
      # TODO send state stats to store
      {:stop, :game_over}
    else
      new_state = Game.next_state(state)
      _timer = Process.send_after(self(), :tick, @game_wait)
      {:noreply, new_state}
    end
  end
end
