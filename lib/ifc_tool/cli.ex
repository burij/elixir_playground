defmodule IfcTool.Cli do
  def run do
    IO.write(IO.ANSI.clear() <> IO.ANSI.home())
    IO.write("⁉️  no model. connect:")

    IO.gets("")
    |> String.trim()
    |> ifc_loop()
  end

  defp ifc_loop(ifc) do
    header = IfcTool.Model.get_header(ifc)
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

      "i" ->
        IO.inspect(header)
        ifc_loop(ifc)

      _ ->
        IO.puts("🧱 invalid command")
        ifc_loop(ifc)
    end
  end

  defp journal_loop(journal, ifc) do
    IO.write("📔 " <> ifc <> ">journal:")

    userinput =
      IO.gets("")
      |> String.trim()

    id =
      try do
        String.to_integer(userinput)
      rescue
        _ -> false
      end

    select = is_number(id)

    case userinput do
      "q" ->
        IO.puts("👋 exiting...")

      "e" ->
        IO.puts("⏏️  ejecting journal...")
        ifc_loop(ifc)

      "t" ->
        IO.write("📔 " <> ifc <> ">journal>type?:")

        IO.gets("")
        |> String.trim()
        |> IfcTool.Model.by_type(journal)
        |> IO.inspect()

        journal_loop(journal, ifc)

      "w" ->
        IO.write("📔 " <> ifc <> ">write journal>filename?:")

        header = IfcTool.Model.get_header(ifc)

        ifc =
          IO.gets("")
          |> String.trim()

        body = IfcTool.Model.compile_body(journal)
        IfcTool.Model.write(header, body, ifc)

        ifc_loop(ifc)

      "l" ->
        IO.inspect(journal)
        journal_loop(journal, ifc)

      "u" ->
        IO.write("📔 " <> ifc <> ">journal>update>#?:")

        IO.gets("")
        |> String.trim()
        |> String.to_integer()
        |> IfcTool.Entity.edit(journal)
        |> journal_loop(ifc)

      _ when select ->
        IfcTool.Entity.select(id, journal)
        |> IO.inspect()

        journal_loop(journal, ifc)

      _ ->
        IO.puts("🧱 invalid command")
        journal_loop(journal, ifc)
    end
  end
end
