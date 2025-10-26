defmodule CliMenu.Idea do
  def post do
    IO.write("Enter your idea: ")

    _new_idea =
      IO.gets("")
      |> String.trim()
      |> CliMenu.IdeasDB.add()
  end

  def vote(idea) do
    case PlayApp.Utils.read_input() do
      "y" -> new_vote(idea, 1)
      "n" -> new_vote(idea, -1)
      _ -> "That's not a valid option!"
    end
  end

  defp new_vote(idea, value) do
    IO.puts(idea.id)
    db = CliMenu.IdeasDB.read()

    new_score =
      Enum.map(db, fn db ->
        case db.id == idea.id do
          true -> %{db | votes: db.votes + value}
          false -> db
        end
      end)

    result =
      Enum.reject(new_score, fn new_score ->
        new_score.votes < 1
      end)

    CliMenu.IdeasDB.rewrite(result)
  end

  def select do
    IO.write("Enter idea id: ")
    id = PlayApp.Utils.read_input()

    ideas = CliMenu.IdeasDB.read()

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
