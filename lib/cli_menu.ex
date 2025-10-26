defmodule CliMenu do
  @moduledoc "Simple CLI menu for triggering specific app features"

  def run do
    IO.puts("Staring up internal script...")
    menu_loop()
  end

  defp display_menu do
    line()

    IO.puts("""
    Current project ideas:
    """)

    IO.inspect(CliMenu.IdeasDB.read())

    line()

    IO.puts("""
    Please select an option:
    1. Put a new idea out there
    2. Up/Downvote an idea
    q. Quit
    """)

    line()

    IO.write("Enter your choice: ")
  end

  defp line do
    PlayApp.Utils.draw_line(
      PlayApp.get_separator(),
      PlayApp.get_terminal_width()
    )
  end

  defp menu_loop() do
    display_menu()

    case PlayApp.Utils.read_input() do
      "1" ->
        CliMenu.Idea.post()
        menu_loop()

      "2" ->
        idea = CliMenu.Idea.select()
        CliMenu.Idea.vote(idea)
        menu_loop()

      "q" ->
        IO.puts("Exiting...")

      _ ->
        IO.puts("Option does not exist, try again:")
        menu_loop()
    end
  end
end
