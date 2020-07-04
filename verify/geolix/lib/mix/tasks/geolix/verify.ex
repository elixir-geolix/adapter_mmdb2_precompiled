defmodule Mix.Tasks.Geolix.Verify do
  @moduledoc """
  Verifies Geolix results.
  """

  alias Geolix.Database.Loader

  use Mix.Task

  @shortdoc "Verifies parser results"

  @data_path Path.expand("../../../../..", __DIR__)
  @ip_set Path.join(@data_path, "ip_set.txt")
  @results Path.join(@data_path, "geolix_results.txt")

  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:geolix)
    true = wait_until_ready(5000)
    result_file = File.open!(@results, [:write, :utf8])

    @ip_set
    |> File.read!()
    |> String.split()
    |> check(result_file)
  end

  defp check([], _), do: :ok

  defp check([ip | ips], result_file) do
    country_data =
      ip
      |> Geolix.lookup(where: :country)
      |> parse_country()

    IO.puts(result_file, "#{ip}-#{country_data}")

    check(ips, result_file)
  end

  defp parse_country(%{"country" => %{"names" => %{"en" => name}}}), do: name
  defp parse_country(_), do: ""

  defp wait_until_ready(0), do: false

  defp wait_until_ready(timeout) do
    Loader.loaded_databases()
    |> Enum.sort()
    |> case do
      [:country] ->
        true

      _ ->
        :timer.sleep(10)
        wait_until_ready(timeout - 10)
    end
  end
end
