defmodule Geolix.Adapter.MMDB2Precompiled.DatabaseTest do
  use ExUnit.Case, async: true

  alias Geolix.Adapter.MMDB2Precompiled.Database
  alias Geolix.TestData

  defmodule TestDatabase do
    use Database, source: TestData.file(:mmdb2, "Geolix.mmdb")
  end

  test "read and compile database" do
    assert TestDatabase.lookup({1, 1, 1, 1}) == %{"type" => "test"}
    refute TestDatabase.lookup({255, 255, 255, 255})
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
