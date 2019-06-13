defmodule ExGcloudPubsubPuller.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: ExGcloudPubsubPuller.Worker.start_link(arg)
      # {ExGcloudPubsubPuller.Worker, arg},
      {ExGcloudPubsubPuller.MemoryStore, %{}},
      ExGcloudPubsubPuller.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExGcloudPubsubPuller.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
