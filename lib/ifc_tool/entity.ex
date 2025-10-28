defmodule IfcTool.Entity do
  def select(id) do
    IfcTool.Model.fetch()
    |> Enum.find(fn entity -> entity.id == id end)
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
