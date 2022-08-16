defmodule Geolix.Adapter.MMDB2Precompiled.MixProject do
  use Mix.Project

  @url_changelog "https://hexdocs.pm/geolix_adapter_mmdb2_precompiled/changelog.html"
  @url_github "https://github.com/elixir-geolix/adapter_mmdb2_precompiled"
  @version "0.1.0-dev"

  def project do
    [
      app: :geolix_adapter_mmdb2_precompiled,
      name: "Geolix Adapter: MMDB2 Precompiled",
      version: @version,
      elixir: "~> 1.9",
      aliases: aliases(),
      deps: deps(),
      description: "Compile-Time MMDB2 adapter for Geolix",
      dialyzer: dialyzer(),
      docs: docs(),
      package: package(),
      preferred_cli_env: [
        "bench.lookup": :bench,
        coveralls: :test,
        "coveralls.detail": :test
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
      {:benchee, "~> 1.1", only: :bench, runtime: false},
      {:credo, "~> 1.6", only: :dev, runtime: false},
      {:dialyxir, "~> 1.2", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14.0", only: :test, runtime: false},
      {:geolix, "~> 2.0"},
      {:geolix_testdata, "~> 0.6.0", only: [:bench, :test], runtime: false},
      {:mmdb2_decoder, "~> 3.0"}
    ]
  end

  defp dialyzer do
    [
      flags: [
        :error_handling,
        :underspecs,
        :unmatched_returns
      ],
      plt_core_path: "plts",
      plt_local_path: "plts"
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md",
        LICENSE: [title: "License"],
        "README.md": [title: "Overview"]
      ],
      formatters: ["html"],
      main: "Geolix.Adapter.MMDB2Precompiled",
      source_ref: "v#{@version}",
      source_url: @url_github
    ]
  end

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache-2.0"],
      links: %{
        "Changelog" => @url_changelog,
        "GitHub" => @url_github
      }
    }
  end
end
