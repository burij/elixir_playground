defmodule IfcTool.Cli do
  def run do
    IO.write(IO.ANSI.clear() <> IO.ANSI.home())
    IO.write("⁉️  no model. connect:")

    IO.gets("")
    |> String.trim()
    |> IfcTool.Cli.Ifc.loop()
  end
end
