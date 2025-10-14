defmodule CliMenu do
  @moduledoc "Simple CLI menu for triggering specific app features"

  def run do
    IO.puts("Staring up internal script...")
    menu_loop()
  end

  defp line do
    Utils.draw_line(PlayApp.conf().separator, PlayApp.conf().terminal_width)
  end

  defp menu_loop() do
    display_menu()

    case read_input() do
      "1" ->
        post_idea()
        menu_loop()

      "2" ->
        idea = select_idea()
        vote(idea)
        menu_loop()

      "q" ->
        IO.puts("Exiting...")

      _ ->
        IO.puts("Option does not exist, try again:")
        menu_loop()
    end
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

  defp read_input do
    IO.gets("")
    |> String.trim()
    |> String.downcase()
  end

  defp post_idea do
    IO.write("Enter your idea: ")

    _new_idea =
      IO.gets("")
      |> String.trim()
      |> IdeasDB.write()
  end

  defp select_idea do
    IO.write("Enter idea id: ")
    id = read_input()

    ideas = IdeasDB.read()

    selected_idea =
      Enum.find(ideas, fn idea ->
        idea.id == id
      end)

    case selected_idea do
      nil ->
        IO.puts(IO.puts("The '#{id}' is not in the list!"))
        select_idea()

      %{content: content} ->
        IO.write("Do you like the idea '#{content}'? (y/n):\n")
    end

    selected_idea
  end

  defp vote(_idea) do
    case read_input() do
      "y" -> IO.puts("upvote")
      "n" -> IO.puts("downvote")
      _ -> "That's not a valid option!"
    end
  end
end
