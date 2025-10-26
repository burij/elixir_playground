defmodule IfcTool do
  def run do
    parse_to_raw_entities("input.ifc")
  end

  defp parse_to_raw_entities(file_path) do
    File.stream!(file_path, [], :line)
    |> Stream.filter(&String.starts_with?(&1, "#"))
    # |> Stream.flat_map(&extract_entity/1) # Process each line
    |> Enum.to_list()
  end
end
