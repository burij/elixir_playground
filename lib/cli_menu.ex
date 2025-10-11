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
        get_idea()
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
    IO.puts("1. Put a new idea out there")
    IO.puts("2. Up/Downvote an idea")
    IO.puts("q. Quit")
    IO.puts("---------------------------------")
    IO.write("Enter your choice: ")
  end

  defp read_input do
    IO.gets("")
    |> String.trim()
    |> String.downcase()
  end

  defp get_idea do
    IO.write("Enter your idea: ")
    new_idea = IO.gets("") |> String.trim()
    IO.puts("Your idea '#{new_idea}' has been saved...")
    new_idea
  end
end
