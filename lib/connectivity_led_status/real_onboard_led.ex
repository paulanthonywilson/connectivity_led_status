defmodule ConnectivityLedStatus.RealOnboardLed do
  @moduledoc """
  Interacts with the onboard LED. By default `"led0"` (the LED on a Pi Zero).

  Can be compile-time configured to be a different LED eg
  ```
  import Config
  config :connectivity_led_status, :led, "led1"
  ```

  Configuration is optional
  """
  @behaviour ConnectivityLedStatus.OnboardLed

  @led_addr Application.compile_env(:connectivity_led_status, :led, "led0")

  @impl true
  def flash_alarmingly do
    Nerves.Leds.set(@led_addr, :fastblink)
  end

  @impl true
  def flash_languidly do
    Nerves.Leds.set(@led_addr, :slowblink)
  end

  @impl true
  def turn_off() do
    Nerves.Leds.set(@led_addr, false)
  end

  @impl true
  def flash_heartbeat do
    Nerves.Leds.set(@led_addr, :heartbeat)
  end
end
