defmodule ConnectivityLedStatus.SetsNetworkStatusTest do
  use ExUnit.Case, async: true

  alias ConnectivityLedStatus.{MockNetworkStatus, MockOnboardLed, SetsNetworkStatus}

  import Mox

  setup :verify_on_exit!

  setup do
    stub(MockNetworkStatus, :wlan0_address, fn -> {192, 168, 0, 66} end)
    stub(MockNetworkStatus, :connection_status, fn -> :internet end)
    :ok
  end

  test "when wifi address is set, and has an internet connection, the Led is turned off" do
    expect(MockOnboardLed, :turn_off, fn -> :ok end)

    assert {:noreply, %{connection_state: :connected}} =
             SetsNetworkStatus.handle_info(:check_addresses, %{connection_state: :unchecked})

    assert_receive :schedule_next_check
  end

  test "when wifi address is set, but  has no internet connection, the Led heartbeats" do
    stub(MockNetworkStatus, :connection_status, fn -> :lan end)

    expect(MockOnboardLed, :flash_heartbeat, fn -> :ok end)

    assert {:noreply, %{connection_state: :lan_only}} =
             SetsNetworkStatus.handle_info(:check_addresses, %{connection_state: :unchecked})

    assert_receive :schedule_next_check
  end

  test "when wifi address is not set, the Led is made to flash alarmingly" do
    stub(MockNetworkStatus, :wlan0_address, fn -> nil end)

    expect(MockOnboardLed, :flash_alarmingly, fn -> :ok end)

    assert {:noreply, %{connection_state: :disconnected}} =
             SetsNetworkStatus.handle_info(:check_addresses, %{connection_state: :unchecked})

    assert_receive :schedule_next_check
  end

  test "when wifi address is VintageNet wizard gateway address then flash languidly" do
    stub(MockNetworkStatus, :wlan0_address, fn -> {192, 168, 0, 1} end)

    expect(MockOnboardLed, :flash_languidly, fn -> :ok end)

    assert {:noreply, %{connection_state: :wizard}} =
             SetsNetworkStatus.handle_info(:check_addresses, %{connection_state: :unchecked})

    assert_receive :schedule_next_check
  end

  test "led behaviour is changed when state is changed" do
    expect(MockOnboardLed, :turn_off, fn -> :ok end)

    SetsNetworkStatus.handle_info(:check_addresses, %{connection_state: :no_ip})

    stub(MockNetworkStatus, :connection_status, fn -> :lan end)
    expect(MockOnboardLed, :flash_heartbeat, fn -> :ok end)

    SetsNetworkStatus.handle_info(:check_addresses, %{connection_state: :connected})
  end

  test "led behviour is not changed if the  state is unchanged" do
    SetsNetworkStatus.handle_info(:check_addresses, %{connection_state: :connected})
  end
end
