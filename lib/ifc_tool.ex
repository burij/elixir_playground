defmodule IfcTool do
  def get_path do
    "input.ifc"
  end

  def run do
    IfcTool.Model.fetch()
  end
end
