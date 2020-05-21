defmodule Geolix.Adapter.MMDB2Precompiled.Database do
  @moduledoc """
  Base module to extract database information during compilation.
  """

  use Bitwise, only_operators: true

  @mmdb2_opts_default Macro.escape(%{
                        double_precision: 8,
                        float_precision: 4,
                        map_keys: :strings
                      })

  defmacro __using__(opts) do
    source = opts[:source]
    mmdb2_opts = opts[:mmdb2_decoder_options] || @mmdb2_opts_default

    quote bind_quoted: [mmdb2_opts: mmdb2_opts, source: source], location: :keep do
      alias Geolix.Adapter.MMDB2Precompiled.Database

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
            |> MMDB2Decoder.lookup_pointer!(data, mmdb2_opts)
            |> Macro.escape()

          quote do
            defp lookup_result(unquote(pointer)), do: unquote(lookup_result)
          end
        end)

      Module.eval_quoted(__ENV__, results)

      defp lookup_result(_), do: nil

      meta_quoted = Macro.escape(meta)
      tree_quoted = Macro.escape(tree)

      Module.eval_quoted(
        __ENV__,
        quote do
          def lookup(ip) do
            case MMDB2Decoder.find_pointer(ip, unquote(meta_quoted), unquote(tree_quoted)) do
              {:ok, pointer} -> lookup_result(pointer)
              _ -> nil
            end
          end
        end
      )
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
