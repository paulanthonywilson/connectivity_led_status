defmodule ConnectivityLedStatus.ConfigurationTest do
  use ExUnit.Case
  alias ConnectivityLedStatus.Configuration

  test "defaults" do
    assert "led0" == Configuration.led()
    assert {192, 168, 0, 1} == Configuration.vintage_net_wizard_hotspot()
  end

  test "alternatives" do
    assert "led1" == Configuration.led(OtherConfiguration)
    assert {10, 20, 0, 1} == Configuration.vintage_net_wizard_hotspot(OtherConfiguration)
  end
end
