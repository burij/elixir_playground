defmodule IfcTool.Cli.Ifc do
  def loop(ifc) do
    header = IfcTool.Model.get_header(ifc)
    IO.write("🏠 " <> ifc <> ":")

    IO.gets("")
    |> String.trim()
    |> case do
      "q" ->
        IO.puts("👋 exiting...")

      "e" ->
        IO.puts("⏏️  ejecting file...")
        IfcTool.Cli.run()

      "j" ->
        journal = IfcTool.Model.fetch(ifc)
        IfcTool.Cli.Journal.loop(journal, ifc)

      "i" ->
        IO.inspect(header)
        loop(ifc)

      _ ->
        IO.puts("🧱 invalid command")
        loop(ifc)
    end
  end
end
