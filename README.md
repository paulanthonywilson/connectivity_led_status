# Connectivity Led Status

Use the on-board LEDs to indicate wifi connection status as I find it useful to have a visual
guide to whether a Raspberry PI (zero W) is connected. 

The connection status is not relying on VintageNet events as that can get complicated.
It uses the IP addresses along with VintageNet properties, and checks every 5 seconds.

The LEDs flash differently depending on WiFi status:

* Flashes rapidly if no WiFi address is allocated
* Flashes in a more measured way when the VingateNetWizard is up
* Flashes a heartbeat (2 rapid flashes then a pause) if a IP address is established but VintageNet is not reporting Internet connectivity
* Does not flash when a WiFi address (other than the VintageNetWizard) is allocated and Network connectivity is established

See [VintageNet documentation](https://hexdocs.pm/vintage_net/readme.html#internet-connectivity-checks) on configuring its Internet Connectivity checks.

## Optional configuration

By default the LED flashed is "led0", being the onboard LED available on a Pi Zero and the VintageNetWizard (v4) IP is `{192, 168, 0, 1}`. This can be changed by compile-time configuration eg

```elixir
import Config

config :connectivity_led_status, :led, "led1"
config :connectivity_led_status, :vintage_net_wizard_hotspot, {10, 20, 0, 1}

```



## Installation

The package can be installed by adding `connectivity_led_status` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:connectivity_led_status, "~> 0.1.0"}
  ]
end
```

