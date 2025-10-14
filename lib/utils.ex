defmodule Utils do
  @doc """
  Prints a line of characters.
  """
  def draw_line(char, count) when is_binary(char) and is_integer(count) do
    IO.puts(String.duplicate(char, count))
  end

  def read_input do
    IO.gets("")
    |> String.trim()
    |> String.downcase()
  end
end
