defmodule IfcTool.Entity do
  def select(id, model \\ IfcTool.get_path()) do
    IfcTool.Model.fetch(model)
    |> Enum.find(fn entity -> entity.id == id end)
  end

  def edit(id, model \\ IfcTool.get_path()) do
    selected_entity = select(id, model)
    IO.puts("Current content of the entity ##{id}: ")
    IO.puts(selected_entity.content)
    IO.write("Enter the new content:")

    userdata =
      IO.gets("")
      |> String.trim()

    original_data = IfcTool.Model.fetch(model)

    %{selected_entity | content: userdata}
    |> IfcTool.Model.update(original_data)
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
            original_line: String.trim_trailing(line)
          }
        ]

      _ ->
        # Ignore header lines, comments, or malformed lines
        []
    end
  end

  def pack(entity) do
    "##{entity.id}=#{entity.type}(#{entity.content});\n"
  end
end
