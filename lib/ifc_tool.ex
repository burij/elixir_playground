defmodule IfcTool do
  def get_path do
    Application.get_env(:play_app, :path, "input.ifc")
  end

  def run do
    IfcTool.Cli.run()
  end
end
