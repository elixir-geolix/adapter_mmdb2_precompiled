defmodule Geolix.Adapter.MMDB2Precompiled.VerifyCountry do
  @moduledoc false

  use Geolix.Adapter.MMDB2Precompiled.Database,
    source: Path.expand("../../../../data/GeoLite2-Country.mmdb", __DIR__)
end
