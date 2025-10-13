defmodule PlayApp do
  @moduledoc """
  Documentation for `PlayApp`.

  Contain app wide varible; start/2 needs to be defined, if the
  application is using any persistent processses (for supervision).


  """

  def conf do
    %{
      separator: "-",
      terminal_width: 80
    }
  end
end
