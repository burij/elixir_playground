defmodule IfcTool.Model do
  def fetch(ifc \\ IfcTool.get_path()) do
    parse_to_entities(ifc)
  end

  def by_type(type, ifc \\ IfcTool.get_path()) do
    fetch(ifc)
    |> Enum.filter(fn entity -> entity.type == type end)
  end

  def update(updated_entity, journal) do
    Enum.map(journal, fn entity ->
      if entity.id == updated_entity.id do
        updated_entity
      else
        entity
      end
    end)
  end

  def compile_body(journal) do
    Enum.map(journal, fn entity ->
      "#{entity.raw}\n"
    end)
  end

  defp parse_to_entities(file_path) do
    File.stream!(file_path, [], :line)
    |> Stream.filter(&String.starts_with?(&1, "#"))
    |> Stream.flat_map(&IfcTool.Entity.extract/1)
    |> Enum.to_list()
  end
end
