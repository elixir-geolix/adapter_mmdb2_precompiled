defmodule Geolix.Adapter.MMDB2Precompiled.DatabaseTest do
  use ExUnit.Case, async: true

  alias Geolix.TestData

  test "read and compile database" do
    defmodule TestDatabase do
      alias Geolix.Adapter.MMDB2Precompiled.Database
      alias Geolix.TestData

      use Database, source: TestData.file(:mmdb2, "Geolix.mmdb")
    end

    {:ok, meta, tree, _} =
      TestData.file(:mmdb2, "Geolix.mmdb")
      |> File.read!()
      |> MMDB2Decoder.parse_database()

    assert {1, 1, 1, 1}
           |> MMDB2Decoder.find_pointer!(meta, tree)
           |> TestDatabase.lookup_result() == %{"type" => "test"}
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
