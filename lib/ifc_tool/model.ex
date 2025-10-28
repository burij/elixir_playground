defmodule IfcTool.Model do
  def fetch(model \\ IfcTool.get_path) do
    parse_to_entities(model)
  end

  def by_type(ifc_type, model \\  IfcTool.get_path) do
    fetch(model)
    |> Enum.filter(fn entity -> entity.type == ifc_type end)
  end

  defp parse_to_entities(file_path) do
    File.stream!(file_path, [], :line)
    |> Stream.filter(&String.starts_with?(&1, "#"))
    |> Stream.flat_map(&IfcTool.Entity.extract/1)
    |> Enum.to_list()
  end
end
