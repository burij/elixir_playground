defmodule IfcTool.Model do
  def fetch(ifc \\ IfcTool.get_path()) do
    parse_to_entities(ifc)
  end

  def get_header(ifc \\ IfcTool.get_path()) do
    header =
      ifc
      |> File.stream!([], :line)
      |> Stream.take_while(fn line -> String.trim(line) != "DATA;" end)
      |> Enum.to_list()

    header ++ ["DATA;\n"]
  end

  def by_type(type, ifc \\ IfcTool.get_path()) do
    search_term = String.upcase(type)

    fetch(ifc)
    |> Enum.filter(fn entity -> entity.type == search_term end)
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

  def write(header, body, ifc \\ "output.ifc") do
    File.write(ifc, header ++ body)
  end

  defp parse_to_entities(ifc) do
    File.stream!(ifc, [], :line)
    |> Stream.filter(&String.starts_with?(&1, "#"))
    |> Stream.flat_map(&IfcTool.Entity.extract/1)
    |> Enum.to_list()
  end
end
