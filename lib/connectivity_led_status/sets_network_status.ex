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

  config :connectivity_led_status, :vintage_net_wizard_hotspot, {10, 20, 0, 1}

  ```


  """
  alias ConnectivityLedStatus.NetworkStatus
  alias ConnectivityLedStatus.RealOnboardLed.NetworkStatusLed.OnboardLed

  use GenServer
  use ConnectivityLedStatus.OnboardLed
  use ConnectivityLedStatus.NetworkStatus

  @name __MODULE__

  @check_every :timer.seconds(5)

  @vintagenet_wizard_gateway_ip Application.compile_env(
                                  :connectivity_led_status,
                                  :vintage_net_wizard_hotspot,
                                  {192, 168, 0, 1}
                                )

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  @impl true
  def init(_) do
    send(self(), :schedule_next_check)
    {:ok, []}
  end

  @impl true
  def handle_info(:check_addresses, state) do
    case NetworkStatus.wlan0_address() do
      nil -> OnboardLed.flash_alarmingly()
      @vintagenet_wizard_gateway_ip -> OnboardLed.flash_languidly()
      _ -> check_connection_status()
    end

    send(self(), :schedule_next_check)
    {:noreply, state}
  end

  def handle_info(:schedule_next_check, state) do
    Process.send_after(self(), :check_addresses, @check_every)
    {:noreply, state}
  end

  defp check_connection_status do
    if NetworkStatus.connection_status() == :internet do
      OnboardLed.turn_off()
    else
      OnboardLed.flash_heartbeat()
    end
  end
end
