defmodule Rheostat.MixProject do
  use Mix.Project

  def project do
    [
      app: :rheostat,
      version: "0.2.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      description: "A configurable stats provider",
      name: "Rheostat",
      source_url: "https://github.com/spreedly/rheostat",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:metrix, "~> 0.5.0"},
      {:statix, "~> 1.4.0"},
      {:ex_doc, "~> 0.0", only: :dev}
    ]
  end

  defp package do
    [
      name: :rheostat,
      licenses: ["MIT License"],
      maintainers: ["Kevin Lewis", "Spreedly"],
      links: %{"GitHub" => "https://github.com/spreedly/rheostat"}
    ]
  end
end
