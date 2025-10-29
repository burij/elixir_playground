defmodule IfcTool do
  def get_path do
    "input.ifc"
  end

  def run do
    IfcTool.Cli.run()
  end
end
