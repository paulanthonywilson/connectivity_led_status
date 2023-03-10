defmodule ConnectivityLedStatus.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [ConnectivityLedStatus.SetsNetworkStatus]

    opts = [strategy: :one_for_one, name: ConnectivityLedStatus.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
