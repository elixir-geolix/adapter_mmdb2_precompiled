defmodule Geolix.Adapter.MMDB2Precompiled.MixProject do
  use Mix.Project

  @url_github "https://github.com/elixir-geolix/adapter_mmdb2_precompiled"

  def project do
    [
      app: :geolix_adapter_mmdb2_precompiled,
      name: "Geolix Adapter: MMDB2 Precompiled",
      version: "0.1.0-dev",
      elixir: "~> 1.7",
      aliases: aliases(),
      deps: deps(),
      description: "Compile-Time MMDB2 adapter for Geolix",
      dialyzer: dialyzer(),
      docs: docs(),
      package: package(),
      preferred_cli_env: [
        "bench.lookup": :bench,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  defp aliases() do
    [
      "bench.lookup": ["run bench/lookup.exs"]
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.0", only: :bench, runtime: false},
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13.0", only: :test, runtime: false},
      {:geolix, github: "elixir-geolix/geolix", rev: "1f8d354de10690ed9881971c3355861634489d9b"},
      {:geolix_testdata, "~> 0.5.1", only: [:bench, :test], runtime: false},
      {:mmdb2_decoder, "~> 3.0"}
    ]
  end

  defp dialyzer do
    [
      flags: [
        :error_handling,
        :race_conditions,
        :underspecs,
        :unmatched_returns
      ]
    ]
  end

  defp docs do
    [
      main: "Geolix.Adapter.MMDB2Precompiled",
      source_ref: "master",
      source_url: @url_github
    ]
  end

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @url_github},
      maintainers: ["Marc Neudert"]
    }
  end
end
