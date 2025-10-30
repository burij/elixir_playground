defmodule IfcTool.Cli do
  def run do
    IO.write(IO.ANSI.clear() <> IO.ANSI.home())
    IO.write("⁉️  no model. connect:")

    IO.gets("")
    |> String.trim()
    |> ifc_loop()
  end

  defp ifc_loop(ifc) do
    IfcTool.Model.get_header(ifc)
    IO.write("🏠 " <> ifc <> ":")

    IO.gets("")
    |> String.trim()
    |> case do
      "q" ->
        IO.puts("👋 exiting...")

      "e" ->
        IO.puts("⏏️  ejecting file...")
        run()

      "j" ->
        journal = IfcTool.Model.fetch(ifc)
        journal_loop(journal, ifc)

      _ ->
        IO.puts("🧱 invalid command")
        ifc_loop(ifc)
    end
  end

  defp journal_loop(journal, ifc) do
    IO.write("🤿 " <> ifc <> ">journal:")

    IO.gets("")
    |> String.trim()
    |> case do
      "q" ->
        IO.puts("👋 exiting...")

      "e" ->
        IO.puts("⏏️  ejecting journal...")
        ifc_loop(ifc)

      "l" ->
        IO.inspect(journal)
        journal_loop(journal, ifc)

      _ ->
        IO.puts("🧱 invalid command")
        journal_loop(journal, ifc)
    end
  end
end
