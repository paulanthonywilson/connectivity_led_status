defmodule ConnectivityLedStatus.RealNetworkStatus do
  @moduledoc """
  Gets information on the current (VintageNet) network
  """

  @behaviour ConnectivityLedStatus.NetworkStatus

  @impl true
  def wlan0_address do
    with {:ok, addresses} <- :inet.getifaddrs() do
      wlan0_address(addresses)
    end
  end

  @doc false
  @spec wlan0_address(list({charlist(), keyword()})) :: :inet.ip_address() | nil
  def wlan0_address(addresses) do
    addresses
    |> Enum.find(fn {interface, _} -> 'wlan0' == interface end)
    |> extract_ip4_address()
  end

  @impl true
  def connection_status do
    apply(VintageNet, :get, [["interface", "wlan0", "connection"]])
  end

  defp extract_ip4_address({'wlan0', details}) do
    Enum.reduce_while(details, nil, fn
      {:addr, {_, _, _, _} = ip}, _ -> {:halt, ip}
      _, _ -> {:cont, nil}
    end)
  end

  defp extract_ip4_address(_), do: nil
end
