defmodule ConnectivityLedStatus.Configuration do
  @moduledoc false

  @doc """
  Led identifier. See https://hexdocs.pm/nerves_leds/Nerves.Leds.html
  """
  def led(key \\ Configuration) do
    config(key, :led, "led0")
  end

  @doc """
  IPv4 address in tuple form
  """
  def vintage_net_wizard_hotspot(key \\ Configuration) do
    config(key, :vintage_net_wizard_hotspot, {192, 168, 0, 1})
  end

  defp config(key, subkey, default) do
    :connectivity_led_status
    |> Application.get_env(key, [])
    |> Keyword.get(subkey, default)
  end
end
