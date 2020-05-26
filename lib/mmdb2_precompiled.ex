defmodule Geolix.Adapter.MMDB2Precompiled do
  @moduledoc """
  Adapter for Geolix to work with MMDB2 databases inlined during compilation.
  """

  @behaviour Geolix.Adapter

  @impl Geolix.Adapter
  def lookup(ip, _opts, %{database: database}), do: database.lookup(ip)

  @impl Geolix.Adapter
  def metadata(%{database: database}), do: database.metadata()
end
