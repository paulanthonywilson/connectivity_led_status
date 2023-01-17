defmodule ConnectivityLedStatus.SetsNetworkStatusTest do
  use ExUnit.Case, async: true

  alias ConnectivityLedStatus.{MockNetworkStatus, MockOnboardLed, SetsNetworkStatus}

  import Mox

  setup :verify_on_exit!

  test "when wifi address is set, and has an internet connection, the Led is turned off" do
    expect(MockNetworkStatus, :wlan0_address, fn -> {192, 168, 0, 66} end)
    expect(MockNetworkStatus, :connection_status, fn -> :internet end)
    expect(MockOnboardLed, :turn_off, fn -> :ok end)

    SetsNetworkStatus.handle_info(:check_addresses, {})
    assert_receive :schedule_next_check
  end

  test "when wifi address is set, but  has no internet connection, the Led heartbeats" do
    expect(MockNetworkStatus, :wlan0_address, fn -> {192, 168, 0, 66} end)
    expect(MockNetworkStatus, :connection_status, fn -> :lan end)
    expect(MockOnboardLed, :flash_heartbeat, fn -> :ok end)

    SetsNetworkStatus.handle_info(:check_addresses, {})
    assert_receive :schedule_next_check
  end

  test "when wifi address is not set, the Led is made to flash alarmingly" do
    expect(MockNetworkStatus, :wlan0_address, fn -> nil end)
    expect(MockOnboardLed, :flash_alarmingly, fn -> :ok end)

    SetsNetworkStatus.handle_info(:check_addresses, {})
    assert_receive :schedule_next_check
  end

  test "when wifi address is VintageNet wizard gateway address then flash languidly" do
    expect(MockNetworkStatus, :wlan0_address, fn -> {192, 168, 0, 1} end)
    expect(MockOnboardLed, :flash_languidly, fn -> :ok end)

    SetsNetworkStatus.handle_info(:check_addresses, {})
    assert_receive :schedule_next_check
  end
end
