defmodule PlayApp.CliMenu do
  @moduledoc "Simple CLI menu for triggering specific app features"

  def run do
    IO.puts("Staring up internal script...")
    menu_loop()
  end

  defp menu_loop() do
    display_menu()

    case read_input() do
      "1" ->
        # TODO Task logic
        menu_loop()

      "2" ->
        # TODO Task logic
        menu_loop()

      "q" ->
        IO.puts("Exiting...")

      _ ->
        IO.puts("Option does not exist, try again:")
        menu_loop()
    end
  end

  defp display_menu do
    IO.puts("---------------------------------")
    IO.puts("Please select an option:")
    IO.puts("1. Run Task A")
    IO.puts("2. Run Task B")
    IO.puts("q. Quit")
    IO.puts("---------------------------------")
    IO.write("Enter your choice: ")
  end

  defp read_input do
    IO.gets("")
    |> String.trim()
    |> String.downcase()
  end
end
