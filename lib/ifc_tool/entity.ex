defmodule IfcTool.Entity do
  def select(id, ifc \\ IfcTool.get_path()) do
    IfcTool.Model.fetch(ifc)
    |> Enum.find(fn entity -> entity.id == id end)
  end

  def edit(id, ifc \\ IfcTool.get_path()) do
    selected_entity = select(id, ifc)
    IO.puts("Current content of the entity ##{id}: ")
    IO.puts(selected_entity.content)
    IO.write("Enter the new content:")

    userdata =
      IO.gets("")
      |> String.trim()

    journal = IfcTool.Model.fetch(model)

    %{selected_entity | content: userdata}
    |> update_raw()
    |> IfcTool.Model.update(journal)
    |> IO.inspect()
  end

  def extract(line) do
    regex = ~r/^#(\d+)=(\w+)\((.*)\);/

    case Regex.run(regex, line, capture: :all) do
      [_, id_str, type_str, content] ->
        [
          %{
            id: String.to_integer(id_str),
            type: type_str,
            content: content,
            raw: String.trim_trailing(line)
          }
        ]

      _ ->
        # Ignore header lines, comments, or malformed lines
        []
    end
  end

  defp update_raw(entity) do
    updated_raw = "##{entity.id}=#{entity.type}(#{entity.content});"
    %{entity | raw: updated_raw}
  end
end
