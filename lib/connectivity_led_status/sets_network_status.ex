defmodule ConnectivityLedStatus.SetsNetworkStatus do
  @moduledoc """
  Checks to see if there's an IP address assigned to wlan0 every 5 seconds and:

  * if it is not set flashes the onboard LED rapdily
  * if it is set to 192.168.0.1 (or otherwise configured) then assume that
  this is an access point as part of the configuration
  process, and flash slowly
  * if it is set to something else and VintageNet reports that Internet connection is established,
  then flash heartbeat
  * If connection is all ok, then the LED is turned off

  This could have be done with subscribing to VintageNet but that gets complicated to test
  the different states and may not deal well with any VintageNet bugs.

  Optionally you can configure the IP that indiciates VintageNetWizard  to another value at compile time

  eg

  ```elixir
  import Config

  config :connectivity_led_status, Configuration, vintage_net_wizard_hotspot: {10, 20, 0, 1}

  ```


  """

  use GenServer
  use ConnectivityLedStatus.OnboardLed
  use ConnectivityLedStatus.NetworkStatus

  alias ConnectivityLedStatus.Configuration

  @name __MODULE__

  @check_every :timer.seconds(5)

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  @impl true
  def init(_) do
    send(self(), :schedule_next_check)
    {:ok, %{connection_state: :unchecked}}
  end

  @impl true
  def handle_info(:check_addresses, state) do
    send(self(), :schedule_next_check)
    wizard_ip = Configuration.vintage_net_wizard_hotspot()

    state =
      case NetworkStatus.wlan0_address() do
        nil -> set_connection_state(:disconnected, state)
        ^wizard_ip -> set_connection_state(:wizard, state)
        _ -> check_connection_status(state)
      end

    {:noreply, state}
  end

  def handle_info(:schedule_next_check, state) do
    Process.send_after(self(), :check_addresses, @check_every)
    {:noreply, state}
  end

  defp check_connection_status(state) do
    if NetworkStatus.connection_status() == :internet do
      set_connection_state(:connected, state)
    else
      set_connection_state(:lan_only, state)
    end
  end

  defp set_connection_state(connection_state, state) do
    maybe_change_led(connection_state, state)
    %{state | connection_state: connection_state}
  end

  defp maybe_change_led(connection_state, %{connection_state: connection_state}), do: :ok

  defp maybe_change_led(:connected, _state) do
    OnboardLed.turn_off()
  end

  defp maybe_change_led(:lan_only, _state) do
    OnboardLed.flash_heartbeat()
  end

  defp maybe_change_led(:disconnected, _state) do
    OnboardLed.flash_alarmingly()
  end

  defp maybe_change_led(:wizard, _state) do
    OnboardLed.flash_languidly()
  end
end
