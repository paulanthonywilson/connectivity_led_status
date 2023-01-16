defmodule ConnectivityLedStatus.NetworkStatus do
  @moduledoc """
  Testing seam for getting connection information
  """
  alias ConnectivityLedStatus.NetworkStatus

  defmacro __using__(_) do
    implementation =
      if :test == apply(Mix, :env, []) do
        ConnectivityLedStatus.MockNetworkStatus
      else
        ConnectivityLedStatus.RealNetworkStatus
      end

    quote do
      alias unquote(implementation), as: NetworkStatus
    end
  end

  @callback wlan0_address :: :inet.ip_address() | nil
  @callback connection_status :: atom()
end
