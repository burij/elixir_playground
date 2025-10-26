defmodule PlayApp do
  @moduledoc """
  Documentation for `PlayApp`.

  Contain app wide varible; start/2 needs to be defined, if the
  application is using any persistent processses (for supervision).


  """

  def get_separator do
    Application.get_env(:play_app, :separator, "-")
  end

  def get_terminal_width do
    Application.get_env(:play_app, :terminal_width, 80)
  end
end
