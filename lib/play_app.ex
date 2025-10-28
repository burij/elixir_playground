defmodule PlayApp do
  def get_separator do
    Application.get_env(:play_app, :separator, "-")
  end

  def get_terminal_width do
    Application.get_env(:play_app, :terminal_width, 80)
  end
end
