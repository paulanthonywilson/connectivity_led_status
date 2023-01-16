# credo:disable-for-this-file Credo.Check.Readability.LargeNumbers
defmodule ConnectivityLedStatus.RealNetworkStatusTest do
  use ExUnit.Case
  alias ConnectivityLedStatus.RealNetworkStatus

  test "finds the wlan0 address" do
    addrs = [
      {'lo',
       [
         flags: [:up, :loopback, :running],
         addr: {127, 0, 0, 1},
         netmask: {255, 0, 0, 0},
         addr: {0, 0, 0, 0, 0, 0, 0, 1},
         netmask: {65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535},
         hwaddr: [0, 0, 0, 0, 0, 0]
       ]},
      {'wlan0',
       [
         flags: [:up, :broadcast, :running, :multicast],
         addr: {65152, 0, 0, 0, 47655, 60415, 65141, 1980},
         netmask: {65535, 65535, 65535, 65535, 0, 0, 0, 0},
         hwaddr: [184, 39, 235, 117, 7, 188],
         addr: {192, 168, 0, 51},
         netmask: {255, 255, 255, 0},
         broadaddr: {192, 168, 0, 255}
       ]}
    ]

    assert {192, 168, 0, 51} == RealNetworkStatus.wlan0_address(addrs)
  end

  test "nil if no wlan0" do
    addrs = [
      {'lo',
       [
         flags: [:up, :loopback, :running],
         addr: {127, 0, 0, 1},
         netmask: {255, 0, 0, 0},
         addr: {0, 0, 0, 0, 0, 0, 0, 1},
         netmask: {65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535},
         hwaddr: [0, 0, 0, 0, 0, 0]
       ]}
    ]

    assert nil == RealNetworkStatus.wlan0_address(addrs)
  end

  test "nil if there is no address" do
    addrs = [
      {'lo',
       [
         flags: [:up, :loopback, :running],
         addr: {127, 0, 0, 1},
         netmask: {255, 0, 0, 0},
         addr: {0, 0, 0, 0, 0, 0, 0, 1},
         netmask: {65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535},
         hwaddr: [0, 0, 0, 0, 0, 0]
       ]},
      {'wlan0', [flags: [:broadcast, :multicast], hwaddr: [184, 39, 235, 117, 7, 188]]}
    ]

    assert nil == RealNetworkStatus.wlan0_address(addrs)
  end
end
