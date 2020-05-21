defmodule BenchmarkDatabase do
  alias Geolix.Adapter.MMDB2Precompiled.Database
  alias Geolix.TestData

  use Database, source: TestData.file(:mmdb2, "Benchmark.mmdb")
end

{:ok, lookup_ipv4} = :inet.parse_address('1.1.1.1')
{:ok, lookup_ipv4_in_ipv6} = :inet.parse_address('::1.1.1.1')

Benchee.run(
  %{
    "IPv4 in IPV6 lookup" => fn -> BenchmarkDatabase.lookup(lookup_ipv4_in_ipv6) end,
    "IPv4 lookup" => fn -> BenchmarkDatabase.lookup(lookup_ipv4) end
  },
  formatters: [{Benchee.Formatters.Console, comparison: false}],
  warmup: 2,
  time: 10
)
