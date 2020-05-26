defmodule Geolix.Adapter.MMDB2PrecompiledTest do
  use ExUnit.Case, async: true

  alias Geolix.Adapter.MMDB2Precompiled.Database
  alias Geolix.TestData

  defmodule TestDatabase do
    use Database, source: TestData.file(:mmdb2, "Geolix.mmdb")
  end

  test "geolix interface" do
    :ok = Geolix.load_database(%{id: :mmdb2_precompiled, database: TestDatabase})

    assert %MMDB2Decoder.Metadata{database_type: "Geolix"} =
             Geolix.metadata(where: :mmdb2_precompiled)

    assert %{"type" => "test"} = Geolix.lookup({1, 1, 1, 1}, where: :mmdb2_precompiled)
  end
end
