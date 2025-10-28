defmodule IfcTool.Model do
  def fetch() do
    model = IfcTool.get_path()
    parse_to_entities(model)
  end

  def fetch(model) do
    parse_to_entities(model)
  end

  def by_type(ifc_type) do
    fetch()
    |> Enum.filter(fn entity -> entity.type == ifc_type end)
  end

  def by_type(model, ifc_type) do
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
