defmodule GameOfLife.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      GameOfLife.GameSupervisor
    ]

    opts = [strategy: :one_for_one, name: GameOfLife.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
