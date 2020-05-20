defmodule Geolix.Adapter.MMDB2Precompiled.Database do
  @moduledoc """
  Base module to extract database information during compilation.
  """

  use Bitwise, only_operators: true

  defmacro __using__(source: source) do
    quote bind_quoted: [source: source], location: :keep do
      alias Geolix.Adapter.MMDB2Precompiled.Database

      @mmdb2_opts %{double_precision: 8, float_precision: 4, map_keys: :strings}

      {:ok, meta, tree, data} =
        source
        |> File.read!()
        |> MMDB2Decoder.parse_database()

      results =
        tree
        |> Database.tree_pointers(meta)
        |> Enum.map(fn pointer ->
          lookup_result =
            pointer
            |> MMDB2Decoder.lookup_pointer!(data, @mmdb2_opts)
            |> Macro.escape()

          quote do
            def lookup_result(unquote(pointer)), do: unquote(lookup_result)
          end
        end)

      Module.eval_quoted(__ENV__, results)
    end
  end

  def tree_pointers(tree, %{node_count: node_count, record_size: record_size}) do
    tree
    |> tree_pointers_extract(node_count, record_size, [])
    |> Enum.uniq()
  end

  defp tree_pointers_extract("", _, _, pointers), do: pointers

  defp tree_pointers_extract(tree, node_count, record_size, pointers) do
    {pointer_left, pointer_right, rest} =
      case record_size do
        28 ->
          <<left_low::size(24), left_high::size(4), right::size(28), rest::binary>> = tree

          {left_low + (left_high <<< 24), right, rest}

        _ ->
          <<left::size(record_size), right::size(record_size), rest::binary>> = tree

          {left, right, rest}
      end

    pointers =
      if pointer_left > node_count do
        [pointer_left - node_count - 16 | pointers]
      else
        pointers
      end

    pointers =
      if pointer_right > node_count do
        [pointer_right - node_count - 16 | pointers]
      else
        pointers
      end

    tree_pointers_extract(rest, node_count, record_size, pointers)
  end
end
