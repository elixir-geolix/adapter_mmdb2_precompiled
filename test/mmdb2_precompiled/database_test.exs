defmodule Geolix.Adapter.MMDB2Precompiled.DatabaseTest do
  use ExUnit.Case, async: true

  alias Geolix.Adapter.MMDB2Precompiled.Database
  alias Geolix.TestData

  defmodule TestDatabase do
    use Database, source: TestData.file(:mmdb2, "Geolix.mmdb")
  end

  defmodule TestDatabaseMMDB2Opts do
    use Database,
      source: TestData.file(:mmdb2, "Geolix.mmdb"),
      mmdb2_decoder_options: %{
        double_precision: 8,
        float_precision: 4,
        map_keys: :atoms
      }
  end

  test "read and compile database" do
    assert TestDatabase.lookup({1, 1, 1, 1}) == %{"type" => "test"}
    refute TestDatabase.lookup({255, 255, 255, 255})
  end

  test "custom mmdb2 decoder options" do
    assert TestDatabaseMMDB2Opts.lookup({1, 1, 1, 1}) == %{type: "test"}
  end

  test "raises for invalid source files" do
    assert_raise File.Error, fn ->
      defmodule RaiseOnMissingFile do
        alias Geolix.Adapter.MMDB2Precompiled.Database

        use Database, source: Path.join(__DIR__, "does-not-exist")
      end
    end
  end
end
