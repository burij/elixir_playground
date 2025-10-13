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
        save_idea()
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
    IO.puts("""
    ----------------------------------------------------------------------------
    Current project ideas:
    """)

    IO.inspect(ideas_from_db())

    IO.puts("""

    ----------------------------------------------------------------------------
    Please select an option:
    1. Put a new idea out there
    2. Up/Downvote an idea
    q. Quit
    ----------------------------------------------------------------------------

    """)

    IO.write("Enter your choice: ")
  end

  defp read_input do
    IO.gets("")
    |> String.trim()
    |> String.downcase()
  end

  defp save_idea do
    IO.write("Enter your idea: ")

    _new_idea =
      IO.gets("")
      |> String.trim()
      |> idea_to_db()
  end

  defp ideas_from_db do
    _ideas =
      File.read!("ideas.dat")
      |> :erlang.binary_to_term()
  end

  defp idea_to_db(input) do
    idea_entry = construct_entry(input)
    ideas_list = idea_entry ++ ideas_from_db()
    result = :erlang.term_to_binary(ideas_list)
    File.write!("ideas.dat", result)
    IO.puts("Your idea '#{input}' has been saved...")
  end

  defp construct_entry(input) do
    result = %{
      id: :crypto.strong_rand_bytes(2) |> Base.encode16(case: :lower),
      content: input,
      votes: 1
    }

    [result]
  end
end
