defmodule IfcTool do
  def run do
    parse_to_raw_entities("input.ifc")
  end

  defp parse_to_raw_entities(file_path) do
    File.stream!(file_path, [], :line)
    |> Stream.filter(&String.starts_with?(&1, "#"))
    |> Stream.flat_map(&extract_entity/1)
    |> Enum.to_list()
  end

  defp extract_entity(line) do
    regex = ~r/^#(\d+)=(\w+)\((.*)\);/

    case Regex.run(regex, line, capture: :all) do
      [_, id_str, type_str, content] ->
        [
          %{
            id: String.to_integer(id_str),
            type: type_str,
            content: content,
            original_line: String.trim_trailing(line)
          }
        ]

      _ ->
        # Ignore header lines, comments, or malformed lines
        []
    end
  end

end
