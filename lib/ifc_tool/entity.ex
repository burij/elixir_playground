defmodule IfcTool.Entity do
  def select(id) do
    IfcTool.Model.fetch()
    |> Enum.find(fn entity -> entity.id == id end)
  end

  def select(model, id) do
    IfcTool.Model.fetch(model)
    |> Enum.find(fn entity -> entity.id == id end)
  end

  def edit(id) do
    data = select(id)
    IO.puts("Current content of the entity ##{id}: ")
    IO.puts(data.content)
    IO.write("Enter the new content:")

    userdata =
      IO.gets("")
      |> String.trim()

    %{data | content: userdata}
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
end
