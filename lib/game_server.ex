defmodule GameOfLife.GameServer do
  use GenServer, restart: :temporary, shutdown: 10_000

  alias GameOfLife.{Game, Store}

  require Logger

  @game_wait 100

  # Client
  def start_link(_params) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def stop_game do
    GenServer.cast(__MODULE__, :stop_game)
  end

  # Server
  @impl true
  def init(state) do
    {:ok, state, {:continue, :game_init}}
  end

  @impl true
  def handle_continue(:game_init, _state) do
    game_state = Game.new()
    Store.put(game_state, :init)
    _ = Logger.info("New Game ID: #{game_state.id}")
    _timer = Process.send_after(self(), :tick, @game_wait)
    {:noreply, game_state}
  end

  @impl true
  def handle_cast(:stop_game, state) do
    {:stop, :normal, state}
  end

  @impl true
  def handle_info(:tick, state) do
    if Game.over?(state) do
      _ = Logger.info("Game Over ID: #{state.id}")
      {:stop, :normal, state}
    else
      new_state = Game.next_state(state)
      Store.put(new_state, :tick)
      _timer = Process.send_after(self(), :tick, @game_wait)
      {:noreply, new_state}
    end
  end
end
