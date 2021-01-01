use Mix.Config

alias Geolix.Adapter.MMDB2Precompiled

config :geolix,
  databases: [
    %{id: :country, adapter: MMDB2Precompiled, database: MMDB2Precompiled.VerifyCountry}
  ]
