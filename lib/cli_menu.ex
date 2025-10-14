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

    IO.inspect(IdeasDB.read())

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
    Utils.draw_line(PlayApp.conf().separator, PlayApp.conf().terminal_width)
  end

  defp menu_loop() do
    display_menu()

    case Utils.read_input() do
      "1" ->
        Idea.post()
        menu_loop()

      "2" ->
        idea = Idea.select()
        Idea.vote(idea)
        menu_loop()

      "q" ->
        IO.puts("Exiting...")

      _ ->
        IO.puts("Option does not exist, try again:")
        menu_loop()
    end
  end
end
