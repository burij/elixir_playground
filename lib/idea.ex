defmodule Idea do
  def post do
    IO.write("Enter your idea: ")

    _new_idea =
      IO.gets("")
      |> String.trim()
      |> IdeasDB.write()
  end

  def vote(_idea) do
    case Utils.read_input() do
      "y" -> IO.puts("upvote")
      "n" -> IO.puts("downvote")
      _ -> "That's not a valid option!"
    end
  end

  def select do
    IO.write("Enter idea id: ")
    id = Utils.read_input()

    ideas = IdeasDB.read()

    selected_idea =
      Enum.find(ideas, fn idea ->
        idea.id == id
      end)

    case selected_idea do
      nil ->
        IO.puts(IO.puts("The '#{id}' is not in the list!"))
        select()

      %{content: content} ->
        IO.write("Do you like the idea '#{content}'? (y/n):\n")
    end

    selected_idea
  end
end
