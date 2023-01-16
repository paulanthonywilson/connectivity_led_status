defmodule ConnectivityLedStatus.MixProject do
  use Mix.Project

  def project do
    [
      app: :connectivity_led_status,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ConnectivityLedStatus.Application, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test]},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.29.1", only: :dev, runtime: false},
      {:nerves_leds, "~> 0.8.1"},
      {:mox, "~> 1.0", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp package() do
    [
      description: "For Nerves projects, uses an onboard LED to signal internet connectivity",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/paulanthonywilson/connectivity_led_status/"}
    ]
  end

  defp docs do
    [main: "readme", extras: ["README.md"]]
  end
end
