defmodule IfcTool.Cli do
  def run do
    IO.write(IO.ANSI.clear() <> IO.ANSI.home())
    IO.write("⁉️  no model. connect:")

    IO.gets("")
    |> String.trim()
    |> loop()
  end

  defp loop(ifc) do
    IfcTool.Model.get_header(ifc)
    IO.write("🏠 " <> ifc <> ":")

    IO.gets("")
    |> String.trim()
    |> router(ifc)
  end

  defp router(cmd, ifc) do
    case cmd do
      "q" ->
        IO.puts("👋 exiting...")

      "journal" ->
        IfcTool.Model.fetch(ifc)
        |> IO.inspect()

        loop(ifc)

      _ ->
        IO.puts("🤦‍♂️ invalid command")
        loop(ifc)
    end
  end
end
