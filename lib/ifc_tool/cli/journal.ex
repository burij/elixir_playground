defmodule IfcTool.Cli.Journal do
  def loop(journal, ifc) do
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
        IfcTool.Cli.Ifc.loop(ifc)

      "t" ->
        IO.write("📔 " <> ifc <> ">journal>type?:")

        IO.gets("")
        |> String.trim()
        |> IfcTool.Model.by_type(journal)
        |> IO.inspect()

        loop(journal, ifc)

      "w" ->
        IO.write("📔 " <> ifc <> ">write journal>filename?:")

        header = IfcTool.Model.get_header(ifc)

        ifc =
          IO.gets("")
          |> String.trim()

        body = IfcTool.Model.compile_body(journal)
        IfcTool.Model.write(header, body, ifc)

        IfcTool.Cli.Ifc.loop(ifc)

      "l" ->
        IO.inspect(journal)
        loop(journal, ifc)

      "u" ->
        IO.write("📔 " <> ifc <> ">journal>update>#?:")

        IO.gets("")
        |> String.trim()
        |> String.to_integer()
        |> IfcTool.Entity.edit(journal)
        |> loop(ifc)

      _ when select ->
        IfcTool.Entity.select(id, journal)
        |> IO.inspect()

        loop(journal, ifc)

      _ ->
        IO.puts("🧱 invalid command")
        loop(journal, ifc)
    end
  end
end
