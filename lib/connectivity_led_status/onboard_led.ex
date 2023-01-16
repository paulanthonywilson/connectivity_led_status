defmodule ConnectivityLedStatus.OnboardLed do
  @moduledoc """
  Behaviour for interacting with the Nerves.LED. Used as a testing seam.



  """

  defmacro __using__(_) do
    implementation =
      if :test == apply(Mix, :env, []) do
        ConnectivityLedStatus.MockOnboardLed
      else
        ConnectivityLedStatus.RealOnboardLed
      end

    quote do
      alias unquote(implementation), as: OnboardLed
    end
  end

  @doc """
  Sets the LED to flash rapidly (fast blink)
  """
  @callback flash_alarmingly :: :ok

  @doc """
  Sets the LED to flash slowly (slow blink)
  """
  @callback flash_languidly :: :ok

  @doc """
  You'll never guess what this does.
  """
  @callback turn_off :: :ok

  @doc """
  Two rapid flashes, then a pause etc...
  """
  @callback flash_heartbeat :: :ok
end
